local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")

local DIRECTIONS = {Point2D.new(0, -1), Point2D.new(1, 0), Point2D.new(0, 1), Point2D.new(-1, 0)}

local function count_corners(map, curr, points_to_groups)
    local x, y = curr.x, curr.y

    local c = map[y][x] .. points_to_groups[y][x]
    local tl = "."; if y > 1 and x > 1 then tl = map[y-1][x-1] .. points_to_groups[y-1][x-1]end
    local t = "."; if y > 1 then t = map[y-1][x] .. points_to_groups[y-1][x] end
    local tr = "."; if y > 1 and x < #map then tr = map[y-1][x+1] .. points_to_groups[y-1][x+1] end
    local l = "."; if x > 1 then l = map[y][x-1] .. points_to_groups[y][x-1] end
    local bl = "."; if y < #map and x > 1 then bl = map[y+1][x-1] .. points_to_groups[y+1][x-1] end
    local b = "."; if y < #map then b = map[y+1][x] .. points_to_groups[y+1][x] end
    local br = "."; if y < #map and x < #map then br = map[y+1][x+1] .. points_to_groups[y+1][x+1] end
    local r = "."; if x < #map then r = map[y][x+1] .. points_to_groups[y][x+1] end

    local corners = 0
    if (c ~= t and c ~= l) or (c ~= tl and c == t and c == l) then
        corners = corners + 1
    end
    if (c ~= t and c ~= r) or (c ~= tr and c == t and c == r) then
        corners = corners + 1
    end
    if  (c ~= b and c ~= l) or (c ~= bl and c == b and c == l) then
        corners = corners + 1
    end
    if (c ~= b and c ~= r) or (c ~= br and c == b and c == r) then
        corners = corners + 1
    end

    return corners
end

local function dfs(map, curr, ch, group, points_to_groups)
    if curr.x <= 0 or curr.x > #map or curr.y <= 0 or curr.y > #map or ch ~= map[curr.y][curr.x] then
        return 1, 0
    end

    if points_to_groups[curr.y] and points_to_groups[curr.y][curr.x] then
        return 0, 0
    end

    points_to_groups[curr.y] = (points_to_groups[curr.y] or {})
    points_to_groups[curr.y][curr.x] = group
    local p = 0
    local a = 1

    for _, dir in ipairs(DIRECTIONS) do
        local op, oa = dfs(map, curr + dir, ch, group, points_to_groups)
        p = p + op
        a = a + oa
    end

    return p, a
end

local function calculate_borders(map, points_to_groups)
    local borders = {}
    for y = 1, #map do
        for x = 1, #map do
            local curr = Point2D.new(x, y)
            local group = points_to_groups[y][x]
            borders[group] = (borders[group] or 0) + count_corners(map, curr, points_to_groups)
        end
    end
    return borders
end

local function part1(data)
    local garden = io.read_text_matrix(data)
    local groups = {}
    local price = 0
    for y in ipairs(garden) do
        for x in ipairs(garden) do
            local curr = Point2D.new(x, y)
            local group = curr:key()
            local p, a = dfs(garden, curr, garden[y][x], group, groups)
            price = price + p * a
        end
    end
    return price
end

local function part2(data)
    local garden = io.read_text_matrix(data)
    local points_to_groups = {}
    local group_to_area = {}
    for y in ipairs(garden) do
        for x in ipairs(garden) do
            local curr = Point2D.new(x, y)
            local group = curr:key()
            local p, a = dfs(garden, curr, garden[y][x], group, points_to_groups)
            if a > 0 then
                group_to_area[group] = a
            end
        end
    end

    local group_to_border = calculate_borders(garden, points_to_groups)

    local price = 0
    for group in pairs(group_to_border) do
        price = price + group_to_border[group] * group_to_area[group]
    end
    return price
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
