local utils = require("utils")
local inspect = require("inspect")

local function parse_input(input)
    local list1 = {}
    local list2 = {}
    for _, row in ipairs(input) do
        local nums = utils.string_split(row, "%S+")
        table.insert(list1, tonumber(nums[1]))
        table.insert(list2, tonumber(nums[2]))
    end
    return list1, list2
end

local function part1(data)
    local list1, list2 = parse_input(data)
    table.sort(list1)
    table.sort(list2)

    local delta_sum = 0
    for i = 1, #list1 do
        delta_sum = delta_sum + math.abs(list1[i] - list2[i])
    end

    return delta_sum
end

local function part2(data)
    local list1, list2 = parse_input(data)
    local freq = {}
    for _, num in ipairs(list2) do
        freq[num] = (freq[num] or 0) + 1
    end

    local freq_sum = 0
    for _, num in ipairs(list1) do
        freq_sum = freq_sum + (freq[num] or 0) * num
    end

    return freq_sum
end

local function main()
    local input = utils.read_lines_as_string_array("src/inputs/day01.txt")

    print(string.format("Day 01, part 1: %s", part1(input)))
    print(string.format("Day 01, part 2: %s", part2(input)))
end

utils.test(part1({
    "3   4",
    "4   3",
    "2   5",
    "1   3",
    "3   9",
    "3   3",
}), 11)
utils.test(part2({
    "3   4",
    "4   3",
    "2   5",
    "1   3",
    "3   9",
    "3   3",
}), 31)

main()

