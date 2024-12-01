local function string_split(str, pattern)
    local arr = {}
    for line in str:gmatch(pattern) do
        table.insert(arr, line)
    end
    return arr
end

return {string_split = string_split}
