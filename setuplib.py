# Copyright 2014 Tom Rothamel <tom@rothamel.us>
#
# This software is provided 'as-is', without any express or implied
# warranty.  In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.

import os
import sys
import re
import subprocess

import distutils.core

# The cython command.
cython_command = "cython"

# The include and library dirs that we compile against.
include_dirs = [ "." ]
library_dirs = [ ]

# Extra arguments that will be given to the compiler.
extra_compile_args = [ ]
extra_link_args = [ ]

# A list of extension objects that we use.
extensions = [ ]

# A list of macros that are defined for all modules.
global_macros = [ ]

def parse_cflags(command):
    """
    Runs `command`, and uses the command's output to set up include_dirs
    and extra_compile_args.
    """

    output = subprocess.check_output(command, shell=True)

    for i in output.split():
        if i.startswith("-I"):
            include_dirs.append(i[2:])
        else:
            extra_compile_args.append(i)

def parse_libs(command):
    """
    Runs `command`, and uses the command's output to set up library_dirs and
    extra_link_args. Returns a list of libraries to link against.
    """

    output = subprocess.check_output(command, shell=True)

    libs = [ ]

    for i in output.split():
        if i.startswith("-L"):
            include_dirs.append(i[2:])
        elif i.startswith("-l"):
            libs.append(i[2:])
        else:
            extra_compile_args.append(i)

    return libs

def cmodule(name, source, libs=[], define_macros=[]):
    """
    Compiles the python module `name` from the files given in
    `source`, and the libraries in `libs`.
    """

    extensions.append(distutils.core.Extension(
        name,
        source,
        include_dirs=include_dirs,
        library_dirs=library_dirs,
        extra_compile_args=extra_compile_args,
        extra_link_args=extra_link_args,
        libraries=libs,
        define_macros=define_macros + global_macros,
        ))


necessary_gen = [ ]

def cython(name, source=[], libs=[], compile_if=True, define_macros=[]):
    """
    Compiles a cython module. This takes care of regenerating it as necessary
    when it, or any of the files it depends on, changes.
    """

    # Find the pyx file.
    split_name = name.split(".")

    fn = "src/" + "/".join(split_name) + ".pyx"

    if not os.path.exists(fn):
        print "Could not find {0}.".format(fn)
        sys.exit(-1)

    module_dir = os.path.dirname(fn)

    # Figure out what it depends on.
    deps = [ fn ]

    f = file(fn)
    for l in f:

        m = re.search(r'from\s*([\w.]+)\s*cimport', l)
        if m:
            deps.append(m.group(1).replace(".", "/") + ".pxd")
            continue

        m = re.search(r'cimport\s*([\w.]+)', l)
        if m:
            deps.append(m.group(1).replace(".", "/") + ".pxd")
            continue

        m = re.search(r'include\s*"(.*?)"', l)
        if m:
            deps.append(m.group(1))
            continue
    f.close()

    # Filter out cython stdlib dependencies.
    deps = [ i for i in deps if (not i.startswith("cpython/")) and (not i.startswith("libc/")) ]

    # Determine if any of the dependencies are newer than the c file.
    c_fn = os.path.join("gen", name + ".c")
    necessary_gen.append(name + ".c")

    if os.path.exists(c_fn):
        c_mtime = os.path.getmtime(c_fn)
    else:
        c_mtime = 0

    out_of_date = False

    # print c_fn, "depends on", deps

    for dep_fn in deps:

        if os.path.exists(os.path.join(module_dir, dep_fn)):
            dep_fn = os.path.join(module_dir, dep_fn)
        elif os.path.exists(os.path.join("..", dep_fn)):
            dep_fn = os.path.join("..", dep_fn)
        elif os.path.exists(os.path.join("include", dep_fn)):
            dep_fn = os.path.join("include", dep_fn)
        elif os.path.exists(os.path.join("gen", dep_fn)):
            dep_fn = os.path.join("gen", dep_fn)
        elif os.path.exists(dep_fn):
            pass
        else:
            print "{0} depends on {1}, which can't be found.".format(fn, dep_fn)
            sys.exit(-1)

        if os.path.getmtime(dep_fn) > c_mtime:
            out_of_date = True

    if out_of_date and not cython_command:
        print "WARNING:", name, "is out of date, but RENPY_CYTHON isn't set."
        out_of_date = False

    # If the file is out of date, regenerate it.
    if out_of_date:
        print name, "is out of date."

        try:
            subprocess.check_call([
                cython_command,
                "-Iinclude",
                "-Igen",
                "-a",
                fn,
                "-o",
                c_fn])

        except subprocess.CalledProcessError, e:
            print
            print str(e)
            print
            sys.exit(-1)

    # Build the module normally once we have the c file.
    if compile_if:
        cmodule(name, [ c_fn ] + source, libs=libs, define_macros=define_macros)

def find_unnecessary_gen():

    for i in os.listdir("gen"):
        if not i.endswith(".c"):
            continue

        if i in necessary_gen:
            continue

        print "Unnecessary file", os.path.join("gen", i)


py_modules = [ ]

def pymodule(name):
    """
    Causes a python module to be included in the build.
    """

    py_modules.append(name)

def setup(name, version):
    """
    Calls the distutils setup function.
    """

    distutils.core.setup(
        name = name,
        version = version,
        ext_modules = extensions,
        py_modules = py_modules,
        package_dir = { '' : 'src' },
        )

# Start in the directory containing setup.py.
os.chdir(os.path.abspath(os.path.dirname(sys.argv[0])))

# Ensure the gen directory exists.
if not os.path.exists("gen"):
    os.mkdir("gen")
