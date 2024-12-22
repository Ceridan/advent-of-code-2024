local io = require("lib.io")
local test = require("lib.test")
local bit32 = require("bit32")

local SECRETS_COUNT = 2000
local MODULO = 16777216
local SEQUENCE_LENGTH = 4

local function calculate_next_secret(secret)
    local val = secret * 64
    val = bit32.bxor(val, secret)
    val = val % MODULO

    val = bit32.bxor(math.floor(val / 32), val)
    val = val % MODULO

    val = bit32.bxor(val * 2048, val)
    val = val % MODULO

    return val
end

local function part1(data)
    local secrets = io.read_lines_as_array(data, tonumber)
    local total_sum = 0
    for _, secret in ipairs(secrets) do
        for _ = 1, SECRETS_COUNT do
            secret = calculate_next_secret(secret)
        end
        total_sum = total_sum + secret
    end

    return total_sum
end

local function part2(data)
    local secrets = io.read_lines_as_array(data, tonumber)
    local sequences = {}
    for i, secret in ipairs(secrets) do
        local secret_seq = {}
        local prev = secret % 10
        for _ = 1, SECRETS_COUNT do
            secret = calculate_next_secret(secret)
            local curr = secret % 10
            table.insert(secret_seq, curr - prev)

            if #secret_seq == SEQUENCE_LENGTH then
                local key = table.concat(secret_seq, ",")
                if not sequences[key] or not sequences[key][i] then
                    sequences[key] = sequences[key] or {}
                    sequences[key][i] = sequences[key][i] or {}
                    sequences[key][i] = curr
                end
                table.remove(secret_seq, 1)
            end
            prev = curr
        end
    end

    local max_bananas = 0
    for _, monkeys in pairs(sequences) do
        local bananas = 0
        for _, num in pairs(monkeys) do
            bananas = bananas + num
        end
        max_bananas = math.max(max_bananas, bananas)
    end

    return max_bananas
end

local function main()
    local input = io.read_file("src/inputs/day22.txt")

    print(string.format("Day 22, part 1: %s", part1(input)))
    print(string.format("Day 22, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1([[
1
10
100
2024
]]), 37327623)

test(part2([[
1
2
3
2024
]]), 23)
-- LuaFormatter on

main()
