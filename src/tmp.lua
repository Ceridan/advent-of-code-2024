local Point2D = require("struct.point2d")
local inspect = require("inspect")

local a = Point2D.new(1, 2)
local b = Point2D.new(1, 2)

local c = {[a:key()] = 1}


local matr = {{1}}
print(matr[0][1])
