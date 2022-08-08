.section .rodata
fmt_scan:           .asciz "%d"
fmt_prompt_A:       .asciz "A[%d]: "
fmt_prompt_B:       .asciz "B[%d]: "
fmt_somma:          .asciz "Somma dei due array: %d\n"
.align 2

.bss
    x:                      .skip(4*5)
    y:                      .skip(4*5)
    elemento:               .skip 4
    somma:                  .skip 4
    

.macro scansiona fmt, pos, var
    adr x0, \fmt
    mov w1, \pos
    bl printf

    adr x0, fmt_scan
    ldr w1, =\var
    bl scanf
.endm

.macro print_num num
    adr x0, fmt_somma
    ldr x1, \num
    bl printf
.endm

.text
.type main, %function
.global main

/*
Un programma che legga da input due array di interi, come variabili automatiche con
dimensione fissata a 5 e stampi la somma ottenuta sommando tutti gli interi contenuti
nei due array.
*/

main:
    stp x29, x30, [sp, #-16]!

    mov w19, #0             //registro usato come contatore elementi array
    ldr x25, =x             //Carico indirizzo della lista1
    ldr x26, =y             //Carico indirizzo della lista2      

    loop1:
        scansiona fmt_prompt_A, w19, elemento
        ldr w0, elemento
        str w0, [x25], #4
        add w19, w19, #1
        cmp w19, #5
        beq endloop1
        b loop1
    endloop1:  

    mov w19, #0             //registro usato come contatore elementi array

    loop2:
        scansiona fmt_prompt_B, w19, elemento
        ldr w0, elemento
        str w0, [x26], #4
        add w19, w19, #1
        cmp w19, #5
        beq endloop2
        b loop2       
    endloop2:  

    mov w19, #0             //registro usato come contatore elementi array
    ldr x25, =x             //Carico indirizzo della lista1
    ldr x26, =y             //Carico indirizzo della lista2 
    mov w24, #0             //registro usato come accumulatore (somma)
    calcolo_somma:
        ldr w0, [x25], #4
        ldr w1, [x26], #4
        add w24, w24, w0
        add w24, w24, w1
        add w19, w19, #1
        cmp w19, #5
        blt calcolo_somma
    
    ldr x0, =somma
    str w24, [x0]
    print_num somma

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
