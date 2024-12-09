local io = require("lib.io")
local test = require("lib.test")
local inspect = require("inspect")

local function parse_input(input)
    local arr = io.read_text_matrix(input)[1]
    local disk = {}
    for _, num in ipairs(arr) do
        table.insert(disk, tonumber(num))
    end
    return disk
end

local function part1(data)
    local disk = parse_input(data)
    local min_id = 0
    local max_id = (#disk - 1) / 2
    local l, r = 1, #disk
    local idx = 0
    local checksum = 0
    while l <= r do
        if l % 2 == 0 then
            local space = disk[l]
            if space == disk[r] then
                checksum = checksum + (2 * idx + space - 1) * space / 2 * max_id
                idx = idx + space
                max_id = max_id - 1
                l = l + 1
                r = r - 2
            elseif space < disk[r] then
                checksum = checksum + (2 * idx + space - 1) * space / 2 * max_id
                idx = idx + space
                disk[r] = disk[r] - space
                l = l + 1
            else
                checksum = checksum + (2 * idx + disk[r] - 1) * disk[r] / 2 * max_id
                idx = idx + disk[r]
                disk[l] = space - disk[r]
                max_id = max_id - 1
                r = r - 2
            end
        else
            checksum = checksum + (2 * idx + disk[l] - 1) * disk[l] / 2 * min_id
            idx = idx + disk[l]
            min_id = min_id + 1
            l = l + 1
        end
    end

    return checksum
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day09.txt")

    print(string.format("Day 09, part 1: %s", part1(input)))
    print(string.format("Day 09, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1("123"), 6)
test(part1("12345"), 60)
test(part1("2333133121414131402"), 1928)

test(part2(""), 0)
-- LuaFormatter on

main()
