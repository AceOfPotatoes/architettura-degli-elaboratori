.section .rodata
fmt: .asciz "%d\n"
.align 2

.data
A: .word 0, 1, 2, 3

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
    ldr x0, =A
    ldr w1, [x0]
    ldr w2, [x0, #4]!
    eor w1, w1, w2
    ldr w2, [x0, #4]!
    eor w1, w1, w2
    ldr w2, [x0, #4]!
    eor w1, w1, w2
    ldr x0, =A
    str w1, [x0]
    

    print 0
    print 1
    print 2
    print 3

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    