local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")
local Queue = require("struct.queue")
local inspect = require("inspect")
local tbl = require("lib.tbl")

local DIRECTIONS = {["E"] = Point2D.new(1, 0), ["S"] = Point2D.new(0, 1), ["W"] = Point2D.new(-1, 0), ["N"] = Point2D.new(0, -1)}
local STEP_SCORES = {
    ["E"] = {["E"] = 1, ["S"] = 1001, ["W"] = 2001, ["N"] = 1001},
    ["S"] = {["E"] = 1001, ["S"] = 1, ["W"] = 1001, ["N"] = 2001},
    ["W"] = {["E"] = 2001, ["S"] = 1001, ["W"] = 1, ["N"] = 1001},
    ["N"] = {["E"] = 1001, ["S"] = 2001, ["W"] = 1001, ["N"] = 1}
}

local function print_map(map, seats)
    print("                       ")
    for y = 1, #map do
        local line = ""
        for x = 1, #map[y] do
            local p = Point2D.new(x, y)
            if seats[p:key()] then
                line = line .. "O"
            else
                line = line .. map[y][x]
            end
        end
        print(line)
    end
    print("                       ")
end

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
            if scores[key] == nil or scores[key][item.dir] == nil or scores[key][item.dir] > item.score then
                scores[key] = scores[key] or {}
                scores[key][item.dir] = item.score
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

local function dfs(map, pos, dir, score, scores, target_score, path, seats)
    -- if pos == Point2D.new(2, 11) then
    --     print(score, scores[pos:key()])
    -- end
    if map[pos.y][pos.x] == "#" or score ~= scores[pos:key()][dir] then
        return
    end
    if map[pos.y][pos.x] == "E" then
        if score == target_score then
            for _, p in ipairs(path) do
                seats[p] = true
            end
        end
        return
    end
    -- if pos == Point2D.new(2, 11) then
    --     print("in")
    -- end

    table.insert(path, pos:key())
    for next_dir, step in pairs(DIRECTIONS) do
        local new_score = score + STEP_SCORES[dir][next_dir]
        dfs(map, pos + step, next_dir, new_score, scores, target_score, path, seats)
    end
    table.remove(path)
end

local function part1(data)
    local map, start, finish = parse_input(data)
    local scores = bfs(map, start)
    local finish_scores = scores[finish:key()]
    local values = {}
    for _, v in pairs(finish_scores) do
        table.insert(values, v)
    end
    return math.min(unpack(values))
end

local function part2(data)
    local map, start, finish = parse_input(data)
    local scores = bfs(map, start)
    local values = {}
    for _, v in pairs(scores[finish:key()]) do
        table.insert(values, v)
    end
    local target_score = math.min(unpack(values))


    local seats = {[start:key()] = true, [finish:key()] = true}
    dfs(map, start, "E", 0, scores, target_score, {}, seats)
    print_map(map, seats)
    -- print(scores[Point2D.new(2, 11):key()])
    local count = 0
    for _ in pairs(seats) do
        count = count + 1
    end
    return count
end

local function main()
    local input = io.read_file("src/inputs/day16.txt")

    print(string.format("Day 16, part 1: %s", part1(input)))
    print(string.format("Day 16, part 2: %s", part2(input)))
end

-- LuaFormatter off
print('part1')
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
print('part2')
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

print('main')

main()
