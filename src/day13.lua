local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")

local A_TOKENS = 3
local B_TOKENS = 1

local function parse_input(input)
    local machines = {}
    local lines = io.read_lines_as_array(input)
    for i = 1, #lines, 3 do
        local aiter = lines[i]:gmatch("%d+")
        local biter = lines[i + 1]:gmatch("%d+")
        local piter = lines[i + 2]:gmatch("%d+")
        local machine = {
            ["a"] = Point2D.new(tonumber(aiter()), tonumber(aiter())),
            ["b"] = Point2D.new(tonumber(biter()), tonumber(biter())),
            ["prize"] = Point2D.new(tonumber(piter()), tonumber(piter()))
        }
        table.insert(machines, machine)
    end
    return machines
end

local function solve(machine)
    local ax, ay = machine.a.x, machine.a.y
    local bx, by = machine.b.x, machine.b.y
    local px, py = machine.prize.x, machine.prize.y

    -- Solution for the system of linear equations with 2 variables.
    local a = math.floor((px * by - bx * py) / (ax * by - bx * ay))
    local b = math.floor((ax * py - px * ay) / (ax * by - bx * ay))

    if a * ax + b * bx == px and a * ay + b * by == py then
        return a * A_TOKENS + b * B_TOKENS
    end

    return 0
end

local function count_tokens(machines, correction)
    local total_tokens = 0
    for _, machine in ipairs(machines) do
        machine.prize.x = machine.prize.x + correction
        machine.prize.y = machine.prize.y + correction
        total_tokens = total_tokens + solve(machine)
    end
    return total_tokens
end

local function part1(data)
    local machines = parse_input(data)
    return count_tokens(machines, 0)
end

local function part2(data)
    local machines = parse_input(data)
    return count_tokens(machines, 10000000000000)
end

local function main()
    local input = io.read_file("src/inputs/day13.txt")

    print(string.format("Day 13, part 1: %s", part1(input)))
    print(string.format("Day 13, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
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
]]), 480)
-- LuaFormatter on

main()
