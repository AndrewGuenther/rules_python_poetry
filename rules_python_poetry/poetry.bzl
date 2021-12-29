def _poetry_impl(ctx):
   result = ctx.execute(
      [
         "poetry",
         "export"
      ],
      working_directory = str(ctx.path(ctx.attr.lockfile).dirname),
      quiet = False,
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
   }
)