local function copy_array(arr)
    local copy = {}
    for _, v in ipairs(arr) do
        table.insert(copy, v)
    end
    return copy
end

local function table_size(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

return {copy_array = copy_array, table_size = table_size}
