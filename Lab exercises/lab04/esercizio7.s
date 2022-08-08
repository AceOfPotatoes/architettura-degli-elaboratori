.section .rodata
fmt: .asciz "%d\n"

.data
A: .byte 0b00100011, 0b00011011, 0b00000001, 0b11111111
B: .byte 0b00101011, 0b10010011, 0b00010000, 0b10000001

.macro print i
    adr x0, fmt
    ldr x2, =A
    ldrsb w1, [x2, #\i * 1]
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    //Da completare

    print 0
    print 1
    print 2
    print 3

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    