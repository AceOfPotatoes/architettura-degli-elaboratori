.section .rodata
fmt: 
    .asciz "%d\n"

.equ CONSTANT, 1
.equ CONSTANT2, 0

.macro print n
    adr x0, fmt
    mov w1, \n
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    .ifndef CONSTANT   
        print 0
    .else
        .ifndef CONSTANT2
            print 0
        .else
            print 1
        .endif
    .endif

    // return 0
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
