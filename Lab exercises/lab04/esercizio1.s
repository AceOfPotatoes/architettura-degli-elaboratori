.section .rodata
fmt: .asciz "%d\n"

.macro print_x20
    adr x0, fmt
    mov x1, x20
    bl printf
.endm

.macro print_x21
    adr x0, fmt
    mov x1, x21
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    stp x20, x21, [sp, #-16]!

    mov x20, #2
    print_x20

    lsr x21, x20, #1
    print_x20
    print_x21

    sub x20, x20, x21
    print_x20
    print_x21

    add x20, x20, x21, lsl #2
    print_x20
    print_x21 

    mov w0, #0
    ldp x20, x21, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
