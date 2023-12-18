load("//rules_python_poetry:poetry.bzl", "poetry_lock")

_lock = tag_class(attrs={
    "name": attr.string(
        mandatory = True,
    ),
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
})

def _ext_poetry_impl(ctx):
    for mod in ctx.modules:
        for lock in mod.tags.lock:
            poetry_lock(
                name = lock.name,
                lockfile = lock.lockfile,
                groups = lock.groups,
                poetry = lock.poetry,
            )

poetry = module_extension(
    implementation = _ext_poetry_impl,
    tag_classes = {"lock": _lock}
)
