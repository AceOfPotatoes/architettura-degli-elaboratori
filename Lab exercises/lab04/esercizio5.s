.section .rodata
fmt: .asciz "%d\n"
fmt_num: .asciz "Inserisci numero: "
fmt_scan: .asciz "%d"
.align 2

.data
A: .word 7, 0, 3, 1

.bss
x: .word 0
y: .word 0

.macro print i
    adr x0, fmt
    ldr x2, =A
    ldr w1, [x2, #\i * 4]
    bl printf
.endm

.macro scan fmt var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
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
    