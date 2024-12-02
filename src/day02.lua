local io = require("lib.io")
local test = require("lib.test")
local tbl = require("lib.tbl")

local function parse_input(input)
    local data = io.read_matrix(input, " ", tonumber)
    return data
end

local function calc_sign(left, right)
    if (left < right) then
        return 1
    end
    if (left > right) then
        return -1
    end
    return 0
end

local function process_report(report)
    local base_sign = calc_sign(report[1], report[2])
    for j = 2, #report do
        local sign = calc_sign(report[j-1], report[j])
        local diff = math.abs(report[j-1] - report[j])
        if sign == 0 or sign ~= base_sign or diff < 1 or diff > 3 then
            return {
                safe = false,
                left = j-1,
                right = j,
            }
        end
    end
    return {
        safe = true
    }
end

local function new_report(report, remove_index)
    remove_index = remove_index or 0
    local new_report = tbl.copy_array(report)
    if remove_index > 0 then
        table.remove(new_report, remove_index)
    end
    return new_report
end

local function part1(data)
    local reports = parse_input(data)
    local safe = 0
    for i = 1, #reports do
        local result = process_report(reports[i])
        if result.safe then
            safe = safe + 1
        end
    end
    return safe
end

-- local function part2(data)
--     local reports = parse_input(data)
--     local safe = 0
--     for i = 1, #reports do
--         local result = process_report(reports[i])
--         if result.safe then
--             safe = safe + 1
--         else
--             local result_left = process_report(new_report(reports[i], result.left))
--             local result_right = process_report(new_report(reports[i], result.right))
--             if result_left.safe or result_right.safe then
--                 safe = safe + 1
--             end
--         end
--     end
--     return safe
-- end

local function part2(data)
    local reports = parse_input(data)
    local safe = 0
    for i = 1, #reports do
        for j = 0, #reports[i] do
            local report = new_report(reports[i], j)
            local result = process_report(report)
            if result.safe then
                safe = safe + 1
                break
            end
        end
    end
    return safe
end

local function main()
    local input = io.read_file("src/inputs/day02.txt")

    print(string.format("Day 02, part 1: %s", part1(input)))
    print(string.format("Day 02, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
]]), 2)

test(part2([[
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
]]), 4)
-- LuaFormatter on

main()

-- 423 - too low
