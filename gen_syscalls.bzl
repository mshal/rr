def gen_syscalls_impl(ctx):
  for output in ctx.outputs.generated:
      ctx.action(
          outputs=[output],
          executable=ctx.executable.script,
          arguments=[output.path],
      )

gen_syscalls = rule(
  implementation=gen_syscalls_impl,
  output_to_genfiles=True,
  attrs={
    "script": attr.label(cfg=HOST_CFG, mandatory=True, allow_files=True,
                         executable=True),
    "generated": attr.output_list(),
  },
)
