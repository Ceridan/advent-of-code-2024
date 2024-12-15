local io = require("lib.io")
local test = require("lib.test")
local Point2D = require("struct.point2d")
local inspect = require("inspect")

local DIRECTIONS = {
    ["^"] = Point2D.new(0, -1),
    [">"] = Point2D.new(1, 0),
    ["v"] = Point2D.new(0, 1),
    ["<"] = Point2D.new(-1, 0),
}

local function parse_input(input)
    local lines = io.read_lines_as_array(input)
    local map = {}
    local moves = {}
    local robot = nil
    for y, line in ipairs(lines) do
        if line:sub(1, 1) == "#" then
            local arr = io.read_text_matrix(line)[1]
            for x = 1, #arr do
                if arr[x] == "@" then
                    arr[x] = "."
                    robot = Point2D.new(x, y)
                end
            end
            table.insert(map, arr)
        else
            local dirs = io.read_text_matrix(line)[1]
            for  _, dir in ipairs(dirs) do
                table.insert(moves, dir)
            end
        end
    end

    return map, moves, robot
end

local function move_robot(map, robot, dir)
    local x_end = robot.x
    local x_step = 1
    if dir.x > 0 then
        x_end = #map
    elseif dir.x < 0 then
        x_end = 1
        x_step = -1
    end

    local y_end = robot.y
    local y_step = 1
    if dir.y > 0 then
        y_end = #map
    elseif dir.y < 0 then
        y_end = 1
        y_step = -1
    end

    local new_robot = robot + dir

    local box = false
    for y = new_robot.y, y_end, y_step do
        for x = new_robot.x, x_end, x_step do
            if map[y][x] == "." and box == false then
                return new_robot
            elseif map[y][x] == "." and box then
                map[y][x] = map[new_robot.y][new_robot.x]
                map[new_robot.y][new_robot.x] = "."
                return new_robot
            elseif map[y][x] == "#" then
                return robot
            else
                box = true
            end
        end
    end
    return robot
end

local function part1(data)
    local map, moves, robot = parse_input(data)
    for _, move in ipairs(moves) do
        robot = move_robot(map, robot, DIRECTIONS[move])
    end

    local sum = 0
    for y = 1, #map do
        for x = 1, #map[y] do
            if map[y][x] == "O" then
                sum = sum + 100 * (y - 1) + (x - 1)
            end
        end
    end
    return sum
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day15.txt")

    print(string.format("Day 15, part 1: %s", part1(input)))
    print(string.format("Day 15, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<
]]), 2028)

test(part1([[
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
]]), 10092)
-- LuaFormatter on

main()
