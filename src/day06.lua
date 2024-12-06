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
            local key = curr:key()
            visited[key] = curr
        end
    end
end

local function check_cycle(map, start, obstacle)
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

        local next_curr = curr + DIRECTIONS[dir_idx]
        if is_out_of_bound(map, next_curr) then
            return false
        elseif next_curr == obstacle or map[next_curr.y][next_curr.x] == "#" then
            dir_idx = next_dir_idx(dir_idx)
        else
            curr = next_curr
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
    local cycle = 0
    for _, vis in pairs(visited) do
        if check_cycle(map, start, vis) then
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
