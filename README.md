# Poetry Bazel Rule

This repository provides a rule for Poetry integration with Bazel's
own [`rules_python`](https://github.com/bazelbuild/rules_python). It does so
by calling `poetry export` to generate a requirements file which can then be
fed into the `pip_install` or `pip_parse` rules.

## Installation

### Prerequisites

* Poetry 1.2 or higher
* `rules_python` 0.5.0 or higher
* Bazel 3.0 or higher

### Add rules_python_poetry to your WORKSPACE

```
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "rules_python",
    sha256 = "8c8fe44ef0a9afc256d1e75ad5f448bb59b81aba149b8958f02f7b3a98f5d9b4",
    strip_prefix = "rules_python-0.13.0",
    url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.13.0.tar.gz",
)

# Rules for Poetry
http_archive(
    name = "rules_python_poetry",
    sha256 = "35c51c970f6362ecc6d1050af691c1463eb91471f389bfde4e114d3c2b4815c6",
    strip_prefix = "rules_python_poetry-cb9a0e5dd7496b59201ee522140dcd7dc12e5f97",
    urls = ["https://github.com/AndrewGuenther/rules_python_poetry/archive/cb9a0e5dd7496b59201ee522140dcd7dc12e5f97.tar.gz"],
)

load("@rules_python_poetry//rules_python_poetry:poetry.bzl", "poetry_lock")

# Generate a requirements lock file from our poetry lock
poetry_lock(
    name = "requirements",
    lockfile = "//:poetry.lock",
)

load("@rules_python//python:pip.bzl", "pip_parse")

# Create a central repo that knows about the dependencies needed from
# requirements_lock.txt.
pip_parse(
    name = "python_deps",
    requirements_lock = "@requirements//:requirements_lock.txt",
)

# Load the starlark macro which will define your dependencies.
load("@python_deps//:requirements.bzl", "install_deps")

# Call it to define repos for your requirements.
install_deps()
```
