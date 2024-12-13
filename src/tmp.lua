local inspect = require("inspect")
local line = "Button A: X+94, Y+34"
local nums = line:gmatch("%d+")

-- for num in nums do
--     print(num)
-- end

local a = nums()
local b = nums()

print(a, b)
