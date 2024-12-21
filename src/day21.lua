local io = require("lib.io")
local test = require("lib.test")
local Queue = require("struct.queue")
local Point2D = require("struct.point2d")

local DIRECTIONS = {
    [">"] = Point2D.new(1, 0),
    ["v"] = Point2D.new(0, 1),
    ["^"] = Point2D.new(0, -1),
    ["<"] = Point2D.new(-1, 0)
}

-- +---+---+---+
-- | 7 | 8 | 9 |
-- +---+---+---+
-- | 4 | 5 | 6 |
-- +---+---+---+
-- | 1 | 2 | 3 |
-- +---+---+---+
--     | 0 | A |
--     +---+---+

local NUM_PAD = {
    ["btn_to_pos"] = {
        ["0"] = Point2D.new(2, 4),
        ["1"] = Point2D.new(1, 3),
        ["2"] = Point2D.new(2, 3),
        ["3"] = Point2D.new(3, 3),
        ["4"] = Point2D.new(1, 2),
        ["5"] = Point2D.new(2, 2),
        ["6"] = Point2D.new(3, 2),
        ["7"] = Point2D.new(1, 1),
        ["8"] = Point2D.new(2, 1),
        ["9"] = Point2D.new(3, 1),
        ["A"] = Point2D.new(3, 4)
    },
    ["pos_to_btn"] = {
        [Point2D.new(2, 4):key()] = "0",
        [Point2D.new(1, 3):key()] = "1",
        [Point2D.new(2, 3):key()] = "2",
        [Point2D.new(3, 3):key()] = "3",
        [Point2D.new(1, 2):key()] = "4",
        [Point2D.new(2, 2):key()] = "5",
        [Point2D.new(3, 2):key()] = "6",
        [Point2D.new(1, 1):key()] = "7",
        [Point2D.new(2, 1):key()] = "8",
        [Point2D.new(3, 1):key()] = "9",
        [Point2D.new(3, 4):key()] = "A"
    }
}

--     +---+---+
--     | ^ | A |
-- +---+---+---+
-- | < | v | > |
-- +---+---+---+

local DIR_PAD = {
    ["btn_to_pos"] = {
        ["^"] = Point2D.new(2, 1),
        [">"] = Point2D.new(3, 2),
        ["v"] = Point2D.new(2, 2),
        ["<"] = Point2D.new(1, 2),
        ["A"] = Point2D.new(3, 1)
    },
    ["pos_to_btn"] = {
        [Point2D.new(2, 1):key()] = "^",
        [Point2D.new(3, 2):key()] = ">",
        [Point2D.new(2, 2):key()] = "v",
        [Point2D.new(1, 2):key()] = "<",
        [Point2D.new(3, 1):key()] = "A"
    }
}

local function list_shortest_paths(pad, from, to)
    local paths = {}
    local from_pos = pad.btn_to_pos[from]
    local to_pos = pad.btn_to_pos[to]
    local queue = Queue.new()
    queue:enqueue({["pos"] = from_pos, ["path"] = ""})
    while not queue:is_empty() do
        local item = queue:dequeue()
        if item.pos == to_pos then
            table.insert(paths, item.path .. "A")
        else
            local dist = item.pos:manhattan(to_pos)
            for k, dir in pairs(DIRECTIONS) do
                local pos = item.pos + dir
                if pad.pos_to_btn[pos:key()] and pos:manhattan(to_pos) < dist then
                    queue:enqueue({["pos"] = pos, ["path"] = item.path .. k})
                end
            end
        end
    end
    return paths
end

local function build_path_map(pad)
    local path_map = {}
    for key1, pos1 in pairs(pad.btn_to_pos) do
        for key2, pos2 in pairs(pad.btn_to_pos) do
            local paths = list_shortest_paths(pad, key1, key2)
            path_map[key1] = path_map[key1] or {}
            path_map[key1][key2] = {["paths"] = paths, ["len"] = pos1:manhattan(pos2) + 1}
        end
    end
    return path_map
end

local function dfs(seq, pads, dir_pads_map, cache)
    if cache[pads] and cache[pads][seq] then
        return cache[pads][seq]
    end

    local len = 0
    local k1 = "A"
    for i = 1, string.len(seq) do
        local k2 = seq:sub(i, i)
        if pads == 0 then
            len = len + dir_pads_map[k1][k2].len
        else
            local min_len = 0
            for _, path in ipairs(dir_pads_map[k1][k2].paths) do
                local path_len = dfs(path, pads - 1, dir_pads_map, cache)
                if min_len == 0 or min_len > path_len then
                    min_len = path_len
                end
            end
            len = len + min_len
        end
        k1 = k2
    end
    cache[pads] = cache[pads] or {}
    cache[pads][seq] = len
    return len
end

local function calculate_code_complexity(code, pads)
    local num_map = build_path_map(NUM_PAD)
    local dir_map = build_path_map(DIR_PAD)

    local cache = {}
    local len = 0
    local k1 = "A"
    for i = 1, string.len(code) do
        local k2 = code:sub(i, i)
        local min_len = 0
        for _, path in ipairs(num_map[k1][k2].paths) do
            local path_len = dfs(path, pads - 1, dir_map, cache)
            if min_len == 0 or min_len > path_len then
                min_len = path_len
            end
        end
        len = len + min_len
        k1 = k2
    end

    return len * tonumber(code:sub(1, -2))
end

local function calculate_total_complexity(codes, dir_pads)
    local complexity = 0
    for _, code in ipairs(codes) do
        complexity = complexity + calculate_code_complexity(code, dir_pads)
    end
    return complexity
end

local function part1(data, dir_pads)
    local codes = io.read_lines_as_array(data)
    return calculate_total_complexity(codes, dir_pads)
end

local function part2(data, dir_pads)
    local codes = io.read_lines_as_array(data)
    return calculate_total_complexity(codes, dir_pads)
end

local function main()
    local input = io.read_file("src/inputs/day21.txt")

    print(string.format("Day 21, part 1: %5.0f", part1(input, 2)))
    print(string.format("Day 21, part 2: %10.0f", part2(input, 25)))
end

-- LuaFormatter off
test(part1("029A", 2), 1972)

test(part1("379A", 2), 24256)

test(part1([[
029A
980A
179A
456A
379A
]], 2), 126384)
-- LuaFormatter on

main()
