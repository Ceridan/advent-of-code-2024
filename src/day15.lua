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

local function expand_map(map)
    local expanded = {}
    for y=1, #map do
        table.insert(expanded, {})
        for x=1, #map[y] do
            if map[y][x] == "#" then
                table.insert(expanded[y], "#")
                table.insert(expanded[y], "#")
            elseif map[y][x] == "O" then
                table.insert(expanded[y], "[")
                table.insert(expanded[y], "]")
            else
                table.insert(expanded[y], ".")
                table.insert(expanded[y], ".")
            end
        end
    end
    return expanded
end


local function move_horizontal(map, robot, dir)
    local new_robot = robot + dir
    local y = new_robot.y
    local x_end = #map[1]
    if dir.x == -1 then
        x_end = 1
    end
    for x = new_robot.x, x_end, dir.x do
        if map[y][x] == "#" then
            return robot
        elseif map[y][x] == "." then
            for k = x, new_robot.x, -dir.x do
                map[y][k] = map[y][k - dir.x]
            end
            return new_robot
        end
    end
    return robot
end

local function move_vertical(map, robot, dir)
    local new_robot = robot + dir
    local x = new_robot.x
    local y_end = #map
    if dir.y == -1 then
        y_end = 1
    end
    for y = new_robot.y, y_end, dir.y do
        if map[y][x] == "#" then
            return robot
        elseif map[y][x] == "." then
            for k = y, new_robot.y, -dir.y do
                map[k][x] = map[k - dir.y][x]
            end
            return new_robot
        end
    end
    return robot
end

local function check_wall(map, x, y, dir)
    if map[y][x] == "#" then
        return true
    elseif map[y][x] == "." then
        return false
    elseif map[y][x] == "[" then
        return check_wall(map, x + dir.x, y + dir.y, dir) or check_wall(map, x + dir.x + 1, y + dir.y, dir)
    else
        return check_wall(map, x + dir.x, y + dir.y, dir) or check_wall(map, x + dir.x - 1, y + dir.y, dir)
    end
end

local function move_box(map, x, y, dir)
    if map[y + dir.y][x + dir.x] == "[" then
        move_box(map, x + dir.x, y + dir.y, dir)
    elseif map[y + dir.y][x + dir.x] == "]" then
        move_box(map, x + dir.x - 1, y + dir.y, dir)
    end
    if map[y + dir.y][x + dir.x + 1] == "[" then
        move_box(map, x + dir.x + 1, y + dir.y, dir)
    end

    map[y + dir.y][x + dir.x] = "["
    map[y + dir.y][x + dir.x + 1] = "]"
    map[y][x] = "."
    map[y][x + 1] = "."
end

local function move_vertical_wide(map, robot, dir)
    local new_robot = robot + dir
    if check_wall(map, new_robot.x, new_robot.y, dir) then
        return robot
    end

    if map[new_robot.y][new_robot.x] == "[" then
        move_box(map, new_robot.x, new_robot.y, dir)
    elseif map[new_robot.y][new_robot.x] == "]" then
        move_box(map, new_robot.x - 1, new_robot.y, dir)
    end

    return new_robot
end

local function move_robot(map, moves, robot, vertical_fn, box_symbol)
    for _, move in ipairs(moves) do
        if move == ">" or move == "<" then
            robot = move_horizontal(map, robot, DIRECTIONS[move])
        else
            robot = vertical_fn(map, robot, DIRECTIONS[move])
        end
    end

    local sum = 0
    for y = 1, #map do
        for x = 1, #map[y] do
            if map[y][x] == box_symbol then
                sum = sum + 100 * (y - 1) + (x - 1)
            end
        end
    end
    return sum
end

local function part1(data)
    local map, moves, robot = parse_input(data)
    return move_robot(map, moves, robot, move_vertical, "O")
end

local function part2(data)
    local map, moves, robot = parse_input(data)
    map = expand_map(map)
    robot = Point2D.new(robot.x * 2 - 1, robot.y)
    return move_robot(map, moves, robot, move_vertical_wide, "[")
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


test(part2([[
#######
#...#.#
#.....#
#..OO@#
#..O..#
#.....#
#######

<vv<<^^<<^^
]]), 618)

test(part2([[
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
]]), 9021)
-- LuaFormatter on

main()
