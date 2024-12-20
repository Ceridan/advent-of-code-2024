local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")
local Queue = require("struct.queue")

local DIRECTIONS = {Point2D.new(1, 0), Point2D.new(0, 1), Point2D.new(-1, 0), Point2D.new(0, -1)}

local function parse_input(input)
    local map = io.read_text_matrix(input)
    local start, finish = nil, nil
    for y = 1, #map do
        for x = 1, #map[y] do
            if map[y][x] == "S" then
                start = Point2D.new(x, y)
            elseif map[y][x] == "E" then
                finish = Point2D.new(x, y)
            end
        end
    end
    return map, start, finish
end

local function bfs(map, start)
    local times = {}
    local queue = Queue.new()
    queue:enqueue({["pos"] = start, ["time"] = 0})
    while not queue:is_empty() do
        local item = queue:dequeue()
        local x, y = item.pos.x, item.pos.y
        if map[y][x] ~= "#" then
            local key = item.pos:key()
            if times[key] == nil or times[key] > item.time then
                times[key] = item.time

                if map[y][x] ~= "E" then
                    for _, dir in pairs(DIRECTIONS) do
                        queue:enqueue({["pos"] = item.pos + dir, ["time"] = item.time + 1})
                    end
                end
            end
        end
    end
    return times
end

local function calculate_cheat_times(times, radius, threshold)
    local acceptable_cheats = 0
    for key1, time1 in pairs(times) do
        local pos1 = Point2D.fromString(key1)
        for dy = 0, radius do
            for dx = -radius + dy, radius - dy do
                if dy > 0 or dx > 0 then
                    local pos2 = Point2D.new(pos1.x + dx, pos1.y + dy)
                    local time2 = times[pos2:key()]
                    if time2 ~= nil then
                        local dist = pos1:manhattan(pos2)
                        if dist <= radius then
                            local min = math.min(time1, time2)
                            local max = math.max(time1, time2)
                            if max - min - dist >= threshold then
                                acceptable_cheats = acceptable_cheats + 1
                            end
                        end
                    end
                end
            end
        end
    end
    return acceptable_cheats
end

local function part1(data, cheat_duration, threshold)
    local map, start = parse_input(data)
    local times = bfs(map, start)
    return calculate_cheat_times(times, cheat_duration, threshold)
end

local function part2(data, cheat_duration, threshold)
    local map, start = parse_input(data)
    local times = bfs(map, start)
    return calculate_cheat_times(times, cheat_duration, threshold)
end

local function main()
    local input = io.read_file("src/inputs/day20.txt")

    print(string.format("Day 20, part 1: %s", part1(input, 2, 100)))
    print(string.format("Day 20, part 2: %s", part2(input, 20, 100)))
end

-- LuaFormatter off
local TEST_INPUT = [[
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
]]

test(part1(TEST_INPUT, 2, 20), 5)
test(part2(TEST_INPUT, 20, 70), 41)
-- LuaFormatter on
main()
