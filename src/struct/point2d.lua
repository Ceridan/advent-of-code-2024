local Point2D = {}
Point2D.__index = Point2D

function Point2D.new(x, y)
    local self = setmetatable({}, Point2D)
    self.x = x or 0
    self.y = y or 0
    return self
end

function Point2D:__add(other)
    return Point2D.new(self.x + other.x, self.y + other.y)
end

function Point2D:__sub(other)
    return Point2D.new(self.x - other.x, self.y - other.y)
end

function Point2D:__eq(other)
    return self.x == other.x and self.y == other.y
end

function Point2D:__tostring()
    return string.format("Point2D(%.2f, %.2f)", self.x, self.y)
end

function Point2D:const_mult(val)
    return Point2D.new(self.x * val, self.y * val)
end

function Point2D:distance(other)
    return math.sqrt((self.x - other.x) ^ 2 + (self.y - other.y) ^ 2)
end

function Point2D:key()
    return self:__tostring()
end

function Point2D:copy()
    return Point2D.new(self.x, self.y)
end

return Point2D
