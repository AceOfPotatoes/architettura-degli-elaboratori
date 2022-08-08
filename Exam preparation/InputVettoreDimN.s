.section .rodata
fmt_scan:             .asciz "%d"
fmt_elemento:         .asciz "array[%d]: %d\n"
fmt_prompt_n:  .asciz "Inserire dimensione array (<=50): "
fmt_prompt_elemento:  .asciz "Inserire elemento: "

.align 2

.bss
    array:      .skip (4*50)
    n:          .skip 4
    elemento:   .skip 4

.macro scansiona fmt, var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    adr x1, \var
    bl scanf
.endm

.macro print_n fmt, pos, n 
    adr x0, \fmt
    mov w1, \pos
    mov w2, \n 
    bl printf
.endm

.text
.type main, %function
.global main

/*
Il seguente template permette di effettuare scansione e stampa di un array di 
dimensione data tramite input, salvata in n (.bss)
*/

main:
    stp x29, x30, [sp, #-16]!

    scansiona fmt_prompt_n, n       //Prende in input il numero di elementi dell'array

    ldr w19, n
    adr x20, array                  //Carica in x20 l'indirizzo dell'array

    mov w23, #0                     //Contatore loop
    input_array:
        cmp w23, w19
        bge fine_input_array

        scansiona fmt_prompt_elemento, elemento
        ldr w1, elemento
        str w1, [x20], #4

        add w23, w23,  #1
        b input_array
    fine_input_array:

    adr x20, array                  //Carica in x20 l'indirizzo dell'array
    mov w23, #0                     //Contatore loop
    scansione_array:
        cmp w23, w19                //Confronta w23 (contatore) e w19 (n)
        bge fine_scansione_array

        ldr w27, [x20], #4

        print_n fmt_elemento, w23, w27 

        add w23, w23, #1
        b scansione_array
    fine_scansione_array:


exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)

.type verifica_condizioni, %function 
//La funzione riceve M ed N come parametri tramite i registri w25 e w26
//Sfrutta w27 come ritorno simil variabile booleana
verifica_condizioni:
    stp x29, x30, [sp, #-16]!
    
    ldp x29, x30, [sp], #16
    ret
.size verifica_condizioni, (. - verifica_condizioni)
