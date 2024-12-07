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

local function compact_map(map)
    local compacted = {["y"] = {}, ["x"] = {}}

    for y in ipairs(map) do
        compacted.y[y] = {}
        for x in ipairs(map[y]) do
            if map[y][x] == "#" then
                table.insert(compacted.y[y], x)
            end
        end
    end

    for x in ipairs(map[1]) do
        compacted.x[x] = {}
        for y in ipairs(map) do
            if map[y][x] == "#" then
                table.insert(compacted.x[x], y)
            end
        end
    end

    return compacted
end

local function search_compacted(compacted, pos, dir)
    local map
    local inner, outer
    if dir == 1 or dir == 3 then
        map = compacted.x
        inner = pos.x
        outer = pos.y
    else
        map = compacted.y
        inner = pos.y
        outer = pos.x
    end

    local l, r = 1, #map[inner]
    while l <= r do
        local mid = math.floor((l + r) / 2)
        if map[inner][mid] > outer then
            r = mid - 1
        else
            l = mid + 1
        end
    end

    l, r = r, l
    if dir == 1 then
        local y = 0
        if l > 0 then
            y = map[inner][l]
        end
        return pos.x, y
    elseif dir == 2 then
        local x = 0
        if r <= #map[inner] then
            x = map[inner][r]
        end
        return x, pos.y
    elseif dir == 3 then
        local y = 0
        if r <= #map[inner] then
            y = map[inner][r]
        end
        return pos.x, y
    elseif dir == 4 then
        local x = 0
        if l > 0 then
            x = map[inner][l]
        end
        return x, pos.y
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
            visited[curr:key()] = curr
        end
    end
end

local function check_cycle(compacted_map, start, obstacle)
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

        local ox, oy = search_compacted(compacted_map, curr, dir_idx)
        if ox == 0 or oy == 0 then
            return false
        else
            local bidx
            if dir_idx == 1 then
                bidx = 3
            elseif dir_idx == 2 then
                bidx = 4
            elseif dir_idx == 3 then
                bidx = 1
            else
                bidx = 2
            end

            curr = Point2D.new(ox, oy) + DIRECTIONS[bidx]
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
    local compacted = compact_map(map)
    local cycle = 0
    for _, vis in pairs(visited) do
        if vis ~= start then
            table.insert(compacted.x[vis.x], vis.y)
            table.sort(compacted.x[vis.x])
            table.insert(compacted.y[vis.y], vis.x)
            table.sort(compacted.y[vis.y])

            if check_cycle(compacted, start, vis) then
                cycle = cycle + 1
            end

            local i = 1
            while true do
                if compacted.x[vis.x][i] == vis.y then
                    break
                end
                i = i + 1
            end
            table.remove(compacted.x[vis.x], i)
            i = 1
            while true do
                if compacted.y[vis.y][i] == vis.x then
                    break
                end
                i = i + 1
            end
            table.remove(compacted.y[vis.y], i)
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
