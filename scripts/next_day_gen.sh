#!/usr/bin/env bash

# This script generates data for the next day: code file and download input.
#
# Usage:
# ./next-day-gen.sh 01

# Read args
if [ $# -eq 0 ]; then
    echo "You must provide day number"
    exit 1
fi

DAY=$1
ROOT_DIR=$(cd -- "$(dirname "$0")/.." >/dev/null 2>&1 || exit ; pwd -P)

# Create code file
code_filename="${ROOT_DIR}/src/day${DAY}.lua"
if [ -f "$code_filename" ]; then
    echo "File \"$code_filename\" already exists"
    exit 1
fi

cat <<EOF > "$code_filename"
local io = require("lib.io")
local test = require("lib.test")

local function part1(data)
    return 0
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_lines_as_number_array("src/inputs/day${DAY}.txt")

    print(string.format("Day ${DAY}, part 1: %s", part1(input)))
    print(string.format("Day ${DAY}, part 2: %s", part2(input)))
end

-- LuaFormatter off
test(part1({}), 0)

test(part2({}), 0)
-- LuaFormatter on

main()

EOF

# Download input
input_filename="${ROOT_DIR}/src/inputs/day${DAY}.txt"
if [ -f "$input_filename" ]; then
    echo "File \"input_filename\" already exists"
    exit 1
fi

cookies="session=${AOC_SESSION}"
curl "https://adventofcode.com/2024/day/$((DAY))/input" -b "${cookies}" -o "${input_filename}"

# Add to git
git add "${code_filename}" "${input_filename}"
