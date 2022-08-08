.section .rodata
fmt_scan:           .asciz "%d"
fmt_prompt_A:       .asciz "A[%d]: "
fmt_somma:          .asciz "Somma degli elementi dell'array: %d\n"
.align 2

.bss
    x:                      .skip(4*5)
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

    loop_input:
        scansiona fmt_prompt_A, w19, elemento
        ldr w0, elemento
        str w0, [sp, #-4]!
        add w19, w19, #1
        cmp w19, #5
        beq endloop_input
        b loop_input
    endloop_input:  

    mov w19, #0             //registro usato come contatore elementi array
    
    loop_scansione:
        cmp w19, #5
        bge endloop_scansione
        ldr w1, [sp], #4
        ldr w0, somma
        add w0, w0, w1
        adr x5, somma
        str w0, [x5]
        add w19, w19, #1
        b loop_scansione
    endloop_scansione:
    
    print_num somma

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
