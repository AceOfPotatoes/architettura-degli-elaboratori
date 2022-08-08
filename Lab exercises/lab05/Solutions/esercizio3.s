.section .rodata
fmt_saldo: .asciz "SALDO: %d\n"
.align 2

.data
saldo: .word 500
canone: .word 5
interesse: .word 2

.macro print
    adr x0, fmt_saldo
    ldr w1, saldo
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    print
    
    ldr w0, saldo
    ldr w1, canone
    ldr w2, interesse
    mov w3, #100

    sub w4, w0, w1
    mul w5, w0, w2
    udiv w5, w5, w3
    add w5, w5, w4
    ldr x4, =saldo
    str w5, [x4]
    print

    // La funzione printf invocata tramite la macro print può aver 
    // modificato il contenuto dei registri x0-x8, quindi   
    // dobbiamo ripristinare i dati che ci servono nei registri
    ldr w0, saldo
    ldr w1, canone
    ldr w2, interesse
    mov w3, #100
    sub w4, w0, w1
    mul w5, w0, w2
    udiv w5, w5, w3
    add w5, w5, w4
    ldr x4, =saldo
    str w5, [x4]
    print

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    