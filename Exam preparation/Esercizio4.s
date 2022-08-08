.section .rodata
fmt_prompt:      .asciz "Inserisci il numero: "
fmt_f_di_n:         .asciz "<OUTPUT>%llu</OUTPUT>\n"

.align 3

.data
    n_meno_1: .quad 1
    n_meno_2: .quad 0
    n: .quad 0

.macro print num
    adr x0, fmt_f_di_n
    ldr x1, \num
    bl printf
.endm

.text
.type main, %function
.global main
/*
t(0) = 10
t(1) = 7
t(n) = 3*t(n-1) + t(n-2)/4, se n >= 2

Usare interi a 64 bit per tutte le operazioni (quindi divisione intera). 
Per stampare il risultato usare la format string "<OUTPUT>%llu</OUTPUT>\n", 
ovvero intero a 64 bit senza segno (nel tag <OUTPUT>).
 */

main:
    stp x29, x30, [sp, #-16]!

    mov x19, #2          //contatore stampe
    print n_meno_2
    print n_meno_1
    loop:
        ldr x20, n_meno_2
        ldr x21, n_meno_1
        mov x4, #2
        mul x5, x21, x4
        udiv x6, x20, x4
        sub x22, x5, x6
        ldr x2, =n
        str x22, [x2]
        print n
        ldr x1, =n_meno_2
        str x21, [x1]
        ldr x1, =n_meno_1
        str x22, [x1]
        add x19, x19, #1
        cmp x19, #50
        beq endloop 
        b loop
    endloop:

    
exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
