local io = require("lib.io")
local test = require("lib.test")
local inspect = require("inspect")
local bit32 = require("bit32")

local MODULO = 16777216

local function parse_input(input)
    return input
end

local function calculate_next_secret(secret)
    local val = secret * 64
    val = bit32.bxor(val, secret)
    val = val % MODULO

    val = bit32.bxor(math.floor(val / 32), val)
    val = val % MODULO

    val = bit32.bxor(val * 2048, val)
    val = val % MODULO

    return val
end

local function part1(data, iterations)
    local secrets = io.read_lines_as_array(data, tonumber)
    local total_sum = 0
    for _, secret in ipairs(secrets) do
        for _ = 1, iterations do
            secret = calculate_next_secret(secret)
        end
        total_sum = total_sum + secret
    end

    return total_sum
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day22.txt")

    print(string.format("Day 22, part 1: %s", part1(input, 2000)))
    print(string.format("Day 22, part 2: %s", part2(input)))
end

-- LuaFormatter off
local TEST_INPUT = [[
1
10
100
2024
]]

test(part1(TEST_INPUT, 2000), 37327623)

test(part2(TEST_INPUT), 0)
-- LuaFormatter on

main()
