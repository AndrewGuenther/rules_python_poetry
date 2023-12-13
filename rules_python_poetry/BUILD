# The automated release Github action requires at least one test. Using this dummy test until something better can be
# put in place.
genrule(
    name = "gen_dummy_test",
    outs = ["dummy_test.sh"],
    cmd = "touch $@",
    executable = True,
)

sh_test(
    name = "dummy_test",
    srcs = [":dummy_test.sh"],
)
