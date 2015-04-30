tup.creategitignore()

rr_root = tup.getcwd()

function compile(display, compiler, srcs, cflags)
    g_display = display
    g_compiler = compiler
    g_cflags = cflags
    return tup.foreach_rule(srcs, '^ $(g_display) %f^ $(g_compiler) $(g_cflags) -c %f -o %o', '%B.o')
end

function cxx_compile(srcs, cflags)
    return compile('C++', 'c++', srcs, cflags)
end

function cc_compile(srcs, cflags)
    return compile('CC', 'gcc', srcs, cflags)
end

function link(objs, ldflags, binary)
    g_ldflags = ldflags
    return tup.rule(objs, '^ LINK %o^ c++ %f -o %o $(g_ldflags)', binary)
end

function cxx_binary(args)
    objs = cxx_compile(args.srcs, args.cflags)
    return link(objs, args.ldflags, args.binary)
end

function cc_shared_library(args)
    args.cflags += '-fPIC'
    args.ldflags += '-shared'
    objs = cc_compile(args.srcs, args.cflags)
    return link(objs, args.ldflags, args.library)
end
