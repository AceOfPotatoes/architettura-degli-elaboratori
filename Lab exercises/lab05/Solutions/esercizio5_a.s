.section .rodata
fmt_n: .asciz "Insert a non-negative number (negative to terminate): "
fmt_scan: .asciz "%d"
fmt_count: .asciz "The count is: %d.\n"
.align 2

.bss
n: .word 0

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
    stp x19, x20, [sp, #-16]! // Nella prossima lezione vedremo a cosa serve questa istruzione
    
    mov w19, #0
    mov w20, #2
    
    loop:
        scan fmt_n, n

        ldr w0, n
        cmp w0, #0
        blt endloop

        udiv w1, w0, w20
        msub w2, w1, w20, w0

        cmp w2, #0
        cinc w19, w19, eq

        b loop
    endloop:

    adr x0, fmt_count
    mov w1, w19
    bl printf

    mov w0, #0
    ldp x19, x20, [sp], #16 // Nella prossima lezione vedremo a cosa serve questa istruzione
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
