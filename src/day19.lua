local io = require("lib.io")
local test = require("lib.test")

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

local function dfs(towels, word, cache)
    if string.len(word) == 0 then
        return 1
    end
    if cache[word] then
        return cache[word]
    end

    local res = 0
    for _, towel in ipairs(towels) do
        local len = string.len(towel)
        if towel == word:sub(1, len) then
            res = res + dfs(towels, word:sub(len + 1), cache)
        end
    end

    cache[word] = res
    return res
end

local function calculate_patterns(towels, patterns, reduce_fn)
    local possible = 0
    local cache = {}
    for _, word in ipairs(patterns) do
        local res = dfs(towels, word, cache)
        possible = reduce_fn(possible, res)
    end
    return possible
end

local function part1(data)
    local towels, patterns = parse_input(data)
    local reducer = function(acc, num)
        if num > 0 then
            return acc + 1
        end
        return acc
    end
    return calculate_patterns(towels, patterns, reducer)
end

local function part2(data)
    local towels, patterns = parse_input(data)
    local reducer = function(acc, num)
        return acc + num
    end
    return calculate_patterns(towels, patterns, reducer)
end

local function main()
    local input = io.read_file("src/inputs/day19.txt")

    print(string.format("Day 19, part 1: %s", part1(input)))
    print(string.format("Day 19, part 2: %10.0f", part2(input)))
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

test(part2(TEST_INPUT), 16)
-- LuaFormatter on

main()
