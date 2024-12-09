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

local function build_idx_to_id(disk)
    local idx_to_id = {}
    local id = 0
    for i = 0, #disk-1, 2 do
        idx_to_id[i+1] = i
    end
    return idx_to_id
end

local function build_free_space_map(disk)
    local free_space = {}
    for i = 2, #disk, 2 do
        if disk[i] > 0 then
            free_space[disk[i]] = free_space[disk[i]] or {}
            table.insert(free_space[disk[i]], i)
        end
    end
    return free_space
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
    local disk = parse_input(data)
    local disk_to_index = build_disk_to_index(disk)
    local checksum = 0
    for k = #disk, 3, -2 do
        if disk[k] > 0 then
            for i = 2, k - 1, 2 do
                if disk[i] >= disk[k] then
                    checksum = checksum + (2 * disk_to_index[i] + disk[k] - 1) * disk[k] / 2 * (k - 1) / 2
                    disk_to_index[i] = disk_to_index[i] + disk[k]
                    disk[i] = disk[i] - disk[k]
                    disk[k] = 0
                end
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
