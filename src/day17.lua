local io = require("lib.io")
local test = require("lib.test")
local bit32 = require("bit32")
local inspect = require("inspect")

----------------------------------------
---                VM                ---
----------------------------------------

local VM = {}
VM.__index = VM

function VM.new(a, b, c)
    local self = setmetatable({}, VM)
    self._A = a or 0
    self._B = b or 0
    self._C = c or 0
    self._output = {}
    return self
end

function VM:run(program)
    local combo = function(val)
        if val <= 3 then
            return val
        end
        if val == 4 then
            return self._A
        end
        if val == 5 then
            return self._B
        end
        if val == 6 then
            return self._C
        end
        error("Invalid combo operand")
    end

    local adv = function(cmb)
        self._A = math.floor(self._A / bit32.lshift(2, combo(cmb) - 1))
    end
    local bxl = function(lit)
        self._B = bit32.bxor(self._B, lit)
    end
    local bst = function(cmb)
        self._B = combo(cmb) % 8
    end
    local jnz = function(lit)
        if self._A == 0 then
            return nil
        end
        return lit
    end
    local bxc = function()
        self._B = bit32.bxor(self._B, self._C)
    end
    local out = function(cmb)
        table.insert(self._output, combo(cmb) % 8)
    end
    local bdv = function(cmb)
        self._B = math.floor(self._A / bit32.lshift(2, combo(cmb) - 1))
    end
    local cdv = function(cmb)
        self._C = math.floor(self._A / bit32.lshift(2, combo(cmb) - 1))
    end

    local opcodes = { adv, bxl, bst, jnz, bxc, out, bdv, cdv, }

    local p = 0
    while p < #program do
        local opcode = program[p + 1]
        local operand = program[p + 2]
        local res = opcodes[opcode + 1](operand) or (-1)
        if res >= 0 then
            p = res
        else
            p = p + 2
        end
    end

    return table.concat(self._output, ",")
end

function VM:print_program()
    return table.concat(self._program, ",")
end

function VM:__tostring()
    return string.format([[
Register A: %d
Register B: %d
Register C: %d

Program: %s
Output: %s
]], self._A, self._B, self._C, table.concat(self._program, ","),  table.concat(self._output, ","))
end

----------------------------------------

local function parse_input(input)
    local lines = io.read_lines_as_array(input)
    local a = tonumber(lines[1]:gmatch("%d+")())
    local b = tonumber(lines[2]:gmatch("%d+")())
    local c = tonumber(lines[3]:gmatch("%d+")())

    local program = {}
    local ops = lines[4]:gmatch("%d+")
    for op in ops do
        table.insert(program, tonumber(op))
    end
    return a, b, c, program
end

local function part1(data)
    local a, b, c, program = parse_input(data)
    local vm = VM.new(a, b, c)
    return vm:run(program)
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day17.txt")

    print(string.format("Day 17, part 1: %s", part1(input)))
    print(string.format("Day 17, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
Register A: 10
Register B: 0
Register C: 0

Program: 5,0,5,1,5,4
]]), "0,1,2")

test(part1([[
Register A: 2024
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
]]), "4,2,5,6,7,7,7,7,3,1,0")

test(part1([[
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
]]), "4,6,3,5,6,3,5,2,1,0")

-- test(part2([[
-- Register A: 2024
-- Register B: 0
-- Register C: 0

-- Program: 0,3,5,4,3,0
-- ]]), 117440)
-- LuaFormatter on

main()
