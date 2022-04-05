# Poetry Bazel Rule PoC

This repository provides a proof-of-concept for Poetry integration with Bazel's
own [`rules_python`](https://github.com/bazelbuild/rules_python). It does so
by calling `poetry export` to generate a requirements file which can then be
fed into the `pip_install` or `pip_parse` rules.

## Installation

### Prerequisites

* Poetry 1.2 or higher
* `rules_python` 0.5.0 or higher
* Bazel 3.0 or higher

### Add rules_python_poetry_poc to your WORKSPACE

```
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "rules_python",
    sha256 = "9fcf91dbcc31fde6d1edb15f117246d912c33c36f44cf681976bd886538deba6",
    strip_prefix = "rules_python-0.8.0",
    url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.8.0.tar.gz",
)

# Rules for Poetry
http_archive(
    name = "rules_python_poetry",
    sha256 = "a53ec4bca85abfe5846078d45fef5cbc4396868442c1db1b8039e411bacebd80",
    strip_prefix = "rules_python_poetry_poc-16d9c1437c384ecaff8263ee42a53fd8e3ad873e",
    urls = ["https://github.com/AndrewGuenther/rules_python_poetry_poc/archive/16d9c1437c384ecaff8263ee42a53fd8e3ad873e.tar.gz"],
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
