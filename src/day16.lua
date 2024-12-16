local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")
local Queue = require("struct.queue")
local inspect = require("inspect")

local DIRECTIONS = {["E"] = Point2D.new(1, 0), ["S"] = Point2D.new(0, 1), ["W"] = Point2D.new(-1, 0), ["N"] = Point2D.new(0, -1)}
local STEP_SCORES = {
    ["E"] = {["E"] = 1, ["S"] = 1001, ["W"] = 2001, ["N"] = 1001},
    ["S"] = {["E"] = 1001, ["S"] = 1, ["W"] = 1001, ["N"] = 2001},
    ["W"] = {["E"] = 2001, ["S"] = 1001, ["W"] = 1, ["N"] = 1001},
    ["N"] = {["E"] = 1001, ["S"] = 2001, ["W"] = 1001, ["N"] = 1}
}

local function parse_input(input)
    local map = io.read_text_matrix(input)
    local start, finish = nil, nil
    for y =1, #map do
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
    local scores = {}
    local queue = Queue.new()
    queue:enqueue({["pos"] = start, ["dir"] = "E", ["score"] = 0})
    while not queue:is_empty() do
        local item = queue:dequeue()
        local x, y = item.pos.x, item.pos.y
        if map[y][x] ~= "#" then
            local key = item.pos:key()
            if scores[key] == nil or scores[key] > item.score then
                scores[key] = item.score
                if map[y][x] ~= "E" then
                    for dir, step in pairs(DIRECTIONS) do
                        queue:enqueue({
                            ["pos"] = item.pos + step,
                            ["dir"] = dir,
                            ["score"] = item.score + STEP_SCORES[item.dir][dir],
                        })
                    end
                end
            end
        end
    end
    return scores
end

local function part1(data)
    local map, start, finish = parse_input(data)
    local scores = bfs(map, start)
    return scores[finish:key()]
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day16.txt")

    print(string.format("Day 16, part 1: %s", part1(input)))
    print(string.format("Day 16, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
]]
), 7036)

test(part1([[
#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################
]]
), 11048)

test(part2([[
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
]]
), 45)

test(part2([[
#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################
]]
), 64)
-- LuaFormatter on

main()
