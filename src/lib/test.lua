local function test(actual, expected)
    assert(actual == expected, string.format("Actual: %s. Expected: %s", actual, expected))
end

return test
