package(default_visibility = ["//visibility:public"])

cc_library(
    name = "rrpreload",
    linkopts = [
        "-ldl",
        "-lm",
        "-lpthread",
        "-lrt",
    ],
    srcs = [
        "src/preload/preload.c",
        "src/preload/traced_syscall.S",
        "src/preload/untraced_syscall.S",
        "src/preload/syscall_hook.S",
    ],
    hdrs = ["src/preload/preload_interface.h"],
)

GENERATED_FILES = [
    "AssemblyTemplates.h",
    "CheckSyscallNumbers.h",
    "IsAlwaysEmulatedSyscall.h",
    "SyscallDefsTable.h",
    "SyscallEnumsX64.h",
    "SyscallEnumsX86.h",
    "SyscallEnumsForTestsX64.h",
    "SyscallEnumsForTestsX86.h",
    "SyscallHelperFunctions.h",
    "SyscallnameArch.h",
    "SyscallRecordCase.h",
]

cc_binary(
    name="rr",
    linkopts = [
        "-ldl",
        "-lm",
        "-lpthread",
        "-lrt",
        "-lz",
    ],
    copts = [
        "-DRR_VERSION='\"3.2.0\"'",
    ],
    includes = [
        "include",
    ],
    srcs = [
        "src/test/cpuid_loop.S",
        "src/AddressSpace.cc",
        "src/AutoRemoteSyscalls.cc",
        "src/Command.cc",
        "src/CompressedReader.cc",
        "src/CompressedWriter.cc",
        "src/CPUIDBugDetector.cc",
        "src/DiversionSession.cc",
        "src/DumpCommand.cc",
        "src/EmuFs.cc",
        "src/Event.cc",
        "src/ExtraRegisters.cc",
        "src/fast_forward.cc",
        "src/FdTable.cc",
        "src/Flags.cc",
        "src/GdbConnection.cc",
        "src/GdbServer.cc",
        "src/HelpCommand.cc",
        "src/kernel_abi.cc",
        "src/kernel_metadata.cc",
        "src/log.cc",
        "src/MagicSaveDataMonitor.cc",
        "src/main.cc",
        "src/Monkeypatcher.cc",
        "src/PerfCounters.cc",
        "src/PsCommand.cc",
        "src/RecordCommand.cc",
        "src/RecordSession.cc",
        "src/record_signal.cc",
        "src/record_syscall.cc",
        "src/Registers.cc",
        "src/ReplayCommand.cc",
        "src/ReplaySession.cc",
        "src/replay_syscall.cc",
        "src/ReplayTimeline.cc",
        "src/Scheduler.cc",
        "src/Session.cc",
        "src/StdioMonitor.cc",
        "src/task.cc",
        "src/TraceFrame.cc",
        "src/TraceStream.cc",
        "src/util.cc",
        "include/rr/rr.h",
    ] + GENERATED_FILES,
)

load("gen_syscalls", "gen_syscalls")

gen_syscalls(
    name="gen_syscalls",
    script="src/generate_syscalls.py",
    generated=GENERATED_FILES
)

filegroup(
    name = "srcs",
    srcs = ["BUILD"] + glob([
        "**/*.cc",
        "**/*.h",
    ]),
)
