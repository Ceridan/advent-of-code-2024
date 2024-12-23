local io = require("lib.io")
local test = require("lib.test")

local function multiply(mul)
    local left = tonumber(mul:match("(%d+),"))
    local right = tonumber(mul:match(",(%d+)"))
    return left * right
end

local function extract(data, instructions, pattern, result_fn)
    local idx = 0
    while true do
        idx = data:find(pattern, idx + 1)
        if not idx then
            break
        end
        instructions[idx] = result_fn(idx)
    end
end

local function part1(data)
    local muls = {}
    for mul in data:gfind("mul%(%d+,%d+%)") do
        table.insert(muls, mul)
    end

    local sum = 0
    for _, mul in ipairs(muls) do
        sum = sum + multiply(mul)
    end

    return sum
end

local function part2(data)
    local instr = {}
    extract(data, instr, "do%(%)", function()
        return {type = "mode", value = 1}
    end)
    extract(data, instr, "don't%(%)", function()
        return {type = "mode", value = 0}
    end)
    extract(data, instr, "mul%(%d+,%d+%)", function(idx)
        local mul = data:match("mul%(%d+,%d+%)", idx)
        return {type = "data", value = multiply(mul)}
    end)

    local keys = {}
    for k, _ in pairs(instr) do
        table.insert(keys, k)
    end
    table.sort(keys)

    local sum = 0
    local mode = 1
    for _, k in ipairs(keys) do
        if instr[k].type == "mode" then
            mode = instr[k].value
        else
            sum = sum + mode * instr[k].value
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
