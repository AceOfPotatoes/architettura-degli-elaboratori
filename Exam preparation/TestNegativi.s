.section .rodata
fmt_prompt:     .asciz "Inserisci N: "
fmt_n:          .asciz "%\n"
fmt_scan:       .asciz "%d"

.align 2

.data
    n: .byte -46, 255, 15, -1

.macro scansiona fmt, n 
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    adr x1, \n
    bl scanf
.endm

.text
.type main, %function
.global main
/*
Vediamo come si comporta un numero negativo trattato come positivo
*/

main:
    stp x29, x30, [sp, #-16]!

    scansiona fmt_prompt, n
    adr x0, fmt_n
    ldr w1, n
    bl printf

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)

