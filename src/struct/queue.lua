local Queue = {}
Queue.__index = Queue

function Queue.new()
    local self = setmetatable({}, Queue)
    self._items = {}
    self._first = 1
    self._last = 0
    return self
end

function Queue:enqueue(item)
    self._last = self._last + 1
    self._items[self._last] = item
end

function Queue:dequeue()
    if self:is_empty() then
        error("Queue is empty")
    end
    local item = self._items[self._first]
    self._items[self._first] = nil
    self._first = self._first + 1
    return item
end

function Queue:peek()
    if self:is_empty() then
        error("Queue is empty")
    end
    return self._items[self._first]
end

function Queue:is_empty()
    return self._first > self._last
end

function Queue:size()
    return self._last - self._first + 1
end

function Queue:clear()
    self._items = {}
    self._first = 1
    self._last = 0
end

function Queue:__tostring()
    local items = {}
    for i = self._first, self._last do
        table.insert(items, tostring(self._items[i]))
    end
    return "Queue: [" .. table.concat(items, ", ") .. "]"
end

return Queue
