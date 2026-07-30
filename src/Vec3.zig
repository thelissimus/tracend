const std = @import("std");
const math = std.math;

// TODO: Refactor to use `@Vector(3, f64)`.
pub const Vec3 = struct {
    x: f64,
    y: f64,
    z: f64,

    const Self = @This();

    pub fn zero() Self {
        return Self{ .x = 0, .y = 0, .z = 0 };
    }

    pub fn init(x: f64, y: f64, z: f64) Self {
        return Self{ .x = x, .y = y, .z = z };
    }

    pub fn negate(self: Self) Self {
        return Self{ .x = -self.x, .y = -self.y, .z = -self.z };
    }

    pub fn add(self: Self, other: Self) Self {
        return Self{ .x = self.x + other.x, .y = self.y + other.y, .z = self.z + other.z };
    }

    pub fn addMut(self: *Self, other: Self) Self {
        self.x += other.x;
        self.y += other.y;
        self.z += other.z;
        return *self;
    }

    pub fn sub(self: Self, other: Self) Self {
        return Self{ .x = self.x - other.x, .y = self.y - other.y, .z = self.z - other.z };
    }

    pub fn mul(self: Self, other: Self) Self {
        return Self{ .x = self.x * other.x, .y = self.y * other.y, .z = self.z * other.z };
    }

    pub fn mulBy(self: Self, t: f64) Self {
        return Self{ .x = self.x * t, .y = self.y * t, .z = self.z * t };
    }

    pub fn mulByMut(self: *Self, t: f64) Self {
        self.x *= t;
        self.y *= t;
        self.z *= t;
        return *self;
    }

    pub fn divBy(self: Self, t: f64) Self {
        return self.mulBy(1 / t);
    }

    pub fn dot(self: Self, other: Self) f64 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    pub fn cross(self: Self, other: Self) Self {
        return Self{
            .x = self.y * other.z - self.z * other.y,
            .y = self.z * other.x - self.x * other.z,
            .z = self.x * other.y - self.y * other.x,
        };
    }

    pub fn unitVector(self: Self) Self {
        return self.divBy(self.length());
    }

    pub fn length(self: Self) f64 {
        return math.sqrt(self.lengthSquared());
    }

    pub fn lengthSquared(self: Self) f64 {
        return self.x * self.x + self.y * self.y + self.z * self.z;
    }

    pub fn format(self: Self, writer: *std.Io.Writer) std.Io.Writer.Error!void {
        try writer.print("{d} {d} {d}", .{ self.x, self.y, self.z });
    }
};
