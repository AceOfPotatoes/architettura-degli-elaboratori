.section .rodata
fmt: .asciz "%d\n"
fmt_pstate: .asciz "N = %d\tZ = %d\tC = %d\tV = %d\n"

.macro print
    adr x0, fmt_pstate
    cset w1, mi
    cset w2, eq
    cset w3, cs
    cset w4, vs
    bl printf
.endm

.macro print_x20
    adr x0, fmt
    mov x1, x20
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    str x20, [sp, #-8]!

    mov x0, #0b01001011
    mov x1, #0b00001111
    // punto a)
    //adds x20, x1, x0
    // punto b) 
    subs x20, x1, x0
    print
    print_x20

    mov w0, #0
    ldr x20, [sp], #8
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
