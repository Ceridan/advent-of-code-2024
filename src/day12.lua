local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")

local DIRECTIONS = {Point2D.new(0, -1), Point2D.new(1, 0), Point2D.new(0, 1), Point2D.new(-1, 0)}

-- LuaFormatter off
local function count_sides(map, curr)
    local x, y = curr.x, curr.y

    local c = map[y][x]
    local t = "."; if y > 1 then t = map[y-1][x] end
    local l = "."; if x > 1 then l = map[y][x-1] end
    local b = "."; if y < #map then b = map[y+1][x] end
    local r = "."; if x < #map then r = map[y][x+1] end

    local sides = 0
    if c ~= t then sides = sides + 1 end
    if c ~= l then sides = sides + 1 end
    if c ~= b then sides = sides + 1 end
    if c ~= r then sides = sides + 1 end
    return sides
end
-- LuaFormatter on

local function count_corners(map, curr)
    local x, y = curr.x, curr.y

    -- LuaFormatter off
    local c = map[y][x]
    local tl = "."; if y > 1 and x > 1 then tl = map[y-1][x-1] end
    local t = "."; if y > 1 then t = map[y-1][x] end
    local tr = "."; if y > 1 and x < #map then tr = map[y-1][x+1] end
    local l = "."; if x > 1 then l = map[y][x-1] end
    local bl = "."; if y < #map and x > 1 then bl = map[y+1][x-1] end
    local b = "."; if y < #map then b = map[y+1][x] end
    local br = "."; if y < #map and x < #map then br = map[y+1][x+1] end
    local r = "."; if x < #map then r = map[y][x+1] end
    -- LuaFormatter on

    local corners = 0
    if (c ~= t and c ~= l) or (c ~= tl and c == t and c == l) then
        corners = corners + 1
    end
    if (c ~= t and c ~= r) or (c ~= tr and c == t and c == r) then
        corners = corners + 1
    end
    if (c ~= b and c ~= l) or (c ~= bl and c == b and c == l) then
        corners = corners + 1
    end
    if (c ~= b and c ~= r) or (c ~= br and c == b and c == r) then
        corners = corners + 1
    end
    return corners
end

local function dfs(map, curr, ch, visited, perimeter_fn)
    if visited[curr:key()] then
        return 0, 0
    end

    if curr.x <= 0 or curr.x > #map or curr.y <= 0 or curr.y > #map or ch ~= map[curr.y][curr.x] then
        return 0, 0
    end

    visited[curr:key()] = true

    local a = 1
    local p = perimeter_fn(map, curr)

    for _, dir in ipairs(DIRECTIONS) do
        local oa, op = dfs(map, curr + dir, ch, visited, perimeter_fn)
        a = a + oa
        p = p + op
    end

    return a, p
end

local function calcaulate_price(map, perimeter_fn)
    local visited = {}
    local price = 0
    for y in ipairs(map) do
        for x in ipairs(map) do
            local curr = Point2D.new(x, y)
            local a, p = dfs(map, curr, map[y][x], visited, perimeter_fn)
            price = price + a * p
        end
    end
    return price
end

local function part1(data)
    local map = io.read_text_matrix(data)
    return calcaulate_price(map, count_sides)
end

local function part2(data)
    local map = io.read_text_matrix(data)
    return calcaulate_price(map, count_corners)
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
]]), 140)

test(part1([[
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
]]), 772)

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
]]), 1930)

test(part2([[
AAAA
BBCD
BBCC
EEEC
]]), 80)

test(part2([[
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
]]), 436)

test(part2([[
EEEEE
EXXXX
EEEEE
EXXXX
EEEEE
]]), 236)

test(part2([[
AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA
]]), 368)

test(part2([[
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
]]), 1206)
-- LuaFormatter on

main()
