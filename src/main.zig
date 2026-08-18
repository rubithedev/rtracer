const std = @import("std");

const RTracer = @import("rtracer");
const Window = RTracer.Window;
const Tracer = RTracer.Tracer;

const WIDTH = 800;
const HEIGHT = 600;

pub fn main(init: std.process.Init) !void {
    var window = try Window.init(.{
        .io = init.io,
        .allocator = init.gpa,
    });
    defer window.deinit();

    const framebuffer = window.getFrameBuffer();
    Tracer.paintFrameBuffer(framebuffer);

    window.run();
}
