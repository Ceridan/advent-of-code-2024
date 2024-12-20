local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")
local Queue = require("struct.queue")
local inspect = require("inspect")

local DIRECTIONS = {
    Point2D.new(1, 0),
    Point2D.new(0, 1),
    Point2D.new(-1, 0),
    Point2D.new(0, -1)
}

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
                        queue:enqueue({
                            ["pos"] = item.pos + dir,
                            ["time"] = item.time + 1,
                        })
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

local function calculate_cheat_time_diffs(map, times)
    local cheat_time_diffs = {}
    for y = 1, #map do
        for x = 1, #map[y] do
            if map[y][x] == "#" and y > 1 and y < #map and map[y-1][x] ~= "#" and map[y+1][x] ~= "#" then
                local p1, p2 = Point2D.new(x, y - 1), Point2D.new(x, y + 1)
                table.insert(cheat_time_diffs, calculate_diff(times, p1, p2))
            elseif map[y][x] == "#" and x > 1 and x < #map[y] and map[y][x-1] ~= "#" and map[y][x+1] ~= "#" then
                local p1, p2 = Point2D.new(x - 1, y), Point2D.new(x + 1, y)
                table.insert(cheat_time_diffs, calculate_diff(times, p1, p2))
            end
        end
    end
    return cheat_time_diffs
end

local function part1(data, threshold)
    local map, start = parse_input(data)
    local times = bfs(map, start)
    local cheat_time_diffs = calculate_cheat_time_diffs(map, times)
    local acceptable_cheats = 0
    for _, diff in ipairs(cheat_time_diffs) do
        if diff >= threshold then
            acceptable_cheats = acceptable_cheats + 1
        end
    end
    return acceptable_cheats
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day20.txt")

    print(string.format("Day 20, part 1: %s", part1(input, 100)))
    print(string.format("Day 20, part 2: %s", part2(input)))
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

test(part1(TEST_INPUT, 20), 5)

test(part2(TEST_INPUT), 0)
-- LuaFormatter on
main()
