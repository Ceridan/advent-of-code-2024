local io = require("lib.io")
local test = require("lib.test")
local inspect = require("inspect")

local function parse_input(input)
    local matr = io.read_matrix(input, " ")
    local equations = {}
    for _, row in ipairs(matr) do
        local target = tonumber(row[1]:sub(1, -2))
        local numbers = {}
        for i = 2, #row do
            table.insert(numbers, tonumber(row[i]))
        end
        table.insert(equations, {["target"] = target, ["numbers"] = numbers })
    end
    return equations
end

local function dfs(target, numbers, idx, result)
    if result == target and idx > #numbers then
        return true
    end

    if idx > #numbers then
        return false
    end

    local num = numbers[idx]
    if dfs(target, numbers, idx + 1, num + result) then
        return true
    end
    if dfs(target, numbers, idx + 1, num * result) then
        return true
    end

    return false
end

local function part1(data)
    local equations = parse_input(data)
    local valid_sum = 0
    for _, eq in pairs(equations) do
        if dfs(eq.target, eq.numbers, 2, eq.numbers[1]) then
            valid_sum = valid_sum + eq.target
        end
    end
    return valid_sum
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day07.txt")

    print(string.format("Day 07, part 1: %s", part1(input)))
    print(string.format("Day 07, part 2: %s", part2(input)))
end

-- LuaFormatter off
local TEST_INPUT = [[
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
]]

test(part1(TEST_INPUT), 3749)
-- test(part2(TEST_INPUT), 11387)
-- LuaFormatter on

main()
