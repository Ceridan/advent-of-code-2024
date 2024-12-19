local io = require("lib.io")
local test = require("lib.test")
local inspect = require("inspect")

local function parse_input(input)
    local lines = io.read_lines_as_array(input)
    local match = lines[1]:gmatch("[^%s,]+")
    local towels = {}
    for m in match do
        table.insert(towels, m)
    end

    local patterns = {}
    for i = 2, #lines do
        table.insert(patterns, lines[i])
    end
    return towels, patterns
end

local function dfs(towels, word, i, cache)
    if i == string.len(word) + 1 then
        return 1
    end
    if cache[i] then
        return cache[i]
    end

    for _, towel in ipairs(towels) do
        if towel == word:sub(i, i + string.len(towel) - 1) then
            cache[i] = dfs(towels, word, i + string.len(towel), cache)
            if cache[i] == 1 then
                return 1
            end
        end
    end

    cache[i] = 0
    return 0
end

local function part1(data)
    local towels, patterns = parse_input(data)
    local possible = 0
    for _, word in ipairs(patterns) do
        possible = possible + dfs(towels, word, 1, {})
    end
    return possible
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day19.txt")

    print(string.format("Day 19, part 1: %s", part1(input)))
    print(string.format("Day 19, part 2: %s", part2(input)))
end

-- LuaFormatter off
local TEST_INPUT = [[
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb
]]

test(part1(TEST_INPUT), 6)

test(part2(TEST_INPUT), 0)
-- LuaFormatter on

main()
