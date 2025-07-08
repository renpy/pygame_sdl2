#pyright: basic
import os
import sys
import re
import subprocess
import platform
import shutil
import sysconfig
import setuptools

# The version of pygame_sdl2. This should also be updated in version.py
VERSION = "2.1.0"

# The include and library dirs that we compile against.
include_dirs = [ ".", "src" ]
library_dirs = [ ]

# Extra arguments that will be given to the compiler.
extra_compile_args = [ ]
extra_link_args = [ ]

# Data files (including DLLs) to include with the package.
package_data = [ ]

# A list of extension objects that we use.
extensions = [ ]

# A list of macros that are defined for all modules.
global_macros = [ ]

# True if we're doing a static build.
static = "PYGAME_SDL2_STATIC" in os.environ

windows = platform.win32_ver()[0]

# The cython command.
if windows:
    cython_command = os.path.join(os.path.dirname(sys.executable), "Scripts", "cython.exe")
else:
    cython_command = "cython"

if sys.version_info[0] >= 3:
    gen = "gen3"
else:
    gen = "gen"

version_flag = "--3str"

if static:
    gen = gen + "-static"


def parse_cflags(command):
    """
    Runs `command`, and uses the command's output to set up include_dirs
    and extra_compile_args. if `command` is None, parses the cflags from
    the environment.
    """

    if "PYGAME_SDL2_CFLAGS" in os.environ:
        output = os.environ["PYGAME_SDL2_CFLAGS"]
    elif command is not None:
        output = subprocess.check_output(command, universal_newlines=True)
    else:
        output = os.environ.get("CFLAGS", "")

    for i in output.split():
        if i.startswith("-I"):
            include_dirs.append(i[2:])
        else:
            extra_compile_args.append(i)


parse_cflags(None)


def parse_libs(command):
    """
    Runs `command`, and uses the command's output to set up library_dirs and
    extra_link_args. Returns a list of libraries to link against. If `command`
    is None, parses LDFLAGS from the environment.
    """

    if "PYGAME_SDL2_LDFLAGS" in os.environ:
        output = os.environ["PYGAME_SDL2_LDFLAGS"]
    else:
        output = subprocess.check_output(command, universal_newlines=True)

    libs = [ ]

    for i in output.split():
        if i.startswith("-L"):
            library_dirs.append(i[2:])
        elif i.startswith("-l"):
            libs.append(i[2:])
        else:
            extra_compile_args.append(i)

    return libs


# A list of modules we do not wish to include.
exclude = set(os.environ.get("PYGAME_SDL2_EXCLUDE", "").split())


def cmodule(name, source, libs=[], define_macros=[]):
    """
    Compiles the python module `name` from the files given in
    `source`, and the libraries in `libs`.
    """

    if name in exclude:
        return

    extensions.append(setuptools.Extension(
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
        print("Could not find {0}.".format(fn))
        sys.exit(-1)

    # Figure out what it depends on.
    deps = [ fn ]

    f = open(fn, "r")
    for line in f:

        m = re.search(r'from\s*([\w.]+)\s*cimport', line)
        if m:
            deps.append(m.group(1).replace(".", "/") + ".pxd")
            continue

        m = re.search(r'cimport\s*([\w.]+)', line)
        if m:
            deps.append(m.group(1).replace(".", "/") + ".pxd")
            continue

        m = re.search(r'include\s*"(.*?)"', line)
        if m:
            deps.append(m.group(1))
            continue
    f.close()

    # Filter out cython stdlib dependencies.
    deps = [ i for i in deps if (not i.startswith("cpython/")) and (not i.startswith("libc/")) ]

    # Determine if any of the dependencies are newer than the c file.
    c_fn = os.path.join(gen, name + ".c")
    necessary_gen.append(name + ".c")

    if os.path.exists(c_fn):
        c_mtime = os.path.getmtime(c_fn)
    else:
        c_mtime = 0

    out_of_date = False

    # print c_fn, "depends on", deps

    for dep_fn in deps:

        if os.path.exists(os.path.join("src", dep_fn)):
            dep_fn = os.path.join("src", dep_fn)
        elif os.path.exists(os.path.join("include", dep_fn)):
            dep_fn = os.path.join("include", dep_fn)
        elif os.path.exists(os.path.join(gen, dep_fn)):
            dep_fn = os.path.join(gen, dep_fn)
        elif os.path.exists(dep_fn):
            pass
        else:
            print("{0} depends on {1}, which can't be found.".format(fn, dep_fn))
            sys.exit(-1)

        if os.path.getmtime(dep_fn) > c_mtime:
            out_of_date = True

    if out_of_date and not cython_command:
        print("WARNING:", name, "is out of date, but RENPY_CYTHON isn't set.")
        out_of_date = False

    # If the file is out of date, regenerate it.
    if out_of_date:
        print(name, "is out of date.")

        try:
            subprocess.check_call([
                cython_command,
                version_flag,
                "-X", "profile=False",
                "-X", "embedsignature=True",
                "-Iinclude",
                "-I" + gen,
                "-a",
                fn,
                "-o",
                c_fn])

            # Fix-up source for static loading
            if static:

                parent_module = '.'.join(split_name[:-1])
                parent_module_identifier = parent_module.replace('.', '_')

                with open(c_fn, 'r') as f:
                    ccode = f.read()

                with open(c_fn + ".dynamic", 'w') as f:
                    f.write(ccode)

                if len(split_name) > 1:

                    ccode = re.sub(r'Py_InitModule4\("([^"]+)"', 'Py_InitModule4("' + parent_module + '.\\1"', ccode) # Py2
                    ccode = re.sub(r'(__pyx_moduledef.*?"){}"'.format(re.escape(split_name[-1])), '\\1' + '.'.join(split_name) + '"', ccode, count=1, flags=re.DOTALL) # Py3
                    ccode = re.sub(r'^__Pyx_PyMODINIT_FUNC init', '__Pyx_PyMODINIT_FUNC init' + parent_module_identifier + '_', ccode, 0, re.MULTILINE) # Py2 Cython 0.28+
                    ccode = re.sub(r'^__Pyx_PyMODINIT_FUNC PyInit_', '__Pyx_PyMODINIT_FUNC PyInit_' + parent_module_identifier + '_', ccode, 0, re.MULTILINE) # Py3 Cython 0.28+
                    ccode = re.sub(r'^PyMODINIT_FUNC init', 'PyMODINIT_FUNC init' + parent_module_identifier + '_', ccode, 0, re.MULTILINE) # Py2 Cython 0.25.2

                with open(c_fn, 'w') as f:
                    f.write(ccode)

        except subprocess.CalledProcessError as e:
            print()
            print(str(e))
            print()
            sys.exit(-1)

    # Build the module normally once we have the c file.
    if compile_if:
        cmodule(name, [ c_fn ] + source, libs=libs, define_macros=define_macros)


def find_unnecessary_gen():

    for i in os.listdir(gen):
        if not i.endswith(".c"):
            continue

        if i in necessary_gen:
            continue

        print("Unnecessary file", os.path.join(gen, i))


py_modules = [ ]


def pymodule(name):
    """
    Causes a python module to be included in the build.
    """

    if name in exclude:
        return

    py_modules.append(name)


def setup(name, version, **kwargs):
    """
    Calls the distutils setup function.
    """

    global extensions

    if (len(sys.argv) >= 2) and (sys.argv[1] == "generate"):
        return

    if "--no-extensions" in sys.argv:
        sys.argv = [ i for i in sys.argv if i != "--no-extensions" ]
        extensions = [ ]

    setuptools.setup(
        name=name,
        version=version,
        ext_modules=extensions,
        py_modules=py_modules,
        packages=[ name ],
        package_dir={ name : 'src/' + name },
        package_data={ name : package_data },
        zip_safe=False,
        **kwargs
        )

temporary_package_data = [ ]

package_data.extend([
    "DejaVuSans.ttf",
    "DejaVuSans.txt",
    ])

parse_cflags([ "sh", "-c", "sdl2-config --cflags" ])
sdl_libs = parse_libs([ "sh", "-c", "sdl2-config --libs" ])

pymodule("pygame_sdl2.__init__")
pymodule("pygame_sdl2.compat")
pymodule("pygame_sdl2.threads.__init__")
pymodule("pygame_sdl2.threads.Py25Queue")
pymodule("pygame_sdl2.sprite")
pymodule("pygame_sdl2.sysfont")
pymodule("pygame_sdl2.time")
pymodule("pygame_sdl2.version")

cython("pygame_sdl2.error", libs=sdl_libs)
cython("pygame_sdl2.color", libs=sdl_libs)
cython("pygame_sdl2.controller", libs=sdl_libs)
cython("pygame_sdl2.rect", libs=sdl_libs)
cython("pygame_sdl2.rwobject", libs=sdl_libs)
cython("pygame_sdl2.surface", source=[ "src/alphablit.c" ], libs=sdl_libs)
cython("pygame_sdl2.display", libs=sdl_libs)
cython("pygame_sdl2.event", libs=sdl_libs)
cython("pygame_sdl2.locals", libs=sdl_libs)
cython("pygame_sdl2.key", libs=sdl_libs)
cython("pygame_sdl2.mouse", libs=sdl_libs)
cython("pygame_sdl2.joystick", libs=sdl_libs)
cython("pygame_sdl2.power", libs=sdl_libs)
cython("pygame_sdl2.pygame_time", libs=sdl_libs)
cython("pygame_sdl2.image", source=[ "src/write_jpeg.c", "src/write_png.c" ], libs=[ 'SDL2_image', "jpeg", "png" ] + sdl_libs)
cython("pygame_sdl2.transform", source=[ "src/SDL2_rotozoom.c" ], libs=sdl_libs)
cython("pygame_sdl2.gfxdraw", source=[ "src/SDL_gfxPrimitives.c" ], libs=sdl_libs)
cython("pygame_sdl2.draw", libs=sdl_libs)
cython("pygame_sdl2.font", libs=['SDL2_ttf'] + sdl_libs)
cython("pygame_sdl2.mixer", libs=['SDL2_mixer'] + sdl_libs)
cython("pygame_sdl2.mixer_music", libs=['SDL2_mixer'] + sdl_libs)
cython("pygame_sdl2.scrap", libs=sdl_libs)
cython("pygame_sdl2.render", libs=['SDL2_image'] + sdl_libs)

headers = [
    "src/pygame_sdl2/pygame_sdl2.h",
    gen + "/pygame_sdl2.rwobject_api.h",
    gen + "/pygame_sdl2.surface_api.h",
    gen + "/pygame_sdl2.display_api.h",
    ]

if __name__ == "__main__":


    if sys.version_info.major <= 3 and sys.version_info.minor <= 11:
        py_headers = headers
        headers = [ ]
    else:
        py_headers = [ ]

    setup(
        "pygame_sdl2",
        VERSION,
        headers=py_headers,
        url="https://github.com/renpy/pygame_sdl2",
        maintainer="Tom Rothamel",
        maintainer_email="tom@rothamel.us",
        )

    find_unnecessary_gen()

    for i in temporary_package_data:
        os.unlink(os.path.join(os.path.dirname(__file__), "src", "pygame_sdl2", i))

    if headers:
        import pathlib

        virtual_env = os.environ.get("VIRTUAL_ENV", None)

        if virtual_env:
            headers_dir = pathlib.Path(virtual_env) / "include" / "pygame_sdl2"
        else:
            headers_dir = pathlib.Path(sysconfig.get_paths()['include']) / "pygame_sdl2"

        headers_dir.mkdir(parents=True, exist_ok=True)

        for header in headers:
            srcpath = pathlib.Path(header)
            dstpath = headers_dir / srcpath.name

            shutil.copy(srcpath, dstpath)
