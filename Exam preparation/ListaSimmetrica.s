.section .rodata
fmt_scan:             .asciz "%d"
fmt_prompt_n:         .asciz "Inserire il numero di elementi (<= 10): "
fmt_prompt_elemento:  .asciz "Inserire l'elemento: "
fmt_si:               .asciz "SI\n"
fmt_no:               .asciz "NO\n"

.align 2

.bss
    array:      .skip (4*10)
    subarray1:  .skip (4*5)
    subarray2:  .skip (4*5)
    n:          .skip 4
    elemento:   .skip 4

.macro scansiona fmt, var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    adr x1, \var
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
Scrivere un programma  che,  letto  da  input un intero  positivo  N <= 10  
ed una lista  di  N  interi,verifichi se la lista è composta 
da due metà uguali.Se tale proprietà è verificata si stampi SI, altrimenti 
si stampi NO.
NB: si assuma che N sia pari, in caso di N dispari sistampi NO. 
*/

main:
    stp x29, x30, [sp, #-16]!

    scansiona fmt_prompt_n, n       //Prende in input il numero di elementi dell'array

    ldr w19, n
    tbnz w19, #0, stampa_no         //Controlla se n è pari, altrimenti salta a stampa no
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

    mov w0, #2
    udiv w27, w19, w0               //Carico in w27 la metà di n
    adr x20, array                  //Carica in x20 l'indirizzo dell'array
    adr x21, subarray1              //Carica in x21 l'indirizzo del subarray1
    adr x22, subarray2              //Carica in x22 l'indirizzo del subarray2
    
    mov w23, #0                     //Contatore loop
    dividi_array:
        cmp w23, w19
        bge fine_dividi_array
        ldr w0, [x20], #4
        cmp w23, w27
        blt invia_subarray1
        b invia_subarray2

        invia_subarray1:
            str w0, [x21], #4
            b fine_invio

        invia_subarray2:
            str w0, [x22], #4

        fine_invio:
            add w23, w23, #1        //Incremento contatore

        b dividi_array
    fine_dividi_array:

    adr x21, subarray1              //Ri-carica in x21 l'indirizzo del subarray1
    adr x22, subarray2              //Ri-carica in x22 l'indirizzo del subarray2

    mov w23, #0                     //Contatore loop
    //mov w10, #1                     //Usa w10 come booleana, partendo da TRUE
    scansione_array:
        cmp w23, w27                //Confronta w23 (contatore) e w27 (n/2)
        bge fine_scansione_array

        ldr w0, [x21], #4
        ldr w1, [x22], #4

        cmp w0, w1
        bne stampa_no

        add w23, w23, #1
        b scansione_array
    fine_scansione_array:

    stampa_si:
        print_risultato fmt_si
        b exit

    stampa_no: 
        print_risultato fmt_no
        b exit

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
