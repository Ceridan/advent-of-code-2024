local function regex(str, pattern)
    local matches = {}
    for line in str:gmatch(pattern) do
        table.insert(matches, line)
    end
    return matches
end

return {regex = regex}
