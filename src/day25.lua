local io = require("lib.io")
local test = require("lib.test")

local function parse_input(input)
    local matr = io.read_text_matrix(input)
    local locks = {}
    local keys = {}

    local i = 1
    while i < #matr do
        local tmp = {}
        for j = 1, 5 do
            table.insert(tmp, matr[i + j])
        end

        if table.concat(matr[i]) == "#####" then
            table.insert(locks, tmp)
        else
            table.insert(keys, tmp)
        end

        i = i + 7
    end

    return locks, keys
end

local function get_heights(lock)
    local heights = {}
    for j = 1, 5 do
        local height = 0
        for i = 1, 5 do
            if lock[i][j] == "#" then
                height = height + 1
            end
        end
        table.insert(heights, height)
    end
    return heights
end

local function convert_to_heights(locks)
    local heights = {}
    for i = 1, #locks do
        table.insert(heights, get_heights(locks[i]))
    end
    return heights
end

local function part1(data)
    local locks, keys = parse_input(data)
    local lock_heights = convert_to_heights(locks)
    local key_heights = convert_to_heights(keys)
    local fit = 0
    for l = 1, #lock_heights do
        for k = 1, #key_heights do
            fit = fit + 1
            for p = 1, 5 do
                if lock_heights[l][p] + key_heights[k][p] > 5 then
                    fit = fit - 1
                    break
                end
            end
        end
    end
    return fit
end

local function part2(_)
    return "-"
end

local function main()
    local input = io.read_file("src/inputs/day25.txt")

    print(string.format("Day 25, part 1: %s", part1(input)))
    print(string.format("Day 25, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####
]]), 3)
-- LuaFormatter on

main()
