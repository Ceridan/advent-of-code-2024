local Point3D = {}
Point3D.__index = Point3D

function Point3D.new(x, y, z)
    local self = setmetatable({}, Point3D)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    return self
end

function Point3D:__add(other)
    return Point3D.new(self.x + other.x, self.y + other.y, self.z + other.z)
end

function Point3D:__sub(other)
    return Point3D.new(self.x - other.x, self.y - other.y, self.z - other.z)
end

function Point3D:__tostring()
    return string.format("Point3D(%.2f, %.2f, %.2f)", self.x, self.y, self.z)
end

function Point3D:distance(other)
    return math.sqrt((self.x - other.x) ^ 2 + (self.y - other.y) ^ 2 + (self.z - other.z) ^ 2)
end

function Point3D:copy()
    return Point3D.new(self.x, self.y, self.z)
end

return Point3D
