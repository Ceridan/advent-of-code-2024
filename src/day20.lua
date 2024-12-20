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

local function calculate_diff(times, point1, point2)
    local min = math.min(times[point1:key()], times[point2:key()])
    local max = math.max(times[point1:key()], times[point2:key()])
    return max - min - 2
end

local function calculate_cheat_time_for_2(map, times, threshold)
    local acceptable_cheats = 0
    for y = 1, #map do
        for x = 1, #map[y] do
            if map[y][x] == "#" and y > 1 and y < #map and map[y - 1][x] ~= "#" and map[y + 1][x] ~= "#" then
                local p1, p2 = Point2D.new(x, y - 1), Point2D.new(x, y + 1)
                if calculate_diff(times, p1, p2) >= threshold then
                    acceptable_cheats = acceptable_cheats + 1
                end
            elseif map[y][x] == "#" and x > 1 and x < #map[y] and map[y][x - 1] ~= "#" and map[y][x + 1] ~= "#" then
                local p1, p2 = Point2D.new(x - 1, y), Point2D.new(x + 1, y)
                if calculate_diff(times, p1, p2) >= threshold then
                    acceptable_cheats = acceptable_cheats + 1
                end
            end
        end
    end
    return acceptable_cheats
end

local function calculate_cheat_times(times, radius, threshold)
    local acceptable_cheats = 0
    for key1, time1 in pairs(times) do
        local pos1 = Point2D.fromString(key1)
        for key2, time2 in pairs(times) do
            if key1 < key2 then
                local pos2 = Point2D.fromString(key2)
                local diff = pos1 - pos2
                local dist = math.abs(diff.x) + math.abs(diff.y)
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
    return acceptable_cheats
end

local function part1(data, cheat, threshold)
    local map, start = parse_input(data)
    local times = bfs(map, start)
    return calculate_cheat_time_for_2(map, times, threshold)
end

local function part2(data, cheat, threshold)
    local map, start = parse_input(data)
    local times = bfs(map, start)
    return calculate_cheat_times(times, cheat, threshold)
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
