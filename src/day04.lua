local io = require("lib.io")
local test = require("lib.test")

local DIRECTIONS = {{1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1}}

local function prepare_input(input)
    local lines = io.read_lines_as_array(input)
    local matr = {}
    for i, line in ipairs(lines) do
        matr[i] = {}
        for ch in line:gfind(".") do
            table.insert(matr[i], ch)
        end
    end
    return matr
end

local function check_direction(matr, dir, pos)
    local y, x = unpack(pos)
    local dy, dx = unpack(dir)

    if y + dy * 3 <= 0 or y + dy * 3 > #matr then
        return false
    end
    if x + dx * 3 <= 0 or x + dx * 3 > #matr[1] then
        return false
    end

    if matr[y + dy][x + dx] == "M" and matr[y + dy * 2][x + dx * 2] == "A" and matr[y + dy * 3][x + dx * 3] == "S" then
        return true
    end

    return false
end

local function check_direction_x(matr, pos)
    local y, x = unpack(pos)

    if y - 1 <= 0 or y + 1 > #matr then
        return false
    end
    if x - 1 <= 0 or x + 1 > #matr[1] then
        return false
    end

    if (matr[y - 1][x + 1] == "M" and matr[y + 1][x - 1] == "S") or
        (matr[y - 1][x + 1] == "S" and matr[y + 1][x - 1] == "M") then
        if (matr[y - 1][x - 1] == "M" and matr[y + 1][x + 1] == "S") or
            (matr[y - 1][x - 1] == "S" and matr[y + 1][x + 1] == "M") then
            return true
        end
    end

    return false
end

local function part1(data)
    local matr = prepare_input(data)
    local xmas = 0
    for y = 1, #matr do
        for x = 1, #matr[y] do
            if matr[y][x] == "X" then
                local pos = {y, x}
                for _, dir in ipairs(DIRECTIONS) do
                    if check_direction(matr, dir, pos) then
                        xmas = xmas + 1
                    end
                end
            end
        end
    end
    return xmas
end

local function part2(data)
    local matr = prepare_input(data)
    local xmas = 0
    for y = 1, #matr do
        for x = 1, #matr[y] do
            if matr[y][x] == "A" then
                local pos = {y, x}
                if check_direction_x(matr, pos) then
                    xmas = xmas + 1
                end
            end
        end
    end
    return xmas
end

local function main()
    local input = io.read_file("src/inputs/day04.txt")

    print(string.format("Day 04, part 1: %s", part1(input)))
    print(string.format("Day 04, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
]]), 18)

test(part2([[
.M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
..........
]]), 9)
-- LuaFormatter on

main()
