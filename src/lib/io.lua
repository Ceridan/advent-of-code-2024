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

local function read_lines_as_array(content, transform_fn)
    transform_fn = transform_fn or function(line)
        return line
    end

    local lines = {}
    for line in content:gmatch("[^\n]+") do
        table.insert(lines, transform_fn(line))
    end
    return lines
end

local function read_columns_as_array(content, delimeter, transform_fn)
    delimeter = delimeter or " "
    transform_fn = transform_fn or function(line)
        return line
    end

    local lines = read_lines_as_array(content)
    local cols = {}
    local pattern = "[^" .. delimeter .. "]+"
    for i, line in ipairs(lines) do
        local j = 1
        for col in line:gmatch(pattern) do
            cols[j] = cols[j] or {}
            cols[j][i] = transform_fn(col)
            j = j + 1
        end
    end
    return cols
end

return {read_file = read_file, read_lines_as_array = read_lines_as_array, read_columns_as_array = read_columns_as_array}
