.section .rodata
fmt_prompt:     .asciz "Inserisci N: "
fmt_f_di_n:     .asciz "f(n): %ld\n"
fmt_scan:       .asciz "%d"
.align 3

.data
    n: .quad 0

.macro scansiona fmt, n 
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    adr x1, \n
    bl scanf
.endm

.macro print num
    adr x0, fmt_f_di_n
    ldr x1, \num
    bl printf
.endm

.text
.type main, %function
.global main
/*
Scrivere un programma che, letto da input un intero positivo N, 
stampi l’N-esimo  numerodella successione così definita: 
f(N) = 2 se N = 0
f(N)= 3 * (N + 1) * f(N - 1) se N>0
Si utilizzi unafunzione ricorsivaper calcolare la successione.
*/

main:
    stp x29, x30, [sp, #-16]!

    scansiona fmt_prompt, n
    adr x0, n 
    ldr x20, [x0]           //Carico n in x20

    bl calcolo_ricorsivo

    adr x0, fmt_f_di_n
    mov x1, x19
    bl printf

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)

.type calcolo_ricorsivo, %function
calcolo_ricorsivo:
    stp x29, x30, [sp, #-16]!
    mov x25, #3         //Carica in x25 il 3 da usare nella moltiplicazione
    cmp x20, #0
    bgt caso_ricorsivo

    caso_base:          //Se N == 0
        mov x19, #2
        mov x20, #1
        b fine_ricorsione

    caso_ricorsivo:     //Se N > 0 allora 3 * (N + 1) * f(N - 1)
        sub x20, x20, #1
        bl calcolo_ricorsivo
        add x20, x20, #1            //Inserisce in x20 (N+1)
        mul x23, x25, x20
        mul x19, x23, x19 
    
    fine_ricorsione:
        ldp x29, x30, [sp], #16
        ret
.size calcolo_ricorsivo, (. - calcolo_ricorsivo)
