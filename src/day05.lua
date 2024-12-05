local io = require("lib.io")
local test = require("lib.test")
local Set = require("struct.set")
local tbl = require("lib.tbl")

local function parse_input(input)
    local lines = io.read_lines_as_array(input)
    local before = {}
    local update = {}
    for _, line in ipairs(lines) do
        local idx = line:find("|")
        if idx ~= nil then
            local left = tonumber(line:sub(1, idx - 1))
            local right = tonumber(line:sub(idx + 1, -1))
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
    local result = {valid = {}, invalid = {}}

    for _, upd in ipairs(update) do
        local ok = true
        local after = Set.new()
        for i = #upd, 1, -1 do
            local intr = Set.intersection(after, before[upd[i]])
            if next(intr) ~= nil then
                ok = false
                break
            end
            after[upd[i]] = true
        end

        if ok then
            table.insert(result.valid, upd)
        else
            table.insert(result.invalid, upd)
        end
    end
    return result
end

local function part1(data)
    local before, update = parse_input(data)
    local result = validate(before, update) or {}
    local mid_sum = 0
    for _, valid in ipairs(result.valid) do
        local mid_pos = math.floor((1 + #valid) / 2)
        mid_sum = mid_sum + valid[mid_pos]
    end
    return mid_sum
end

local function part2(data)
    local before, update = parse_input(data)
    local result = validate(before, update) or {}
    local mid_sum = 0
    for _, invalid in ipairs(result.invalid) do
        local freq = {}
        for _, num in ipairs(invalid) do
            local intr = Set.intersection(Set.new(invalid), before[num])
            freq[tbl.table_size(intr) + 1] = num
        end
        local mid_pos = math.floor((1 + #freq) / 2)
        mid_sum = mid_sum + freq[mid_pos]
    end
    return mid_sum
end

local function main()
    local input = io.read_file("src/inputs/day05.txt")

    print(string.format("Day 05, part 1: %s", part1(input)))
    print(string.format("Day 05, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
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
]]), 143)

test(part2([[
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
]]), 123)
-- LuaFormatter on

main()
