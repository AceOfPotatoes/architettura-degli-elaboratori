.section .rodata
fmt_scan:           .asciz "%d"
fmt_prompt:         .asciz "Inserire un numero (termina con 0): "
fmt_si:             .asciz "SI\n"
fmt_no:             .asciz "NO\n"

.align 2

.data
    array:      .word 4, 5, 2             //NO
    .equ array_size, (. - array) / 4

    //array:      .word 3, 4, 6, 9, 7, 2      //SI
    //.equ array_size, (. - array) / 4
    
    //array:      .word 3, 5, 15, 9, 7, 2     //SI
    //.equ array_size, (. - array) / 4
    
    //array:      .word 5
    //.equ array_size, (. - array) / 4

.bss
    nPrec: .skip 4

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
Scrivere un  programma che, letta da input una sequenza di numeri interi positivi terminata dal tappo 0 (ZERO) 
verifichi se nella sequenza sono presenti due numeri consecutivi M e N che soddisfano la seguente proprietà:  
M e N sono entrambi pari, oppure la loro somma è multiplo di uno dei due numeri 
(cioè se  M+N è multiplo di M o di N).  
Nel caso in cui la sequenza contenga due numeri consecutivi che soddisfano tale proprietà, 
il programma deve stampare SI; in caso contrario il programma deve stampare NO. 
*/

main:
    stp x29, x30, [sp, #-16]!

    mov w20, array_size         //Carica in w20 la lunghezza dell'array
    
    cmp w20, #2
    blt stampa_no

    adr x21, array              //Carica in w21 l'indirizzo dell'array

    ldr w25, [x21], #4           //Carica in w25 il primo elemento dell'array
    ldr w26, [x21], #4           //Carica in w26 il secondo elemento dell'array  
    bl verifica_condizioni
    cmp w27, #1
    beq stampa_si

    adr x0, nPrec
    str w26, [x0]           

    mov w19, #2         //Contatore 
    loop_scansione:
        cmp w19, array_size
        bge endloop_scansione

        adr x0, nPrec
        ldr w25, [x0]           //Carica in w25 la variabile nPrec
        ldr w26, [x21], #4      //Carica in w26 il secondo elemento dell'array  
        
        bl verifica_condizioni
        
        cmp w27, #1
        beq stampa_si

        adr x0, nPrec
        str w26, [x0]
        add w19, w19, #1

        b loop_scansione
    endloop_scansione:

        
    stampa_no:
        print_risultato fmt_no
        b exit

    stampa_si:
        print_risultato fmt_si
        b exit

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
    mov w27, #1     //Dà per scontato che la condizione sia verificata, eventualmente cambia

    //Controllo parità di M ed N
    tbnz w25, #0, non_pari        //M
    tbz w26, #0, fine_verifica    //N


    non_pari:
        //Controllo somma multiplo di uno dei due
        add w0, w25, w26            //M+N

        //Controllo (M+N) % M == 0
        udiv w1, w0, w25
        msub w2, w1, w25, w0

        cmp w2, #0         
        beq fine_verifica

        //Controllo (M+N) % N == 0
        udiv w1, w0, w26
        msub w2, w1, w26, w0

        cmp w2, #0         
        beq fine_verifica

    non_verificata:
        mov w27, #0
        b fine_verifica

    fine_verifica:

    ldp x29, x30, [sp], #16
    ret
.size verifica_condizioni, (. - verifica_condizioni)
