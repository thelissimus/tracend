const std = @import("std");
const Vec3 = @import("Vec3.zig").Vec3;

const Point3 = Vec3;
const Color = Vec3;

fn writeColor(writer: anytype, color: Color) !void {
    const ir: i32 = @intFromFloat(255.999 * color.x);
    const ig: i32 = @intFromFloat(255.999 * color.y);
    const ib: i32 = @intFromFloat(255.999 * color.z);
    try writer.print("{d} {d} {d}\n", .{ ir, ig, ib });
}

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
            try writeColor(stdout, Color.init(
                @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(width - 1)),
                @as(f64, @floatFromInt(j)) / @as(f64, @floatFromInt(height - 1)),
                0,
            ));
        }
    }

    std.log.info("\rDone.\n", .{});

    try bw.flush();
}
