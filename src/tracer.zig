const wio = @import("wio");
const FrameBuffer = wio.Framebuffer;

pub const Tracer = struct {
    pub fn paintFrameBuffer(framebuffer: *FrameBuffer) void {
        framebuffer.*.setPixel(0, 0, 0xF7A41D);
    }
};
