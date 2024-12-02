local function copy_array(arr)
    local copy = {}
    for _, v in ipairs(arr) do
      table.insert(copy, v)
    end
    return copy
end

return {
copy_array = copy_array
}
