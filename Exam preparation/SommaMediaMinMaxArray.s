.section .rodata
// Per stampare i dati ottenuti potete utilizzare a vostra scelta, 
// delle singole format string oppure una format string complessiva come specificato di seguito

// Formattazione per stampare ogni valore uno per volta (la funzione printf lo recuperera' dal registro 1)
fmt_min: .asciz "%Minimo: %d\n"
fmt_max: .asciz "Massimo:%d\n"
fmt_somma: .asciz "Somma: %d\n"
fmt_media: .asciz "Media: %d\n"
// Formattazione per stampare tutti i valori insieme (la funzione printf li recuperera' nell'ordine dai registri 1, 2, 3 e 4)
fmt: .asciz "%Minimo: %d Massimo:%d Somma: %d Media: %d\n"
.align 2

.data
A: .word 13, 4, 5, 4, 1, 0, -3, 10
.equ A_size, (. - A) / 4

.macro print_reg n
    adr x0, aaa
    mov x1, \n
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    mov w3, #0

    ldr x0, =A              //x0 -> Indirizzo del primo elemento dell'array
    ldp w4, w5, [x0], #8    //w4 = 13, w5 = 4
    cmp w4, w5
    csel w1, w4, w5, lt     //Se w4 < w5 -> w1 = w4 altrimenti w1 = w5
    csel w2, w4, w5, gt     //Se w4 > w5 -> w1 = w4 altrimenti w1 = w5
    add w3, w4, w5

    ldp w4, w5, [x0], #8
    cmp w1, w4
    csel w1, w1, w4, lt     //Se w1 < w4 -> w1 = w1 altrimenti w1 = w4
    cmp w2, w4
    csel w2, w2, w4, gt     //Se w1 > w4 -> w1 = w1 altrimenti w1 = w4
    cmp w1, w5
    csel w1, w1, w5, lt
    cmp w2, w5
    csel w2, w2, w5, gt
    add w3, w3, w4
    add w3, w3, w5

    ldp w4, w5, [x0], #8
    cmp w1, w4
    csel w1, w1, w4, lt     //Se w1 < w4 -> w1 = w1 altrimenti w1 = w4
    cmp w2, w4
    csel w2, w2, w4, gt     //Se w1 > w4 -> w1 = w1 altrimenti w1 = w4
    cmp w1, w5
    csel w1, w1, w5, lt
    cmp w2, w5
    csel w2, w2, w5, gt
    add w3, w3, w4
    add w3, w3, w5
    
    ldp w4, w5, [x0], #8
    cmp w1, w4
    csel w1, w1, w4, lt     //Se w1 < w4 -> w1 = w1 altrimenti w1 = w4
    cmp w2, w4
    csel w2, w2, w4, gt     //Se w1 > w4 -> w1 = w1 altrimenti w1 = w4
    cmp w1, w5
    csel w1, w1, w5, lt
    cmp w2, w5
    csel w2, w2, w5, gt
    add w3, w3, w4
    add w3, w3, w5

    ldr w10, =A_size
    
    udiv w4, w3, w10


    adr x0, fmt
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    