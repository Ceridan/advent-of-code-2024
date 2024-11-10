local function test(actual, expected)
    assert(actual == expected, string.format("Actual: %s. Expected: %s", actual, expected))
end

local function read_file(path)
    local file = io.open(path, "r")
    if not file then
        print(string.format("File doesn't exist on path: %s", path))
        os.exit(1)
    end
    local content = file:read "*all"
    file:close()
    return content
end

local function read_lines_as_string_array(path)
    local content = read_file(path)

    local arr = {}
    for line in content:gmatch("[^\n]+") do
        table.insert(arr, line)
    end
    return arr
end

local function read_lines_as_number_array(path)
    local lines = read_lines_as_string_array(path)
    local arr = {}
    for _, line in ipairs(lines) do
        table.insert(arr, tonumber(line))
    end
    return arr
end

return {
    test = test,
    read_lines_as_string_array = read_lines_as_string_array,
    read_lines_as_number_array = read_lines_as_number_array,
}
