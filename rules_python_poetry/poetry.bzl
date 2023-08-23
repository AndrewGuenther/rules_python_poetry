def _poetry_impl(ctx):

   if ctx.attr.poetry != None:
      cmd = [ctx.path(ctx.attr.poetry), "export"]
   else:
      cmd = ["poetry", "export"]

   for group in ctx.attr.groups:
      cmd.append("--with="+group)

   result = ctx.execute(
      cmd,
      working_directory = str(ctx.path(ctx.attr.lockfile).dirname),
   )

   if result.return_code != 0:
      fail("Failed to execute poetry. Error: ", result.stderr)


   ctx.file("requirements_lock.txt", result.stdout)
   ctx.file("BUILD", "")

poetry_lock = repository_rule(
   implementation = _poetry_impl,
   local = True,
   attrs = {
        "lockfile": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
        "groups": attr.string_list(
            default = ["dev"],
        ),
        "poetry": attr.label(
            allow_single_file = True,
            mandatory = False,
            executable = True,
            cfg = "exec"
        ),
   }
)
