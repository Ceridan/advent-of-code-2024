local io = require("lib.io")
local test = require("lib.test")
local Set = require("struct.set")

local function parse_input(input)
    local lines = io.read_lines_as_array(input)
    local graph = {}
    for _, line in ipairs(lines) do
        local left = line:sub(1, 2)
        local right = line:sub(-2, -1)
        graph[left] = graph[left] or Set.new()
        graph[left][right] = true
        graph[right] = graph[right] or Set.new()
        graph[right][left] = true
    end
    return graph
end

-- https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm (with pivoting)
local function find_max_cliques(graph, R, P, X, cliques)
    if #P == 0 and #X == 0 then
        local clique = {}
        for v in pairs(R) do
            table.insert(clique, v)
        end
        if #clique > 1 then
            table.sort(clique)
            table.insert(cliques, clique)
        end
    end

    local PX = Set.union(P, X)
    local u, neighbors = nil, 0
    for v in pairs(PX) do
        local size = Set.size(graph[v])
        if neighbors < size then
            u = v
            neighbors = size
        end
    end

    for v in pairs(Set.difference(P, graph[u])) do
        local V = Set.new({v})
        find_max_cliques(graph, Set.union(R, V), Set.intersection(P, graph[v]), Set.intersection(X, graph[v]), cliques)
        P = Set.difference(P, V)
        X = Set.union(X, V)
    end
end

local function part1(data)
    local network = parse_input(data)
    local triplets = Set.new()
    for comp1, conn1 in pairs(network) do
        if comp1:sub(1, 1) == "t" then
            for comp2 in pairs(conn1) do
                for comp3 in pairs(network[comp2]) do
                    if comp2 < comp3 and network[comp3][comp1] then
                        local set = {comp1, comp2, comp3}
                        table.sort(set)
                        triplets[table.concat(set)] = true
                    end
                end
            end
        end
    end

    return Set.size(triplets)
end

local function part2(data)
    local network = parse_input(data)
    local vertecies = Set.new()
    for comp in pairs(network) do
        vertecies[comp] = true
    end
    local cliques = {}
    find_max_cliques(network, Set.new(), vertecies, Set.new(), cliques)

    local max_clique = {}
    for _, clique in ipairs(cliques) do
        if #clique > #max_clique then
            max_clique = clique
        end
    end
    return table.concat(max_clique, ",")
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

test(part2(TEST_INPUT), "co,de,ka,ta")
-- LuaFormatter on

main()
