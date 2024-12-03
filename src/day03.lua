local io = require("lib.io")
local test = require("lib.test")
local inspect = require("inspect")
local regex = require("regex")

local function part1(data)
    local muls = regex.matches(data, "mul\\((\\d+),(\\d+)\\)", "gm")

    local sum = 0
    for _, mul in ipairs(muls) do
        local matches = regex.match(mul, "(\\d+),(\\d+)", "gm")
        sum = sum + tonumber(matches[2]) * tonumber(matches[3])
    end

    return sum
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day03.txt")

    print(string.format("Day 03, part 1: %s", part1(input)))
    print(string.format("Day 03, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"), 161)

test(part2("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"), 48)
-- LuaFormatter on

main()
