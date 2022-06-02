def _poetry_impl(ctx):
   result = ctx.execute(
      [
         "poetry",
         "export",
         # We also export dev here since no actual distinction for this exists
         # in rules_python. Also, the "dev" category in the lockfile is an
         # apparently meaningless distinction...
         # https://github.com/python-poetry/poetry/issues/5702
         "--dev"
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
