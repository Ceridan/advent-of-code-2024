local io = require("lib.io")
local test = require("lib.test")
local inspect = require("inspect")
local Queue = require("struct.queue")
local Point2D = require("struct.point2d")

PointWithKey = setmetatable({}, {__index = Point2D})
PointWithKey.__index = PointWithKey

function PointWithKey.new(x, y, key)
    local self = setmetatable(Point2D.new(x, y), PointWithKey)
    self.key = key
    return self
end

function PointWithKey:key()
    return self.key
end

local DIRECTIONS = {
    [">"] = Point2D.new(1, 0),
    ["v"] = Point2D.new(0, 1),
    ["<"] = Point2D.new(-1, 0),
    ["^"] = Point2D.new(0, -1),
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
        ["A"] = Point2D.new(3, 4),
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
        [Point2D.new(3, 4):key()] = "A",
    },
}

-- local NUM_PAD = {
--     ["0"] = {"A", "2"},
--     ["1"] = {"2", "4"},
--     ["2"] = {"0", "1", "3", "5"},
--     ["3"] = {"A", "2", "6"},
--     ["4"] = {"1", "5", "7"},
--     ["5"] = {"2", "4", "6", "8"},
--     ["6"] = {"3", "5", "9"},
--     ["7"] = {"4", "8"},
--     ["8"] = {"5", "7", "9"},
--     ["9"] = {"6", "8"},
--     ["A"] = {"0", "3"},
-- }

-- local NUM_PAD_DISTANCES = {
--     ["0"] = {["0"] = 0, ["1"] = 2, ["2"] = 1, ["3"] = 2, ["4"] = 3, ["5"] = 2, ["6"] = 3, ["7"] = 4, ["8"] = 3, ["9"] = 4, ["A"] = 1},
--     ["1"] = {["0"] = 2, ["1"] = 0, ["2"] = 1, ["3"] = 2, ["4"] = 1, ["5"] = 2, ["6"] = 3, ["7"] = 2, ["8"] = 3, ["9"] = 4, ["A"] = 3},
--     ["2"] = {["0"] = 1, ["1"] = 1, ["2"] = 0, ["3"] = 1, ["4"] = 2, ["5"] = 1, ["6"] = 2, ["7"] = 3, ["8"] = 2, ["9"] = 3, ["A"] = 2},
--     ["3"] = {["0"] = 2, ["1"] = 2, ["2"] = 1, ["3"] = 0, ["4"] = 3, ["5"] = 2, ["6"] = 1, ["7"] = 4, ["8"] = 3, ["9"] = 2, ["A"] = 1},
--     ["4"] = {["0"] = 3, ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 0, ["5"] = 1, ["6"] = 2, ["7"] = 1, ["8"] = 2, ["9"] = 3, ["A"] = 4},
--     ["5"] = {["0"] = 2, ["1"] = 2, ["2"] = 1, ["3"] = 2, ["4"] = 1, ["5"] = 0, ["6"] = 1, ["7"] = 2, ["8"] = 1, ["9"] = 2, ["A"] = 3},
--     ["6"] = {["0"] = 3, ["1"] = 3, ["2"] = 2, ["3"] = 1, ["4"] = 2, ["5"] = 1, ["6"] = 0, ["7"] = 3, ["8"] = 2, ["9"] = 1, ["A"] = 2},
--     ["7"] = {["0"] = 4, ["1"] = 2, ["2"] = 3, ["3"] = 4, ["4"] = 1, ["5"] = 2, ["6"] = 3, ["7"] = 0, ["8"] = 1, ["9"] = 2, ["A"] = 5},
--     ["8"] = {["0"] = 3, ["1"] = 3, ["2"] = 2, ["3"] = 3, ["4"] = 2, ["5"] = 1, ["6"] = 2, ["7"] = 1, ["8"] = 0, ["9"] = 1, ["A"] = 4},
--     ["9"] = {["0"] = 4, ["1"] = 4, ["2"] = 3, ["3"] = 2, ["4"] = 3, ["5"] = 2, ["6"] = 1, ["7"] = 2, ["8"] = 1, ["9"] = 0, ["A"] = 3},
--     ["A"] = {["0"] = 1, ["1"] = 3, ["2"] = 2, ["3"] = 1, ["4"] = 4, ["5"] = 3, ["6"] = 2, ["7"] = 5, ["8"] = 4, ["9"] = 3, ["A"] = 0},
-- }

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
        ["A"] = Point2D.new(3, 1),
    },
    ["pos_to_btn"] = {
        [Point2D.new(2, 1):key()] = "^",
        [Point2D.new(3, 2):key()] = ">",
        [Point2D.new(2, 2):key()] = "v",
        [Point2D.new(1, 2):key()] = "<",
        [Point2D.new(3, 1):key()] = "A",
    },
}

-- local DIR_PAD = {
--     ["^"] = {"v", "A"},
--     [">"] = {"v", "A"},
--     ["v"] = {"<", "^", ">"},
--     ["<"] = {"v"},
--     ["A"] = {"^", ">"},
-- }

-- local DIR_PAD_DISTANCES = {
--     ["^"] = {["^"] = 0, [">"] = 2, ["v"] = 1, ["<"] = 2, ["A"] = 1},
--     [">"] = {["^"] = 2, [">"] = 0, ["v"] = 1, ["<"] = 2, ["A"] = 1},
--     ["v"] = {["^"] = 1, [">"] = 1, ["v"] = 0, ["<"] = 1, ["A"] = 2},
--     ["<"] = {["^"] = 2, [">"] = 2, ["v"] = 1, ["<"] = 0, ["A"] = 3},
--     ["A"] = {["^"] = 1, [">"] = 1, ["v"] = 2, ["<"] = 3, ["A"] = 0},
-- }

-- local function num_pad_bfs(code)
--     local code_arr = {}
--     code:gsub(".", function(ch) table.insert(code_arr, ch) end)

--     local sequences = {}
--     local queue = Queue.new()
--     queue:enqueue({["idx"] = 1, {}})
--     while

--     return sequences
-- end

-- local function num_pad_dfs(code, idx, curr, seq, sequences)
--     if idx == #code + 1 then
--         print(inspect(seq))
--         table.insert(sequences, table.concat(seq))
--         return
--     end

--     if code[idx] == curr then
--         table.insert(seq, "A")
--         num_pad_dfs(code, idx + 1, code[idx], seq, sequences)
--         table.remove(seq)
--         return
--     end

--     local dist = NUM_PAD_DISTANCES[curr][code[idx]]
--     for k, d in pairs(NUM_PAD_DISTANCES[curr]) do
--         if d == 1 and NUM_PAD_DISTANCES[k][code[idx]] < dist then
--             table.insert(seq, k)
--             num_pad_dfs(code, idx, k, seq, sequences)
--             table.remove(seq)
--         end
--     end
-- end

-- local function num_pad_dfs(code, idx, curr, seq, sequences)
--     if idx == #code + 1 then
--         table.insert(sequences, table.concat(seq))
--         return
--     end

--     if code[idx] == curr then
--         table.insert(seq, "A")
--         num_pad_dfs(code, idx + 1, curr, seq, sequences)
--         table.remove(seq)
--         return
--     end

--     local curr_pos = NUM_PAD.BTN_TO_POS[curr]
--     local target_pos = NUM_PAD.BTN_TO_POS[code[idx]]
--     local dist = curr_pos:manhattan(target_pos)
--     for k, dir in pairs(DIRECTIONS) do
--         local next_pos = curr_pos + dir
--         if NUM_PAD.POS_TO_BTN[next_pos:key()] and next_pos:manhattan(target_pos) < dist then
--             table.insert(seq, k)
--             num_pad_dfs(code, idx, NUM_PAD.POS_TO_BTN[next_pos:key()], seq, sequences)
--             table.remove(seq)
--         end
--     end
-- end

-- local function dir_pad_dfs(code, idx, curr, seq, sequences)
--     if idx == #code + 1 then
--         table.insert(sequences, table.concat(seq))
--         return
--     end

--     if code[idx] == curr then
--         table.insert(seq, "A")
--         dir_pad_dfs(code, idx + 1, curr, seq, sequences)
--         table.remove(seq)
--         return
--     end

--     local curr_pos = DIR_PAD.BTN_TO_POS[curr]
--     local target_pos = DIR_PAD.BTN_TO_POS[code[idx]]
--     local dist = curr_pos:manhattan(target_pos)
--     for k, dir in pairs(DIRECTIONS) do
--         local next_pos = curr_pos + dir
--         if DIR_PAD.POS_TO_BTN[next_pos:key()] and next_pos:manhattan(target_pos) < dist then
--             table.insert(seq, k)
--             dir_pad_dfs(code, idx, DIR_PAD.POS_TO_BTN[next_pos:key()], seq, sequences)
--             table.remove(seq)
--         end
--     end
-- end

-- local function dir_pad_dfs(code, idx, curr, steps)
--     if idx == #code + 1 then
--         return steps
--     end

--     return dir_pad_dfs(code, idx + 1, code[idx], steps + DIR_PAD_DISTANCES[curr][code[idx]] + 1)
-- end


local function dfs(pad, code, idx, curr, seq, sequences)
    if idx == #code + 1 then
        table.insert(sequences, table.concat(seq))
        return
    end

    local target = code:sub(idx, idx)
    if target == curr then
        table.insert(seq, "A")
        dfs(pad, code, idx + 1, curr, seq, sequences)
        table.remove(seq)
        return
    end

    local curr_pos = pad.btn_to_pos[curr]
    local target_pos = pad.btn_to_pos[target]
    local dist = curr_pos:manhattan(target_pos)
    for k, dir in pairs(DIRECTIONS) do
        local next_pos = curr_pos + dir
        if pad.pos_to_btn[next_pos:key()] and next_pos:manhattan(target_pos) < dist then
            table.insert(seq, k)
            dfs(pad, code, idx, pad.pos_to_btn[next_pos:key()], seq, sequences)
            table.remove(seq)
        end
    end
end

local function part1(data)
    local codes = io.read_lines_as_array(data)
    local complexity = 0
    for _, code in ipairs(codes) do
        local len = 0
        local seq1 = {}
        dfs(NUM_PAD, code, 1, "A", {}, seq1)
        for _, s1 in ipairs(seq1) do
            local seq2 = {}
            dfs(DIR_PAD, s1, 1, "A", {}, seq2)
            for _, s2 in ipairs(seq2) do
                local seq3 = {}
                dfs(DIR_PAD, s2, 1, "A", {}, seq3)
                for _, s3 in ipairs(seq3) do
                    if len == 0 or string.len(s3) < len then
                        len = string.len(s3)
                    end
                end
            end
        end
        print(code, len)
        complexity = complexity + len * tonumber(code:sub(1,-2))
    end

    -- local code = "v<<A>>^A<A>AvA<^AA>A<vAAA>^A"
    -- local code_arr = {}
    -- code:gsub(".", function(ch) table.insert(code_arr, ch) end)
    -- local sequences = {}
    -- dfs(DIR_PAD, code_arr, 1, "A", {}, sequences)

    return complexity
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day21.txt")

    print(string.format("Day 21, part 1: %s", part1(input)))
    print(string.format("Day 21, part 2: %s", part2(input)))
end

-- LuaFormatter off
print("test1")
test(part1("029A"), 1972)

print("test2")
test(part1([[
029A
980A
179A
456A
379A
]]), 126384)
-- LuaFormatter on

print("main")
main()
