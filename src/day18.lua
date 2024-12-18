local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")
local Queue = require("struct.queue")
local inspect = require("inspect")

local DIRECTIONS = {Point2D.new(0, -1), Point2D.new(1, 0), Point2D.new(0, 1), Point2D.new(-1, 0)}

----------------------------------------
---                RAM                ---
----------------------------------------

local RAM = {}
RAM.__index = RAM

function RAM.new(size)
    local self = setmetatable({}, RAM)
    self.size = size
    self._map = {}
    return self
end

function RAM:put(point)
    local x, y = point.x, point.y
    self._map[y] = self._map[y] or {}
    self._map[y][x] = true
end

function RAM:get(point)
    local x, y = point.x, point.y
    if x < 0 or x >= self.size or y < 0 or y >= self.size then
        return true
    end
    return self._map[y] and self._map[y][x]
end

----------------------------------------

local function parse_input(input)
    local lines = io.read_lines_as_array(input)
    local bytes = {}
    for _, line in ipairs(lines) do
        local match = line:gmatch("%d+")
        local byte = Point2D.new(tonumber(match()), tonumber(match()))
        table.insert(bytes, byte)
    end
    return bytes
end

local function bfs(ram)
    local start = Point2D.new(0, 0)
    local finish = Point2D.new(ram.size - 1, ram.size - 1)
    local visited = {}
    local queue = Queue.new()
    queue:enqueue({["pos"] = start, ["steps"] = 0})
    while not queue:is_empty() do
        local item = queue:dequeue()
        if item.pos == finish then
            return item.steps
        end
        if not ram:get(item.pos) and not visited[item.pos:key()] then
            visited[item.pos:key()] = true
            for _, dir in ipairs(DIRECTIONS) do
                queue:enqueue({["pos"] = item.pos + dir, ["steps"] = item.steps + 1})
            end
        end
    end
    return -1
end

local function part1(data, size, byte_count)
    local bytes = parse_input(data)
    local ram = RAM.new(size)
    for i = 1, byte_count do
        ram:put(bytes[i])
    end

    return bfs(ram)
end

local function part2(data, size, byte_count)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day18.txt")

    print(string.format("Day 18, part 1: %s", part1(input, 71, 1024)))
    print(string.format("Day 18, part 2: %s", part2(input)))
end

-- LuaFormatter off
local TEST_INPUT = [[
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0
]]

test(part1(TEST_INPUT, 7, 12), 22)

test(part2(TEST_INPUT, 7, 12), "6,1")
-- LuaFormatter on

main()
