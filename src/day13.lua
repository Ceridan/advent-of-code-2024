local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")
local inspect = require("inspect")

local A_TOKENS = 3
local B_TOKENS = 1
local CLICKS = 100

local function parse_input(input)
    local machines = {}
    local lines = io.read_lines_as_array(input)
    for i=1, #lines, 3 do
        local aiter = lines[i]:gmatch("%d+")
        local biter = lines[i+1]:gmatch("%d+")
        local piter = lines[i+2]:gmatch("%d+")
        local machine = {
            ["a"] = Point2D.new(tonumber(aiter()), tonumber(aiter())),
            ["b"] = Point2D.new(tonumber(biter()), tonumber(biter())),
            ["prize"] = Point2D.new(tonumber(piter()), tonumber(piter())),
        }
        table.insert(machines, machine)
     end
     return machines
end

local function dfs(machine, pos, a, b, cache)
    if a > CLICKS or b > CLICKS or pos.x > machine.prize.x or pos.y > machine.prize.y then
        return 0
    end

    local clicks_key = Point2D.new(a, b):key()
    if cache[clicks_key] ~= nil and cache[clicks_key][pos:key()] ~= nil then
        return cache[clicks_key][pos:key()]
    end

    if a <= CLICKS and b <= CLICKS and pos.x == machine.prize.x and pos.y == machine.prize.y then
        return a * A_TOKENS + b * B_TOKENS
    end

    local tokens_a = dfs(machine, pos + machine.a, a + 1, b, cache)
    local tokens_b = dfs(machine, pos + machine.b, a, b + 1, cache)

    cache[clicks_key] = cache[clicks_key] or {}

    if tokens_a == 0 then
        cache[clicks_key][pos:key()] = tokens_b
        return tokens_b
    elseif tokens_b == 0 then
        cache[clicks_key][pos:key()] = tokens_a
        return tokens_a
    else
        cache[clicks_key][pos:key()] = math.min(tokens_a, tokens_b)
        return math.min(tokens_a, tokens_b)
    end
end

local function part1(data)
    local machines = parse_input(data)
    local total_tokens = 0
    for _, machine in ipairs(machines) do
        local cache = {}
        total_tokens = total_tokens + dfs(machine, Point2D.new(0, 0), 0, 0, cache)
    end
    return total_tokens
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day13.txt")

    print(string.format("Day 13, part 1: %s", part1(input)))
    print(string.format("Day 13, part 2: %s", part2(input)))
end

-- LuaFormatter off
local TEST_INPUT = [[
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
]]

test(part1(TEST_INPUT), 480)

test(part2(TEST_INPUT), 0)
-- LuaFormatter on

main()
