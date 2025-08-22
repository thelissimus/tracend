const std = @import("std");
const math = std.math;

// TODO: Refactor to use `@Vector(3, f64)`.
const Vec3 = struct {
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

    pub fn mulMutBy(self: *Self, t: f64) Self {
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

    pub fn format(
        self: Self,
        comptime Fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = Fmt;
        _ = options;
        try writer.print("{d} {d} {d}", .{ self.x, self.y, self.z });
    }
};

const Point3 = Vec3;

pub fn main() !void {
    var bw = std.io.bufferedWriter(std.io.getStdOut().writer());
    const stdout = bw.writer();

    const width = 256;
    const height = 256;

    try stdout.print(
        \\P3
        \\{d} {d}
        \\255
        \\
    , .{ width, height });

    for (0..height) |j| {
        std.log.info("\rScanlines remaining: {d}", .{height - j});

        for (0..width) |i| {
            const r = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(width - 1));
            const g = @as(f64, @floatFromInt(j)) / @as(f64, @floatFromInt(height - 1));
            const b = 0.0;

            const ir: i32 = @intFromFloat(255.999 * r);
            const ig: i32 = @intFromFloat(255.999 * g);
            const ib: i32 = @intFromFloat(255.999 * b);

            try stdout.print("{d} {d} {d}\n", .{ ir, ig, ib });
        }
    }

    std.log.info("\rDone.\n", .{});

    try bw.flush();
}
