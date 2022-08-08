.section .rodata
fmt:
    .asciz "Negative = %d\tZero = %d\tCarry = %d\toVerflow = %d\tn = %d\n"

.data
n:
    .hword 200

.macro print
    adr x0, fmt
    cset w1, mi
    cset w2, eq
    cset w3, cs
    cset w4, vs
    ldr w5, n
    bl printf
.endm

.macro add_to_n value
    adr x8, n
    ldrh w9, [x8]
    .if \value >= 0
        adds w9, w9, #\value
    .else
        subs w9, w9, #-\value
    .endif
    strb w9, [x8]
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    add_to_n 56
    print

    // return 0
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
