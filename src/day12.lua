local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")
local inspect = require("inspect")

local DIRECTIONS = {Point2D.new(0, -1), Point2D.new(1, 0), Point2D.new(0, 1), Point2D.new(-1, 0)}

local function dfs(map, curr, ch, visited)
    if curr.x <= 0 or curr.x > #map or curr.y <= 0 or curr.y > #map or ch ~= map[curr.y][curr.x] then
        return 1, 0
    end

    if visited[curr:key()] then
        return 0, 0
    end

    visited[curr:key()] = true
    local p = 0
    local a = 1

    for _, dir in ipairs(DIRECTIONS) do
        local op, oa = dfs(map, curr + dir, ch, visited)
        p = p + op
        a = a + oa
    end

    return p, a
end

local function part1(data)
    local garden = io.read_text_matrix(data)
    local visited = {}
    local price = 0
    for y in ipairs(garden) do
        for x in ipairs(garden) do
            local curr = Point2D.new(x, y)
            local p, a = dfs(garden, curr, garden[y][x], visited)
            price = price + p * a
        end
    end
    return price
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day12.txt")

    print(string.format("Day 12, part 1: %s", part1(input)))
    print(string.format("Day 12, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
AAAA
BBCD
BBCC
EEEC
]]),140)

test(part1([[
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
]]),772)

test(part1([[
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
]]),1930)


test(part2([[

]]), 0)
-- LuaFormatter on

main()
