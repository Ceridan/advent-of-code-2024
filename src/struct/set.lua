local Set = {}

function Set.new(t)
    local set = {}
    if t ~= nil then
        for _, l in ipairs(t) do
            set[l] = true
        end
    end
    return set
end

function Set.intersection(a, b)
    if a == nil or b == nil then
        return {}
    end

    local res = Set.new {}
    for k in pairs(a) do
        res[k] = b[k]
    end
    return res
end

return Set
