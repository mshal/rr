function generate_syscalls(filename)
    tup.frule{command='python -B src/generate_syscalls.py %o', output=filename}
end

generated_headers = {
    'AssemblyTemplates.h',
    'CheckSyscallNumbers.h',
    'IsAlwaysEmulatedSyscall.h',
    'SyscallDefsTable.h',
    'SyscallEnumsX64.h',
    'SyscallEnumsX86.h',
    'SyscallEnumsForTestsX64.h',
    'SyscallEnumsForTestsX86.h',
    'SyscallHelperFunctions.h',
    'SyscallnameArch.h',
    'SyscallRecordCase.h',
}
for k,v in pairs(generated_headers) do
    generate_syscalls(v)
end

CFLAGS += {
    '-std=c++0x',
    '-pthread',
    '-O0',
    '-g3',
    '-Wall',
    '-Werror',
    '-D__USE_LARGEFILE64',
    '-D__STDC_LIMIT_MACROS',
    '-D__STDC_FORMAT_MACROS',
    '-DRR_VERSION=\\"3.2.0\\"',
    '-Iinclude',
    '-I.',
}

srcs = {
    'src/*.cc',
    'src/test/*.S',
}
srcs.extra_inputs = generated_headers

LDFLAGS += {
    '-ldl',
    '-lm',
    '-lpthread',
    '-lrt',
    '-lz',
}
cxx_binary{srcs=srcs, cflags=CFLAGS, ldflags=LDFLAGS, binary='bin/rr'}
