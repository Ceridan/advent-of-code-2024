local io = require("lib.io")
local test = require("lib.test")
local bit32 = require("bit32")
local Queue = require("struct.queue")

local function parse_input(input)
    local lines = io.read_lines_as_array(input)
    local wires = {}
    local gates = {}

    local function set_gate(wire, gate)
        wires[wire] = wires[wire] or {}
        wires[wire]["gates"] = wires[wire]["gates"] or {}
        table.insert(wires[wire]["gates"], gate)
    end

    local gate_id = 1
    for _, line in ipairs(lines) do
        local colon = line:find(":")
        if colon ~= nil then
            local wire = line:sub(1, colon - 1)
            local bit = tonumber(line:sub(colon + 2, -1))
            wires[wire] = {["bit"] = bit, ["gates"] = {}}
        else
            local match = line:gmatch("[^%s]+")
            local wire1, op, wire2, _, wire3 = match(), match(), match(), match(), match()
            gates[gate_id] = {["op"] = op, ["args"] = {wire1, wire2}, ["res"] = wire3}
            set_gate(wire1, gate_id)
            set_gate(wire2, gate_id)
            gate_id = gate_id + 1
        end
    end

    return wires, gates
end

local function apply_gate(op, a, b)
    if op == "AND" then
        return bit32.band(a, b)
    elseif op == "OR" then
        return bit32.bor(a, b)
    elseif op == "XOR" then
        return bit32.bxor(a, b)
    else
        error("unsupported gate")
    end
end

local function read_output(wires)
    local bits = {}
    for wire in pairs(wires) do
        if wire:sub(1, 1) == "z" then
            local bit_id = tonumber(wire:sub(2, -1))
            bits[bit_id + 1] = wires[wire].bit
        end
    end

    local output = 0
    local modifier = 1
    for _, bit in ipairs(bits) do
        output = output + bit * modifier
        modifier = modifier * 2
    end
    return output
end

local function check_gate(wires, gates, gate_id)
    local gate = gates[gate_id]
    return wires[gate.args[1]].bit ~= nil and wires[gate.args[2]].bit ~= nil
end

local function get_max_output(gates)
    local max_z = "z00"
    for _, gate in ipairs(gates) do
        if gate.res:sub(1, 1) == "z" and gate.res > max_z then
            max_z = gate.res
        end
    end
    return max_z
end

local function part1(data)
    local wires, gates = parse_input(data)
    local queue = Queue.new()
    for id in ipairs(gates) do
        if check_gate(wires, gates, id) then
            queue:enqueue(id)
        end
    end

    while not queue:is_empty() do
        local id = queue:dequeue()
        local wire1, wire2 = gates[id].args[1], gates[id].args[2]
        local res_wire = gates[id].res
        local res_bit = apply_gate(gates[id].op, wires[wire1].bit, wires[wire2].bit)
        wires[res_wire] = wires[res_wire] or {["gates"] = {}}
        wires[res_wire]["bit"] = res_bit

        for _, gate_id in ipairs(wires[res_wire].gates) do
            if check_gate(wires, gates, gate_id) then
                queue:enqueue(gate_id)
            end
        end
    end
    return read_output(wires)
end

local function part2(data)
    local wires, gates = parse_input(data)
    local max_z = get_max_output(gates)

    local swapped_set = {}

    -- https://en.wikipedia.org/wiki/Adder_(electronics)
    for _, gate in ipairs(gates) do
        -- only XOR-gate can output to "z" except the highest bit
        if gate.op ~= "XOR" and gate.res:sub(1, 1) == "z" and gate.res ~= max_z then
            swapped_set[gate.res] = true
            -- AND-gate must output to OR-gate except the lowest bit (where carry-in is zero)
        elseif gate.op == "AND" and gate.args[1] ~= "x00" and gate.args[2] ~= "x00" and wires[gate.res] then
            for _, gate_id in ipairs(wires[gate.res].gates) do
                if gates[gate_id].op ~= "OR" then
                    swapped_set[gate.res] = true
                end
            end
            -- XOR-gate must be connected to inputs (x, y) or outputs (z)
        elseif gate.op == "XOR" and
            (gate.args[1]:sub(1, 1) ~= "x" and gate.args[1]:sub(1, 1) ~= "y" and gate.args[1]:sub(1, 1) ~= "z") and
            (gate.args[2]:sub(1, 1) ~= "x" and gate.args[2]:sub(1, 1) ~= "y" and gate.args[2]:sub(1, 1) ~= "z") and
            (gate.res:sub(1, 1) ~= "x" and gate.res:sub(1, 1) ~= "y" and gate.res:sub(1, 1) ~= "z") then
            swapped_set[gate.res] = true
            -- XOR-gate cannot be connected to OR-gate
        elseif gate.op == "XOR" and wires[gate.res] then
            for _, gate_id in ipairs(wires[gate.res].gates) do
                if gates[gate_id].op == "OR" then
                    swapped_set[gate.res] = true
                end
            end
        end
    end

    local swapped_list = {}
    for w in pairs(swapped_set) do
        table.insert(swapped_list, w)
    end
    table.sort(swapped_list)
    return table.concat(swapped_list, ",")
end

local function main()
    local input = io.read_file("src/inputs/day24.txt")

    print(string.format("Day 24, part 1: %12.0f", part1(input)))
    print(string.format("Day 24, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
x00: 1
x01: 1
x02: 1
y00: 0
y01: 1
y02: 0

x00 AND y00 -> z00
x01 XOR y01 -> z01
x02 OR y02 -> z02
]]), 4)

test(part1([[
x00: 1
x01: 0
x02: 1
x03: 1
x04: 0
y00: 1
y01: 1
y02: 1
y03: 1
y04: 1

ntg XOR fgs -> mjb
y02 OR x01 -> tnw
kwq OR kpj -> z05
x00 OR x03 -> fst
tgd XOR rvg -> z01
vdt OR tnw -> bfw
bfw AND frj -> z10
ffh OR nrd -> bqk
y00 AND y03 -> djm
y03 OR y00 -> psh
bqk OR frj -> z08
tnw OR fst -> frj
gnj AND tgd -> z11
bfw XOR mjb -> z00
x03 OR x00 -> vdt
gnj AND wpb -> z02
x04 AND y00 -> kjc
djm OR pbm -> qhw
nrd AND vdt -> hwm
kjc AND fst -> rvg
y04 OR y02 -> fgs
y01 AND x02 -> pbm
ntg OR kjc -> kwq
psh XOR fgs -> tgd
qhw XOR tgd -> z09
pbm OR djm -> kpj
x03 XOR y03 -> ffh
x00 XOR y04 -> ntg
bfw OR bqk -> z06
nrd XOR fgs -> wpb
frj XOR qhw -> z04
bqk OR frj -> z07
y03 OR x01 -> nrd
hwm AND bqk -> z03
tgd XOR rvg -> z12
tnw OR pbm -> gnj
]]), 2024)
-- LuaFormatter on

main()

-- cph,gtb,jqn,kwb,qkf,z12,z16,z24
-- cph,jqn,kwb,qkf,tgr,z12,z16,z24 - correct
