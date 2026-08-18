const std = @import("std");
const Allocator = std.mem.Allocator;
const Io = std.Io;
const wio = @import("wio");

const WioWindow = wio.Window;
const EventQueue = wio.EventQueue;
const Framebuffer = wio.Framebuffer;

// Globals
var events: EventQueue = .empty;

pub const Args = struct {
    io: Io,
    allocator: Allocator,
    title: [:0]const u8 = "RTracer",
    width: u16 = 800,
    height: u16 = 600,
};

pub const Window = struct {
    window: WioWindow = undefined,
    framebuffer: Framebuffer = undefined,

    pub fn init(args: Args) !Window {
        var self = Window{};

        try wio.init(.{
            .allocator = args.allocator,
            .io = args.io,
            .eventFn = wio.EventQueue.eventFn,
        });

        var window = try wio.Window.create(.{
            .title = args.title,
            .event_fn_data = &events,
            .size = .{
                .width = args.width,
                .height = args.height,
            },
        });

        var framebuffer: Framebuffer = undefined;
        framebuffer = try window.createFramebuffer(.{
            .width = args.width,
            .height = args.height,
        });

        self.window = window;
        self.framebuffer = framebuffer;

        return self;
    }

    pub fn deinit(self: *Window) void {
        events.deinit();
        self.framebuffer.destroy();
        self.window.destroy();
        wio.deinit();
    }

    pub fn getFrameBuffer(self: *Window) *Framebuffer {
        return &self.framebuffer;
    }

    pub fn run(self: *Window) void {
        while (true) {
            wio.update();
            while (events.pop()) |event| {
                switch (event) {
                    .close => return,
                    .draw => self.window.presentFramebuffer(&self.framebuffer),
                    else => {},
                }
            }
        }
    }
};
