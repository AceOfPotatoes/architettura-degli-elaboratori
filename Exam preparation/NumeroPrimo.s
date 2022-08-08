.section .rodata
fmt_prompt:         .asciz "Inserire un numero intero positivo: "
fmt_scan:           .asciz "%d"
fmt_si:             .asciz "SI\n"
fmt_no:             .asciz "NO\n"

.bss
    n:   .skip 4

.macro scansiona fmt, var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm

.macro print_risultato fmt
    adr x0, \fmt
    bl printf
.endm

.text
.type main, %function
.global main

/*
Dato in input un numero N intero positivo, stampare SI se esso è un numero negativo
stampare NO altrimenti
*/

main:
    stp x29, x30, [sp, #-16]!
    mov w19, #2    //Contatore da utilizzare per la divisione
    scansiona fmt_prompt, n 
    ldr w0, n 
    cmp w0, #1
    beq stampa_no
    cmp w0, #2
    beq stampa_si

    lsr w5, w0, #1
    loop:  
        udiv w22, w0, w19
        msub w23, w22, w19, w0 
        cmp w23, #0
        beq stampa_no
        add w19, w19, #1
        cmp w19, w5
        blt loop

    stampa_si:
        print_risultato fmt_si
        b exit

    stampa_no:
        print_risultato fmt_no

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
