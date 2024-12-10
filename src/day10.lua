local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")
local inspect = require("inspect")

local DIRECTIONS = {Point2D.new(0, -1), Point2D.new(1, 0), Point2D.new(0, 1), Point2D.new(-1, 0)}

local function get_reachable_points(map, pos, val)
    local reachable = {}
    for _, dir in ipairs(DIRECTIONS) do
        local p = pos + dir
        if p.x > 0 and p.x <= #map and p.y > 0 and p.y <= #map and map[p.y][p.x] ~= "." then
            local pval = tonumber(map[p.y][p.x])
            if pval == val + 1 then
                table.insert(reachable, Point2D.new(p.x, p.y):key())
            end
        end
    end
    return reachable
end

local function parse_input(input)
    local map = io.read_text_matrix(input)
    local compacted = {}
    local trailheads = {}
    for y = 1, #map do
        for x = 1, #map[y] do
            if map[y][x] ~= "." then
                local pos = Point2D.new(x, y)
                local val = tonumber(map[y][x])
                local curr = {
                    ["point"] = pos,
                    ["value"] = val,
                    ["moves"] = get_reachable_points(map, pos, val)
                }
                compacted[pos:key()] = curr
                if val == 0 then
                    table.insert(trailheads, pos:key())
                end
            end
        end
    end
    return compacted, trailheads
end

local function dfs1(map, pos)
    if map[pos].value == 9 then
        return {[pos] = true}
    end

    local res = {}
    for _, next_pos in ipairs(map[pos].moves) do
        local nines = dfs1(map, next_pos)
        for nine in pairs(nines) do
            res[nine] = true
        end
    end

    return res
end

local function dfs2(map, pos)
    if map[pos].value == 9 then
        return 1
    end

    local paths = 0
    for _, next_pos in ipairs(map[pos].moves) do
        paths = paths + dfs2(map, next_pos)
    end

    return paths
end

local function part1(data)
    local map, trailheads = parse_input(data)
    local paths = 0
    for _, start in ipairs(trailheads) do
        local res = dfs1(map, start)
        for nine in pairs(res) do
            paths = paths + 1
        end
    end
    return paths
end

local function part2(data)
    local map, trailheads = parse_input(data)
    local paths = 0
    for _, start in ipairs(trailheads) do
        local res = dfs2(map, start)
        paths = paths + res
    end
    return paths
end

local function main()
    local input = io.read_file("src/inputs/day10.txt")

    print(string.format("Day 10, part 1: %s", part1(input)))
    print(string.format("Day 10, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
0123
1234
8765
9876
]]), 1)

test(part1([[
...0...
...1...
...2...
6543456
7.....7
8.....8
9.....9
]]), 2)

test(part1([[
..90..9
...1.98
...2..7
6543456
765.987
876....
987....
]]), 4)

test(part1([[
10..9..
2...8..
3...7..
4567654
...8..3
...9..2
.....01
]]), 3)

test(part1([[
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
]]), 36)

test(part2([[
.....0.
..4321.
..5..2.
..6543.
..7..4.
..8765.
..9....
]]), 3)

test(part2([[
..90..9
...1.98
...2..7
6543456
765.987
876....
987....
]]), 13)

test(part2([[
012345
123456
234567
345678
4.6789
56789.
]]), 227)

test(part2([[
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
]]), 81)
-- LuaFormatter on

main()
