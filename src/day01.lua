local io = require("lib.io")
local test = require("lib.test")

local function parse_input(input)
    local cols = io.read_matrix_T(input, " ", tonumber)
    return cols[1], cols[2]
end

local function part1(data)
    local list1, list2 = parse_input(data)
    table.sort(list1)
    table.sort(list2)

    local total_distance = 0
    for i = 1, #list1 do
        total_distance = total_distance + math.abs(list1[i] - list2[i])
    end

    return total_distance
end

local function part2(data)
    local list1, list2 = parse_input(data)
    local freq = {}
    for _, num in ipairs(list2) do
        freq[num] = (freq[num] or 0) + 1
    end

    local similarity_score = 0
    for _, num in ipairs(list1) do
        similarity_score = similarity_score + (freq[num] or 0) * num
    end

    return similarity_score
end

local function main()
    local input = io.read_file("src/inputs/day01.txt")

    print(string.format("Day 01, part 1: %s", part1(input)))
    print(string.format("Day 01, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
3   4
4   3
2   5
1   3
3   9
3   3
]]), 11)

test(part2([[
3   4
4   3
2   5
1   3
3   9
3   3
]]), 31)
-- LuaFormatter on

main()

