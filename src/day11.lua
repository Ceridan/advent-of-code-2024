local io = require("lib.io")
local test = require("lib.test")

local function apply_rules(stone)
    -- rule 1
    if stone == "0" then
        return "1"
    end

    -- rule 2
    local len = string.len(stone)
    if len % 2 == 0 then
        local l, r = stone:sub(1, len / 2), stone:sub(len / 2 + 1, -1)
        return l, tostring(tonumber(r))
    end

    -- rule 3
    return tostring(stone * 2024)
end

local function dfs(stone, blinks, cache)
    if blinks == 0 then
        return 1
    end
    if cache[stone] ~= nil and cache[stone][blinks] ~= nil then
        return cache[stone][blinks]
    end

    local stone1, stone2 = apply_rules(stone)
    local count = dfs(stone1, blinks - 1, cache)
    if stone2 ~= nil then
        count = count + dfs(stone2, blinks - 1, cache)
    end

    cache[stone] = cache[stone] or {}
    cache[stone][blinks] = count
    return count
end

local function count_stones(stones, blinks)
    local total = 0
    for _, stone in ipairs(stones) do
        total = total + dfs(stone, blinks, {})
    end
    return total
end

local function part1(data, blinks)
    local stones = io.read_matrix(data, " ")[1]
    return count_stones(stones, blinks)
end

local function part2(data, blinks)
    local stones = io.read_matrix(data, " ")[1]
    return count_stones(stones, blinks)
end

local function main()
    local input = io.read_file("src/inputs/day11.txt")

    print(string.format("Day 11, part 1: %20.0f", part1(input, 25)))
    print(string.format("Day 11, part 2: %20.0f", part2(input, 75)))
end

-- LuaFormatter off
test(part1("0 1 10 99 999", 1), 7)
test(part1("125 17", 6), 22)
test(part1("125 17", 25), 55312)
-- LuaFormatter on

main()
