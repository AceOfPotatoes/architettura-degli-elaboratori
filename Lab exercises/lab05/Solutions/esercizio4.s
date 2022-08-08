.section .rodata
fmt: .asciz "%Minimo: %d Massimo:%d Somma: %d Media: %d\n"
.align 2

.data
A: .word 13, 4, 5, 4, 1, 0, -3, 10
.equ A_size, (. - A) / 4

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    ldr x0, =A    
    ldp w4, w5, [x0], #8
    cmp w4, w5
    csel w1, w4, w5, lt
    csel w2, w4, w5, gt
    add w3, w4, w5    
    
    ldp w4, w5, [x0], #8
    cmp w1, w4
    csel w1, w1, w4, lt
    cmp w2, w4
    csel w2, w2, w4, gt
    cmp w1, w5
    csel w1, w1, w5, lt
    cmp w2, w5
    csel w2, w2, w5, gt
    add w3, w3, w4
    add w3, w3, w5
    
    ldp w4, w5, [x0], #8
    cmp w1, w4
    csel w1, w1, w4, lt
    cmp w2, w4
    csel w2, w2, w4, gt
    cmp w1, w5
    csel w1, w1, w5, lt
    cmp w2, w5
    csel w2, w2, w5, gt
    add w3, w3, w4
    add w3, w3, w5

    ldp w4, w5, [x0], #8
    cmp w1, w4
    csel w1, w1, w4, lt
    cmp w2, w4
    csel w2, w2, w4, gt
    cmp w1, w5
    csel w1, w1, w5, lt
    cmp w2, w5
    csel w2, w2, w5, gt
    add w3, w3, w4
    add w3, w3, w5

    ldr w5, =A_size
    udiv w4, w3, w5

    // A questo punto: w1 contiene il minimo, w2 il massimo, w3 la somma e w4 la media
    // la funzione printf stamperà nell'ordine questi 4 valori interi contenuti in questi primi 4 registri
    // come specificato dalla format string fmt
    adr x0, fmt
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    