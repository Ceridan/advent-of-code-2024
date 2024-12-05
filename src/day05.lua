local io = require("lib.io")
local test = require("lib.test")
local tbl = require("lib.tbl")
local Set = require("struct.set")

local function parse_input(input)
    local lines = io.read_lines_as_array(input)
    local before = {}
    local update = {}
    for _, line in ipairs(lines) do
        local idx = line:find("|")
        if idx ~= nil then
            local left = tonumber(line:sub(1, idx - 1)) or 0
            local right = tonumber(line:sub(idx + 1, -1)) or 0
            before[right] = before[right] or Set.new()
            before[right][left] = true
        else
            local update_line = {}
            for num in line:gfind("(%d+)") do
                table.insert(update_line, tonumber(num))
            end
            table.insert(update, update_line)
        end
    end
    return before, update
end

local function validate(before, update)
    local valid = {}
    local invalid = {}
    for _, upd in ipairs(update) do
        local ok = true
        local after = Set.new()
        for i = #upd, 1, -1 do
            local intr = Set.intersection(after, before[upd[i]])
            if tbl.table_size(intr) > 0 then
                ok = false
                break
            end
            after[upd[i]] = true
        end

        if ok then
            table.insert(valid, upd)
        else
            table.insert(invalid, upd)
        end
    end
    return valid, invalid
end

local function get_middle(arr)
    local mid_pos = math.floor((1 + #arr) / 2)
    return arr[mid_pos]
end

local function part1(data)
    local before, update = parse_input(data)
    local valid = validate(before, update) or {}
    local mid_sum = 0
    for _, v in ipairs(valid) do
        mid_sum = mid_sum + get_middle(v)
    end
    return mid_sum
end

local function part2(data)
    local before, update = parse_input(data)
    local _, invalid = validate(before, update)
    local mid_sum = 0
    for _, inv in ipairs(invalid) do
        local top = {}
        for _, num in ipairs(inv) do
            local intr = Set.intersection(Set.new(inv), before[num])
            top[tbl.table_size(intr) + 1] = num
        end
        mid_sum = mid_sum + get_middle(top)
    end
    return mid_sum
end

local function main()
    local input = io.read_file("src/inputs/day05.txt")

    print(string.format("Day 05, part 1: %s", part1(input)))
    print(string.format("Day 05, part 2: %s", part2(input)))
end

-- LuaFormatter off
local TEST_INPUT = [[
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
]]

test(part1(TEST_INPUT), 143)
test(part2(TEST_INPUT), 123)
-- LuaFormatter on

main()
