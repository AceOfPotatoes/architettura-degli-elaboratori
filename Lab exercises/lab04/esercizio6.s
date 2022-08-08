.section .rodata
fmt: .asciz "%d\n"
.align 2

.data
A: .word 1, 5, -3, 2
B: .word -4, 5, 34, 6

.macro print i
    adr x0, fmt
    ldr x2, =A
    ldr w1, [x2, #\i * 4]
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
    