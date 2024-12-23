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

function Set.union(a, b)
    if a == nil and b == nil then
        return {}
    elseif a == nil then
        return b
    elseif b == nil then
        return a
    end

    local res = Set.new()
    for k in pairs(a) do
        if a[k] then
            res[k] = a[k]
        end
    end
    for k in pairs(b) do
        if b[k] then
            res[k] = b[k]
        end
    end
    return res
end

function Set.intersection(a, b)
    if a == nil or b == nil then
        return {}
    end

    local res = Set.new {}
    for k in pairs(a) do
        if a[k] and b[k] then
            res[k] = true
        end
    end
    return res
end

function Set.difference(a, b)
    local res = Set.new()
    for k in pairs(a) do
        if a[k] and not b[k] then
            res[k] = true
        end
    end
    return res
end

function Set.size(s)
    local size = 0
    for _ in pairs(s) do
        size = size + 1
    end
    return size
end

return Set
