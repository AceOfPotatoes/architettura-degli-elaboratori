.section .rodata
fmt: .asciz "diff = %d\n"
.align 2

.macro invoca_diff a b
    mov x0, \a
    mov x1, \b
    bl diff

    mov x1, x0
    adr x0, fmt
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    invoca_diff #10, #20
    invoca_diff #3, #2
    invoca_diff #10, #2

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)

.type diff, %function
diff:
    // Implementare di seguito la funzione diff 
    
    ret
    .size diff, (. - diff)
