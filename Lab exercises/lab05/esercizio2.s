.section .rodata
fmt: .asciz "%d\n" //fomattazione per stampare numeri a 32 bit

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    stp x20, x21, [sp, #-16]!

    mov w20, #20
    mov w21, #9
    
    cmp w20, w21  
    csel w1, w20, w21, lt
    adr x0, fmt
    bl printf
    
    sub w20, w20, w21
    cmp w20, w21
    cset w1, eq
    adr x0, fmt
    bl printf


    mov w0, #0
    ldp x20, x21, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)

