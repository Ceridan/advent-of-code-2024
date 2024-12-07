local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")

local DIRECTIONS = {Point2D.new(0, -1), Point2D.new(1, 0), Point2D.new(0, 1), Point2D.new(-1, 0)}

local function find_start(map)
    for y in ipairs(map) do
        for x in ipairs(map[y]) do
            if map[y][x] == "^" then
                return Point2D.new(x, y)
            end
        end
    end
    error("Starting position not found")
end

local function is_out_of_bound(map, curr)
    return curr.y < 1 or curr.y > #map or curr.x < 1 or curr.x > #map[1]
end

local function next_dir_idx(idx)
    if idx % 4 == 0 then
        return 1
    else
        return idx + 1
    end
end

local function rev_dir_idx(idx)
    return next_dir_idx(next_dir_idx(idx))
end

local function build_obstacles_map(map)
    local obstacles_map = {}

    for y in ipairs(map) do
        local prev = nil
        local prev_idx = 0
        for x in ipairs(map[y]) do
            local curr = Point2D.new(x, y)
            if map[y][x] == "#" then
                for i = prev_idx + 1, x - 1 do
                    local key = Point2D.new(i, y):key()
                    obstacles_map[key][2] = curr
                    obstacles_map[key][4] = prev
                end
                prev = curr
                prev_idx = x
            else
                obstacles_map[curr:key()] = {}
            end
        end
        for i = prev_idx + 1, #map[y] do
            local key = Point2D.new(i, y):key()
            obstacles_map[key][4] = prev
        end
    end

    for x in ipairs(map[1]) do
        local prev = nil
        local prev_idx = 0
        for y in ipairs(map) do
            if map[y][x] == "#" then
                local curr = Point2D.new(x, y)
                for i = prev_idx + 1, y - 1 do
                    local key = Point2D.new(x, i):key()
                    obstacles_map[key][1] = prev
                    obstacles_map[key][3] = curr
                end
                prev = curr
                prev_idx = y
            end
        end
        for i = prev_idx + 1, #map[1] do
            local key = Point2D.new(x, i):key()
            obstacles_map[key][1] = prev
        end
    end

    return obstacles_map
end

local function next_obstacle(obstacles_map, curr, dir, obstacle)
    local wall = obstacles_map[curr:key()][dir]

    if dir == 1 and obstacle.x == curr.x and obstacle.y < curr.y and (wall == nil or wall.y < obstacle.y) then
        return obstacle
    end
    if dir == 2 and obstacle.y == curr.y and obstacle.x > curr.x and (wall == nil or wall.x > obstacle.x) then
        return obstacle
    end
    if dir == 3 and obstacle.x == curr.x and obstacle.y > curr.y and (wall == nil or wall.y > obstacle.y) then
        return obstacle
    end
    if dir == 4 and obstacle.y == curr.y and obstacle.x < curr.x and (wall == nil or wall.x < obstacle.x) then
        return obstacle
    end

    return wall
end

local function check_visited(map, start)
    local dir_idx = 1
    local curr = start
    local visited = {[curr:key()] = curr}

    while true do
        local next_curr = curr + DIRECTIONS[dir_idx]
        if is_out_of_bound(map, next_curr) then
            return visited
        elseif map[next_curr.y][next_curr.x] == "#" then
            dir_idx = next_dir_idx(dir_idx)
        else
            curr = next_curr
            visited[curr:key()] = curr
        end
    end
end

local function check_cycle(obstacles_map, start, obstacle)
    if start == obstacle then
        return false
    end

    local dir_idx = 1
    local curr = start
    local state = {}

    while true do
        local key = curr:key() .. "_" .. dir_idx
        if state[key] then
            return true
        else
            state[key] = true
        end

        local obst = next_obstacle(obstacles_map, curr, dir_idx, obstacle)
        if obst == nil then
            return false
        else
            curr = obst + DIRECTIONS[rev_dir_idx(dir_idx)]
            dir_idx = next_dir_idx(dir_idx)
        end
    end
end

local function part1(data)
    local map = io.read_text_matrix(data)
    local start = find_start(map)
    local visited = check_visited(map, start)

    local count = 0
    for _ in pairs(visited) do
        count = count + 1
    end
    return count
end

local function part2(data)
    local map = io.read_text_matrix(data)
    local start = find_start(map)
    local visited = check_visited(map, start)
    local obstacles_map = build_obstacles_map(map)
    local cycle = 0
    for _, vis in pairs(visited) do
        if check_cycle(obstacles_map, start, vis) then
            cycle = cycle + 1
        end
    end
    return cycle
end

local function main()
    local input = io.read_file("src/inputs/day06.txt")

    print(string.format("Day 06, part 1: %s", part1(input)))
    print(string.format("Day 06, part 2: %s", part2(input)))
end

-- LuaFormatter off
local TEST_INPUT = [[
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
]]

test(part1(TEST_INPUT), 41)
test(part2(TEST_INPUT), 6)
-- LuaFormatter on

main()
