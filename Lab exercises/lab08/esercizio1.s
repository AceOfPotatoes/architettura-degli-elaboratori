.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!

    mov w19, #0
    mov w20, #1
    mov x21, #2
    mov x22, #3
    add w24, w20, w20, lsl #2
    add w23, w20, w21, lsr #2
    ror w19, w21, #29
    madd w24, w21, w19, w24
    cmp w19, w24
    csel w22, w23, w19, ge
    msub w24, w21, w19, w24
    udiv w20, w24, w22
    cmp w20, w24
    cinc w23, w19, lt
    add w24, w20, w20, lsl #3
    ror w19, w21, #29
    msub w24, w21, w20, w24
    add w24, w23, w22, lsr #1
    add w19, w24, w22, lsr #1
 
    mov w0, #0
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
