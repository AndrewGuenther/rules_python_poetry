def _poetry_impl(ctx):
   
   cmd = ["poetry", "export"]
   
   for group in ctx.attr.groups:
      cmd.append("--with="+group)
   
   result = ctx.execute(
      cmd,
      working_directory = str(ctx.path(ctx.attr.lockfile).dirname),
   )

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
        )
   }
)
