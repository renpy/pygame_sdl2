#!/usr/bin/env python

import pycparser
import pycparser.c_generator
import pycparser.c_ast as c_ast

import sys

cgen = pycparser.c_generator.CGenerator()


anonymous_serial = 0

def anonymous(n):
    global anonymous_serial
    anonymous_serial += 1

    if isinstance(n, c_ast.Union):
        kind = "union"
    elif isinstance(n, c_ast.Struct):
        kind = "struct"
    else:
        raise Exception("unknown node")

    if n.name:
        name = n.name
    else:
        name = "anon"

    return "{}_{}_{}".format(name, kind, anonymous_serial)


class Writer(object):
    def __init__(self, s):
        self.first = s
        self.rest = [ ]

    def add(self, s):
        self.rest.append(s)

    def write(self):
        sys.stdout.write(self.first + "\n")
        for i in self.rest:
            sys.stdout.write("    " + i + "\n")

        sys.stdout.write("\n")

def reorganize_decl(n):
    """
    Turns nested declarations into anonymous declarations.
    """

    if isinstance(n, (c_ast.Union, c_ast.Struct)):
        name = n.name
        if not name:
            name = anonymous(n)

        if n.decls:
            generate_decl(n, 'cdef ', name)

        return c_ast.IdentifierType(names=[ name ])

    for name, child in n.children():

        new_child = reorganize_decl(child)

        if new_child is not child:

            if "[" in name:
                field, _, num = name[:-1].partition("[")
                getattr(n, field)[int(num)] = new_child
            else:
                setattr(n, name, new_child)

    return n

def generate_struct_or_union(kind, n, ckind, name):
    """
    Generates a struct or union.
    """

    if name is None:
        name = n.name

    w = Writer("{}{} {}:".format(ckind, kind, name))

    if n.decls:
        for i in n.decls:
            i = reorganize_decl(i)
            w.add(cgen.visit(i))

    w.write()


def generate_decl(n, ckind='', name=None):
    """
    Produces a declaration from `n`.

    `ckind`
        The cython-kind of declaration to produce. Either 'cdef' or 'ctypedef'.

    `name`
        The name of the declaration we're producing, if known.
    """

    if isinstance(n, c_ast.Typedef):
        if name is None:
            name = n.name

        generate_decl(n.type, 'ctypedef ', name)

    elif isinstance(n, c_ast.TypeDecl):

        if name is None:
            name = n.name

        generate_decl(n.type, ckind, name)

    elif isinstance(n, c_ast.Struct):
        generate_struct_or_union("struct", n, ckind, name)
    elif isinstance(n, c_ast.Union):
        generate_struct_or_union("union", n, ckind, name)
    else:
        w = Writer("{}{}".format(ckind, cgen.visit(n)))
        w.write()

def main():
    a = pycparser.parse_file("sdl2.i")

    for n in a.ext:
        if isinstance(n, c_ast.Typedef) and n.name == "SDL_RWops":
            n.show(nodenames=True, attrnames=True)
            print
            print
            generate_decl(n, 'cdef ')

if __name__ == "__main__":
    main()
