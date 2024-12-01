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

local function read_lines_as_array(path, transform_fn)
    local content = read_file(path)

    local arr = {}
    for line in content:gmatch("[^\n]+") do
        table.insert(arr, transform_fn(line))
    end
    return arr
end

local function read_lines_as_string_array(path)
    local fn = function(line) return line end
    return read_lines_as_array(path, fn)
end

local function read_lines_as_number_array(path)
    return read_lines_as_array(path, tonumber)
end

local function string_split(str, pattern)
    local arr = {}
    for line in str:gmatch(pattern) do
        table.insert(arr, line)
    end
    return arr
end

return {
    test = test,
    read_lines_as_string_array = read_lines_as_string_array,
    read_lines_as_number_array = read_lines_as_number_array,
    string_split = string_split,
}
