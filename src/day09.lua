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

local function build_disk_to_index(disk)
    local disk_to_index = {}
    local idx = 0
    for _, num in ipairs(disk) do
        table.insert(disk_to_index, idx)
        idx = idx + num
    end
    return disk_to_index
end

local function part1(data)
    local disk = parse_input(data)
    local disk_to_index = build_disk_to_index(disk)
    local checksum = 0
    for k = #disk, 3, -2 do
        for i = 2, k - 1, 2 do
            if disk[k] == 0 then
                break
            end

            if disk[i] > 0 then
                local count = math.min(disk[i], disk[k])
                checksum = checksum + (2 * disk_to_index[i] + count - 1) * count / 2 * (k - 1) / 2
                disk_to_index[i] = disk_to_index[i] + count
                disk[i] = disk[i] - count
                disk[k] = disk[k] - count
            end
        end
    end

    for k = 1, #disk, 2 do
        if disk[k] > 0 then
            checksum = checksum + (2 * disk_to_index[k] + disk[k] - 1) * disk[k] / 2 * (k - 1) / 2
        end
    end

    return checksum
end

local function part2(data)
    local disk = parse_input(data)
    local disk_to_index = build_disk_to_index(disk)
    local checksum = 0
    for k = #disk, 3, -2 do
        for i = 2, k - 1, 2 do
            if disk[k] == 0 then
                break
            end

            if disk[i] >= disk[k] then
                checksum = checksum + (2 * disk_to_index[i] + disk[k] - 1) * disk[k] / 2 * (k - 1) / 2
                disk_to_index[i] = disk_to_index[i] + disk[k]
                disk[i] = disk[i] - disk[k]
                disk[k] = 0
                break
            end
        end
    end

    for k = 1, #disk, 2 do
        if disk[k] > 0 then
            checksum = checksum + (2 * disk_to_index[k] + disk[k] - 1) * disk[k] / 2 * (k - 1) / 2
        end
    end

    return checksum
end

local function main()
    local input = io.read_file("src/inputs/day09.txt")

    print(string.format("Day 09, part 1: %s", part1(input)))
    print(string.format("Day 09, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1("12345"), 60)
test(part1("2333133121414131402"), 1928)

test(part2("2333133121414131402"), 2858)
-- LuaFormatter on

main()
