local io = require("lib.io")
local test = require("lib.test")

local DIRECTIONS = {{1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1}}

local function check_word(matr, pos, dir)
    local y, x = unpack(pos)
    local dy, dx = unpack(dir)

    if y + dy * 3 <= 0 or y + dy * 3 > #matr then
        return false
    end
    if x + dx * 3 <= 0 or x + dx * 3 > #matr[1] then
        return false
    end

    return matr[y + dy][x + dx] == "M" and matr[y + dy * 2][x + dx * 2] == "A" and matr[y + dy * 3][x + dx * 3] == "S"
end

local function check_symbol(matr, pos)
    local y, x = unpack(pos)

    if y - 1 <= 0 or y + 1 > #matr then
        return false
    end
    if x - 1 <= 0 or x + 1 > #matr[1] then
        return false
    end

    local top_left_ms = matr[y - 1][x - 1] == "M" and matr[y + 1][x + 1] == "S"
    local top_left_sm = matr[y - 1][x - 1] == "S" and matr[y + 1][x + 1] == "M"
    local top_right_ms = matr[y - 1][x + 1] == "M" and matr[y + 1][x - 1] == "S"
    local top_right_sm = matr[y - 1][x + 1] == "S" and matr[y + 1][x - 1] == "M"
    return (top_left_ms or top_left_sm) and (top_right_ms or top_right_sm)
end

local function part1(data)
    local matr = io.read_text_matrix(data)
    local xmas = 0
    for y = 1, #matr do
        for x = 1, #matr[y] do
            if matr[y][x] == "X" then
                local pos = {y, x}
                for _, dir in ipairs(DIRECTIONS) do
                    if check_word(matr, pos, dir) then
                        xmas = xmas + 1
                    end
                end
            end
        end
    end
    return xmas
end

local function part2(data)
    local matr = io.read_text_matrix(data)
    local xmas = 0
    for y = 1, #matr do
        for x = 1, #matr[y] do
            if matr[y][x] == "A" then
                local pos = {y, x}
                if check_symbol(matr, pos) then
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
