local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")

local TIME_BOUND = 100
local RADIUS = 20

local function parse_input(input)
    local lines = io.read_lines_as_array(input)
    local robots = {}
    for _, line in ipairs(lines) do
        local match = line:gmatch("-?%d+")
        local robot = {
            ["p"] = Point2D.new(tonumber(match()), tonumber(match())),
            ["v"] = Point2D.new(tonumber(match()), tonumber(match()))
        }
        table.insert(robots, robot)
    end
    return robots
end

local function print_map(robots, w, h, seconds)
    local map = {}
    for y = 1, h do
        map[y] = {}
        for x = 1, w do
            map[y][x] = "."
        end
    end

    for _, robot in ipairs(robots) do
        map[robot.p.y + 1][robot.p.x + 1] = "*"
    end

    for y = 1, h do
        local line = ""
        for x = 1, w do
            line = line .. map[y][x]
        end
        print(line)
    end

    print("Seconds: ", seconds)
end

local function get_next_pos(p, v, w, h)
    local next_p = p + v
    if next_p.x < 0 then
        next_p.x = next_p.x + w
    end
    if next_p.x >= w then
        next_p.x = next_p.x - w
    end
    if next_p.y < 0 then
        next_p.y = next_p.y + h
    end
    if next_p.y >= h then
        next_p.y = next_p.y - h
    end
    return next_p
end

local function dfs(p, v, t, w, h)
    if t == TIME_BOUND then
        return p
    end

    local next_p = get_next_pos(p, v, w, h)
    return dfs(next_p, v, t + 1, w, h)
end

local function part1(data, width, height)
    local robots = parse_input(data)
    local mid = Point2D.new(math.floor(width / 2), math.floor(height / 2))

    local quadrants = {0, 0, 0, 0}

    for _, robot in ipairs(robots) do
        local pos = dfs(robot.p, robot.v, 0, width, height)
        if pos.x > mid.x and pos.y < mid.y then
            quadrants[1] = quadrants[1] + 1
        elseif pos.x < mid.x and pos.y < mid.y then
            quadrants[2] = quadrants[2] + 1
        elseif pos.x < mid.x and pos.y > mid.y then
            quadrants[3] = quadrants[3] + 1
        elseif pos.x > mid.x and pos.y > mid.y then
            quadrants[4] = quadrants[4] + 1
        end
    end
    return quadrants[1] * quadrants[2] * quadrants[3] * quadrants[4]
end

local function part2(data, width, height)
    local robots = parse_input(data)
    local mid = Point2D.new(math.floor(width / 2), math.floor(height / 2))
    local seconds = 0
    while true do
        -- Assumption is that the Christmas Tree should be in some radius around the middle point.
        local around_mid = 0
        for _, robot in ipairs(robots) do
            robot.p = get_next_pos(robot.p, robot.v, width, height)
            if math.abs(robot.p.x - mid.x) <= RADIUS and math.abs(robot.p.y - mid.y) <= RADIUS then
                around_mid = around_mid + 1
            end
        end
        seconds = seconds + 1

        -- Check if the most of the robots co-located around the middle point, most likely we found the Christmas Tree.
        if around_mid > #robots / 2 then
            break
        end
    end
    print_map(robots, width, height, seconds)
    return seconds
end

local function main()
    local input = io.read_file("src/inputs/day14.txt")

    print(string.format("Day 14, part 1: %s", part1(input, 101, 103)))
    print(string.format("Day 14, part 2: %s", part2(input, 101, 103)))
end

-- LuaFormatter off
local TEST_INPUT = [[
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
]]

test(part1(TEST_INPUT, 11, 7), 12)
-- LuaFormatter on

main()
