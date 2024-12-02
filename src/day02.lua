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
    for j = 1, #report-1 do
        local sign = calc_sign(report[j], report[j+1])
        local diff = math.abs(report[j] - report[j+1])
        if sign == 0 or sign ~= base_sign or diff < 1 or diff > 3 then
            return {safe = false, err = j}
        end
    end
    return {safe = true, err = nil}
end

local function new_report(report, remove_index)
    remove_index = remove_index or 0
    local copy_report = tbl.copy_array(report)
    if remove_index >= 1 and remove_index <= #copy_report then
        table.remove(copy_report, remove_index)
    end
    return copy_report
end

local function part1(data)
    local reports = parse_input(data)
    local safe = 0
    for i = 1, #reports do
        local res = process_report(reports[i])
        if res.safe then
            safe = safe + 1
        end
    end
    return safe
end

local function part2(data)
    local reports = parse_input(data)
    local safe = 0
    for i = 1, #reports do
        local res = process_report(reports[i])
        if res.safe then
            safe = safe + 1
        else
            for j = res.err - 1, res.err + 1 do
                local subres = process_report(new_report(reports[i], j))
                if subres.safe then
                    safe = safe + 1
                    break
                end
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

test(part2([[
8 9 8 5 4
]]), 1)
-- LuaFormatter on

main()
