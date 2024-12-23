local io = require("lib.io")
local test = require("lib.test")
local inspect = require("inspect")

local function parse_input(input)
    local lines = io.read_lines_as_array(input)
    local graph = {}
    for _, line in ipairs(lines) do
        local left = line:sub(1, 2)
        local right = line:sub(-2, -1)
        graph[left] = graph[left] or {}
        graph[left][right] = true
        graph[right] = graph[right] or {}
        graph[right][left] = true
    end
    return graph
end

local function part1(data)
    local network = parse_input(data)
    local sets = {}
    for comp1, conn1 in pairs(network) do
        if comp1:sub(1, 1) == "t" then
            for comp2 in pairs(conn1) do
                for comp3 in pairs(network[comp2]) do
                    if comp2 < comp3 and network[comp3][comp1] then
                        local set = {comp1, comp2, comp3}
                        table.sort(set)
                        sets[table.concat(set)] = 1
                    end
                end
            end
        end
    end

    local sum = 0
    for _, s in pairs(sets) do
        sum = sum + s
    end
    return sum
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day23.txt")

    print(string.format("Day 23, part 1: %s", part1(input)))
    print(string.format("Day 23, part 2: %s", part2(input)))
end

-- LuaFormatter off
local TEST_INPUT = [[
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
]]

test(part1(TEST_INPUT), 7)

test(part2(TEST_INPUT), 0)
-- LuaFormatter on

main()
