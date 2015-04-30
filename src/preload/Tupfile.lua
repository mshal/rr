srcs += {
    'preload.c',
    'traced_syscall.S',
    'untraced_syscall.S',
    'syscall_hook.S',
}

ldflags += {
    '-ldl',
    '-pthread',
}

libname = rr_root .. '/lib/librrpreload.so'
shlib = cc_shared_library{srcs=srcs, ldflags=ldflags, library=libname}
