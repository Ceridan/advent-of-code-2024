local io = require("lib.io")
local test = require("lib.test")
local inspect = require("inspect")


local function apply_rules(stone)
    if stone == "0" then
        return "1"
    end

    local len = string.len(stone)
    if len % 2 == 0 then
        local l, r = stone:sub(1, len / 2), stone:sub(len/2+1, -1)
        return l, tostring(tonumber(r))
    end

    return tostring(stone * 2024)
end

local function count_stones(stones, blinks)
    local cache = {}
    local first = {}
    print(inspect(stones))
    for i = 1, blinks do
        local new_stones = {}
        for j = 1, #stones do
            local stone = stones[j]
            local stone1, stone2 = unpack(cache[stone] or {apply_rules(stone)})
            cache[stone] = {stone1, stone2}
            table.insert(new_stones, stone1)
            if stone2 ~= nil then
                table.insert(new_stones, stone2)
            end
        end
        print(i, #stones)

        local f = {}
        for j = 1, 20 do
            table.insert(f, new_stones[j])
        end
        table.insert(first, f)

        for _, f in ipairs(first) do
            print(inspect(f))
        end

        print(i, #stones)
        print("------------")
        stones = new_stones
    end
    return #stones
end

local function dfs(stone, blinks, cache)
    if blinks == 0 then
        return 1
    end
    if cache[stone] ~= nil and cache[stone][blinks] ~= nil then
        return cache[stone][blinks]
    end

    local stone1, stone2 = apply_rules(stone)
    local res = dfs(stone1, blinks-1, cache)
    if stone2 ~= nil then
        res = res + dfs(stone2, blinks-1, cache)
    end

    -- -- rule 1
    -- if stone == 0 then
    --     res = dfs(1, blink - 1, cache)
    -- end

    -- -- rule 2
    -- local stone_str = tostring(stone)
    -- local len = string.len(stone_str)
    -- print(stone, stone_str)
    -- if len % 2 == 0 then
    --     local l, r = stone_str:sub(1, len / 2), stone_str:sub(len/2+1, -1)
    --     res = dfs(tonumber(l), blink-1, cache) + dfs(tonumber(r), blink-1, cache)
    -- end

    -- -- rule 3
    -- res = dfs(stone * 2024, blink - 1, cache)

    cache[stone] = cache[stone] or {}
    cache[stone][blinks] = res
    return res
end

local function part1(data, blinks)
    local stones = io.read_matrix(data, " ")[1]
    return count_stones(stones, blinks)
end

local function part2(data, blinks)
    local stones = io.read_matrix(data, " ")[1]
    local total = 0
    for _, stone in ipairs(stones) do
        total = total + dfs(stone, blinks, {})
    end
    return total
end

local function main()
    local input = io.read_file("src/inputs/day11.txt")

    -- print(string.format("Day 11, part 1: %s", part1(input, 25)))
    print(string.format("Day 11, part 2: %20.0f", part2(input, 75)))
end

-- LuaFormatter off
-- test(part1("0 1 10 99 999", 1), 7)
-- test(part1("125 17", 6), 22)
-- test(part1("125 17", 25), 55312)
-- LuaFormatter on

main()
