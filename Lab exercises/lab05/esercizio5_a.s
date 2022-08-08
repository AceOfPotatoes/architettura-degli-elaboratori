.section .rodata
fmt_n: .asciz "Insert a non-negative number (negative to terminate): "
fmt_scan: .asciz "%d"
fmt_count: .asciz "The count is: %d.\n"
.align 2

.bss
n: .word 0 //da utilizzare per memorizzare di volta in volta il numero letto

.macro scan fmt var //da utilizzare per leggere un numero
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
    
    //da completare

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
