local function file_exists(path)
    local file = io.open(path, "r")
    if file ~= nil then
        file:close()
        return true
    else
        return false
    end
end

local function write_file(path, content)
    local file = io.open(path, "w")
    if not file then
        print(string.format("Can't create file on path: %s", path))
        os.exit(1)
    end
    file:write(content)
    file:close()
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

local function read_lines_as_array(content, transform_fn)
    transform_fn = transform_fn or function(line)
        return line
    end
    local lines = {}
    for line in content:gfind("[^\n]+") do
        table.insert(lines, transform_fn(line))
    end
    return lines
end

local function read_matrix_impl(content, delimeter, matrix_builder_fn)
    local lines = read_lines_as_array(content)
    local matrix = {}
    local pattern = string.format("[^%s]+", delimeter)
    for i, line in ipairs(lines) do
        local j = 1
        for cell in line:gmatch(pattern) do
            matrix_builder_fn(matrix, cell, i, j)
            j = j + 1
        end
    end
    return matrix
end

local function read_matrix(content, delimeter, transform_fn)
    delimeter = delimeter or " "
    transform_fn = transform_fn or function(line)
        return line
    end
    local builder_fn = function(matrix, cell, i, j)
        matrix[i] = matrix[i] or {}
        matrix[i][j] = transform_fn(cell)
    end
    return read_matrix_impl(content, delimeter, builder_fn)
end

local function read_matrix_T(content, delimeter, transform_fn)
    delimeter = delimeter or " "
    transform_fn = transform_fn or function(line)
        return line
    end
    local builder_fn = function(matrix, cell, i, j)
        matrix[j] = matrix[j] or {}
        matrix[j][i] = transform_fn(cell)
    end
    return read_matrix_impl(content, delimeter, builder_fn)
end

return {
    file_exists = file_exists,
    write_file = write_file,
    read_file = read_file,
    read_lines_as_array = read_lines_as_array,
    read_matrix = read_matrix,
    read_matrix_T = read_matrix_T
}
