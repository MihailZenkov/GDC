/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (c) 1999-2017 by Digital Mars, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/ddmd/gluelayer.d, _gluelayer.d)
 */

module ddmd.gluelayer;

// Online documentation: https://dlang.org/phobos/ddmd_gluelayer.html

import ddmd.dmodule;
import ddmd.dscope;
import ddmd.dsymbol;
import ddmd.mtype;
import ddmd.statement;
import ddmd.root.file;

version (NoBackend)
{
    import ddmd.lib : Library;

    struct Symbol;
    struct code;
    struct block;
    struct Blockx;
    struct elem;
    struct TYPE;
    alias type = TYPE;

    extern (C++)
    {
        // glue
        void obj_write_deferred(Library library)        {}
        void obj_start(char* srcfile)                   {}
        void obj_end(Library library, File* objfile)    {}
        void genObjFile(Module m, bool multiobj)        {}

        // msc
        void backend_init() {}
        void backend_term() {}

        // iasm
        Statement asmSemantic(AsmStatement s, Scope* sc) { assert(0); }

        // toir
        RET retStyle(TypeFunction tf)               { return RETregs; }
        void toObjFile(Dsymbol ds, bool multiobj)   {}

        void objc_initSymbols() {}
    }
}
else version (IN_GCC)
{
    union tree_node;

    alias Symbol = tree_node;
    alias code = tree_node;
    alias type = tree_node;

    // d-frontend.cc
    extern (C++)
    {
        RET retStyle(TypeFunction tf);
        Statement asmSemantic(AsmStatement s, Scope* sc);
    }

    // stubs
    void objc_initSymbols() { }
}
else
{
    import ddmd.lib : Library;

    public import ddmd.backend.cc : block, Blockx, Symbol;
    public import ddmd.backend.type : type;
    public import ddmd.backend.el : elem;
    public import ddmd.backend.code : code;

    extern (C++)
    {
        void obj_write_deferred(Library library);
        void obj_start(char* srcfile);
        void obj_end(Library library, File* objfile);
        void genObjFile(Module m, bool multiobj);

        void backend_init();
        void backend_term();

        Statement asmSemantic(AsmStatement s, Scope* sc);

        RET retStyle(TypeFunction tf);
        void toObjFile(Dsymbol ds, bool multiobj);

        void objc_initSymbols();
    }
}
