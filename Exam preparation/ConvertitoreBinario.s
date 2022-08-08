.section .rodata
    fmt_prompt:         .asciz "Inserire un numero reale: "
    fmt_scan_float:     .asciz "%lf"
    fmt_vuoto:          .asciz "VUOTO\n"

    // Formattazione per stampare ogni valore uno per volta (la funzione printf lo recuperera' dal registro d0)
    fmt_convertito: .asciz "Numero convertito in hex, con segno: %A\n"

.align 3

.bss
    n: .skip 8

.data
    zero_float: .double 0.0

.macro stampa_float fmt, n
    adr x0, \fmt
    ldr d0, \n
    bl printf
.endm

.macro stampa_vuoto
    adr x0, fmt_vuoto
    bl printf
.endm

.macro scansiona_float fmt, n
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan_float
    adr x1, \n
    bl scanf 
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    
    scansiona_float fmt_prompt, n

    adr x0, fmt_convertito
    ldr d0, n
    bl printf

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    