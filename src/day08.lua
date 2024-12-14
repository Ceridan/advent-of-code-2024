local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")

local function compact_map(map)
    local compacted = {}
    for y = 1, #map do
        for x = 1, #map[y] do
            local ch = map[y][x]
            if ch ~= "." then
                local p = Point2D.new(x, y)
                compacted[p:key()] = {["char"] = ch, ["point"] = p}
            end
        end
    end
    return compacted
end

local function calculate_antinodes(map, antinode_fn)
    local size = #map
    local compacted = compact_map(map)
    local visited = {}
    local antinodes = {}
    for loc, ant in pairs(compacted) do
        if not visited[loc] then
            visited[loc] = true
            for oloc, oant in pairs(compacted) do
                if loc ~= oloc and ant.char == oant.char then
                    antinode_fn(antinodes, size, ant.point, oant.point)
                end
            end
        end
    end

    local count = 0
    for _ in pairs(antinodes) do
        count = count + 1
    end
    return count
end

local function part1(data)
    local map = io.read_text_matrix(data)
    local antinode_fn = function(antinodes, size, this, other)
        local diff = this - other
        local antinode = this + diff
        if antinode.x > 0 and antinode.x <= size and antinode.y > 0 and antinode.y <= size then
            antinodes[antinode:key()] = true
        end
    end
    return calculate_antinodes(map, antinode_fn)
end

local function part2(data)
    local map = io.read_text_matrix(data)
    local antinode_fn = function(antinodes, size, this, other)
        local diff = this - other
        local i = 0
        while true do
            local antinode = this + diff:mult_const(i)
            if antinode.x > 0 and antinode.x <= size and antinode.y > 0 and antinode.y <= size then
                antinodes[antinode:key()] = true
            else
                break
            end
            i = i + 1
        end
    end
    return calculate_antinodes(map, antinode_fn)
end

local function main()
    local input = io.read_file("src/inputs/day08.txt")

    print(string.format("Day 08, part 1: %s", part1(input)))
    print(string.format("Day 08, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
]]), 14)

test(part2([[
T.........
...T......
.T........
..........
..........
..........
..........
..........
..........
..........
]]
), 9)
test(part2([[
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
]]), 34)
-- LuaFormatter on

main()
