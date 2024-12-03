local io = require("lib.io")
local test = require("lib.test")
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
    local instr = {}
    local dos = regex.indexesof(data, "do\\(\\)", "gm")
    for i = 1, #dos, 2 do
        instr[dos[i]] = {type="mode", value=1}
    end
    local donts = regex.indexesof(data, "don't\\(\\)", "gm")
    for i = 1, #donts, 2 do
        instr[donts[i]] = {type="mode", value=0}
    end

    local muls = regex.matches(data, "mul\\((\\d+),(\\d+)\\)", "gm")
    local idxs = regex.indexesof(data, "mul\\((\\d+),(\\d+)\\)", "gm")
    for i, mul in ipairs(muls) do
        local matches = regex.match(mul, "(\\d+),(\\d+)", "gm")
        instr[idxs[i*2-1]] = {type="data", value=tonumber(matches[2]) * tonumber(matches[3])}
    end

    local keys = {}
    for k, _ in pairs(instr) do
        table.insert(keys, k)
    end
    table.sort(keys)

    local sum = 0
    local mode = 1
    for _, k in ipairs(keys) do
        if instr[k] ~= nil then
            if instr[k].type == "mode" then
                mode = instr[k].value
            else
                sum = sum + mode * instr[k].value
            end
        end
    end
    return sum
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
