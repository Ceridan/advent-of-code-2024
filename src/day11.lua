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
        stones = new_stones
    end
    return #stones
end

local function part1(data, blinks)
    local stones = io.read_matrix(data, " ")[1]
    return count_stones(stones, blinks)
end

local function part2(data, blinks)
    local stones = io.read_matrix(data, " ")[1]
    -- return count_stones(stones, blinks)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day11.txt")

    print(string.format("Day 11, part 1: %s", part1(input, 25)))
    print(string.format("Day 11, part 2: %s", part2(input, 75)))
end

-- LuaFormatter off
test(part1("0 1 10 99 999", 1), 7)
test(part1("125 17", 6), 22)
test(part1("125 17", 25), 55312)
-- LuaFormatter on

main()
