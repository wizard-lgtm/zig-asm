const std = @import("std");

fn asm_example() usize {
    var result: usize = 0;
    const param: usize = 15;
    asm volatile (
        \\mv t0, %[param]
        \\addi a0, t0, 5
        : [result] "=r" (result),
        : [param] "r" (param),
    );
    return result;
}

fn sys_write() usize {
    var msg = "Hello world\n"; // Yazılacak mesaj
    var len = msg.len; // Mesajın uzunluğu
    var fd: usize = 0x01; // stdout (file descriptor)
    var syscall_number: usize = 63; // write sistem çağrısı numarası
    const ret: usize = 0;

    asm volatile (
        \\mv a0, %[fd]        // a0 = fd (stdout)
        \\mv a1, %[msg]       // a1 = msg (yazılacak mesajın adresi)
        \\mv a2, %[len]       // a2 = len (mesajın uzunluğu)
        \\mv a7, %[syscall_number] // a7 = sistem çağrısı numarası (write = 63)
        \\ecall               // ecll: sistem çağrısını gerçekleştir
        // Sistem çağrısının dönüş değeri
        : [fd] "r" (fd), // file descriptor (input)
          [msg] "r" (msg), // mesajın bellekteki adresi (input)
          [len] "r" (len), // mesajın uzunluğu (input)
          [syscall_number] "r" (syscall_number), // sistem çağrısı numarası (input)

    );

    return ret;
}

pub fn main() !void {
    const a2: usize = sys_write();
    std.debug.print("{d}\n", .{a2});
}
