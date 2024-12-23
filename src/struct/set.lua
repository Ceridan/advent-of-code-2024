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

    local res = Set.new{}
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

-- Set = {}
-- Set.__index = Set

-- function Set.new(elements)
--     local self = setmetatable({}, Set)
--     self._items = {}

--     if elements then
--         for _, v in ipairs(elements) do
--             self._items[v] = true
--         end
--     end

--     return self
-- end

-- function Set:add(item)
--     self._items[item] = true
-- end

-- function Set:remove(item)
--     self._items[item] = nil
-- end

-- function Set:contains(item)
--     return self._items[item] ~= nil
-- end

-- function Set:size()
--     local count = 0
--     for _ in pairs(self._items) do
--         count = count + 1
--     end
--     return count
-- end

-- function Set:toList()
--     local list = {}
--     for k in pairs(self._items) do
--         table.insert(list, k)
--     end
--     return list
-- end

-- function Set:union(other)
--     local result = Set.new()
--     for k in pairs(self._items) do
--         result:add(k)
--     end
--     for k in pairs(other._items) do
--         result:add(k)
--     end
--     return result
-- end

-- function Set:intersect(other)
--     local result = Set.new()
--     for k in pairs(self._items) do
--         if other:contains(k) then
--             result:add(k)
--         end
--     end
--     return result
-- end

-- function Set:difference(other)
--     local result = Set.new()
--     for k in pairs(self._items) do
--         if not other:contains(k) then
--             result:add(k)
--         end
--     end
--     return result
-- end

-- function Set:__tostring()
--     local items = {}
--     for k in pairs(self._items) do
--         table.insert(items, tostring(k))
--     end
--     return "{" .. table.concat(items, ", ") .. "}"
-- end

-- function Set:__eq(other)
--     if self:size() ~= other:size() then
--         return false
--     end

--     for k in pairs(self._items) do
--         if not other:contains(k) then
--             return false
--         end
--     end

--     return true
-- end

-- return Set
