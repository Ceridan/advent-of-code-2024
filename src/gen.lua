local io = require("lib.io")
local http_request = require("http.request")

local args = {...}
local day = args[1]

-- Create code file
local code_filename = string.format("src/day%s.lua", day)
if io.file_exists(code_filename) then
    print(string.format("File already exists on path: %s", code_filename))
    os.exit(1)
end

local code_content = [[
local io = require("lib.io")
local test = require("lib.test")
local inspect = require("inspect")

local function parse_input(input)
    return input
end

local function part1(data)
    return 0
end

local function part2(data)
    return 0
end

local function main()
    local input = io.read_file("src/inputs/day{{DAY}}.txt")

    print(string.format("Day {{DAY}}, part 1: %s", part1(input)))
    print(string.format("Day {{DAY}}, part 2: %s", part2(input)))
end

-- LuaFormatter off
local TEST_INPUT = [[
%]%]

test(part1(TEST_INPUT), 0)

test(part2(TEST_INPUT), 0)
-- LuaFormatter on

main()
]]
code_content = code_content:gsub("{{DAY}}", day)

-- Download input
local input_filename = string.format("src/inputs/day%s.txt", day)
if io.file_exists(input_filename) then
    print(string.format("File already exists on path: %s", input_filename))
    os.exit(1)
end

local url = "https://adventofcode.com"
local req_headers = {
    [":method"] = "GET",
    [":authority"] = "adventofcode.com",
    [":path"] = string.format("/2024/day/%d/input", tonumber(day)),
    ["cookie"] = string.format("session=%s", os.getenv("AOC_SESSION"))
}
local req = http_request.new_from_uri(url)
for key, value in pairs(req_headers) do
    req.headers:upsert(key, value)
end

local headers, stream = assert(req:go())
local body = assert(stream:get_body_as_string())
if headers:get(":status") ~= "200" then
    print("HTTP response code:", headers:get(":status"))
    error(body)
end

io.write_file(code_filename, code_content)
io.write_file(input_filename, body)

-- Add to git
local git = string.format("git add %s %s", code_filename, input_filename)
os.execute(git)
