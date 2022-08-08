.section .rodata
fmt: .asciz "%d\n"
fmt_saldo: .asciz "SALDO: %d\n"
.align 2

.data
saldo: .word 500
canone: .word 5
interesse: .word 2

.macro print 
    adr x0, fmt_saldo
    ldr x1, saldo
    bl printf
.endm

.macro print_reg n
    adr x0, fmt
    mov w1, \n
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    

    primo_mese:
    print

  
    secondo_mese:
    ldr w0, saldo
    ldr w1, canone
    ldr w2, interesse
    mov w3, #100

    sub w0, w0, w1      //W0 = Saldo - Canone
    mul w5, w0, w2      //W5 = (Saldo - Canone)*Interesse
    udiv w5, w5, w3     //W5 = W5//100 = <Interesse sul saldo decimale>
    add w0, w0, w5
    ldr x7, =saldo
    str w0, [x7]
    print
    

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    