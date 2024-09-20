const std = @import("std");

fn asm_example() usize {
    var result: usize = 0;
    const param: usize = 15;
    asm volatile ("addi %[result], %[param], 5"
        : [result] "=r" (result),
        : [param] "r" (param),
    );
    return result;
}

fn asm_sum(x: usize, y: usize) usize {
    var result: usize = 0;
    asm volatile ("add %[t0], %[x], %[y]"
        : [t0] "=r" (result),
        : [x] "r" (x),
          [y] "r" (y),
    );
    return result;
}

fn sys_write() usize {
    const msg = "Hello world\n"; //
    const len = msg.len; //
    const fd: usize = 0x01; // stdout (file descriptor)
    const syscall_number: usize = 64; // write

    return asm volatile ("ecall" // ecll: sistem çağrısını gerçekleştir
        // Sistem çağrısının dönüş değeri
        : [ret] "={a0}" (-> usize),
        : [fd] "{a0}" (fd), // file descriptor (input)
          [msg] "{a1}" (@intFromPtr(msg)),
          [len] "{a2}" (len),
          [syscall_number] "{a7}" (syscall_number),
        : "a0", "a1", "a2", "a7"
    );
}

pub fn main() !void {
    const a2: usize = sys_write();
    const sum: usize = asm_sum(3, 4); // 7
    const example: usize = asm_example();
    std.debug.print("{d}\n", .{example});
    std.debug.print("{d}\n", .{sum});
    std.debug.print("{d}\n", .{a2});
}
