/* TEORIA */
/* le variabili;
le *variabili locali* possono essere memorizzate nello stack o in un segmento di dati a seconda che siano auto o statiche. (se non viene specificata né l’auto né la statica, viene assunto automaticamente)

le *variabili globali* sono memorizzate in un segmento di dati (a meno che il compilatore non possa ottimizzarle, vedere const) e avere visibilità dal punto di dichiarazione fino alla fine dell’unità di compilazione.

le *variabili statiche* sono memorizzate in un segmento di dati (di nuovo, a meno che il compilatore non possa ottimizzarle) e abbiano visibilità dal punto di dichiarazione fino alla fine dello scope che racchiude. Le variabili globali che non sono statiche sono anche visibili in altre unità di compilazione (vedi extern).

le *variabili automatiche* sono sempre locali e vengono memorizzate nello stack.

il *modificatore del registro* dice al compilatore di fare del suo meglio per mantenere la variabile in un registro, se ansible. Altrimenti viene memorizzato nello stack.

le *variabili esterne* sono memorizzate nel segmento dati. Il modificatore extern indica al compilatore che una diversa unità di compilazione sta effettivamente dichiarando la variabile, quindi non creare un’altra istanza o una collisione di nomi al momento del collegamento.

le *variabili const* possono essere memorizzate nello stack o in un segmento di dati di sola lettura a seconda che siano auto o statici. Tuttavia, se il compilatore può determinare che non possono essere referenziati da una diversa unità di compilazione, o che il codice non sta usando l’indirizzo della variabile const, è libero di ottimizzarlo (ogni riferimento può essere sostituito dal valore costante) . In tal caso non è memorizzato da nessuna parte.

il *modificatore volatile* dice al compilatore che il valore di una variabile può cambiare in qualsiasi momento da influenze esterne (di solito hardware), quindi non dovrebbe cercare di ottimizzare via qualsiasi ricarica dalla memoria in un registro quando si fa riferimento a tale variabile. Ciò implica archiviazione statica.
*/





/* ESEGUE DEI CALCOLI E STAMPA X0 E X1 (DOPO AVERLI SALVATI IN X19 E X20) */
.section .rodata
fmt_print: .asciz "-> %d\n"


.macro print n
    adr x0, fmt_print
    mov x1, \n
    bl printf
.endm


.text
.type main, %function
.global main
main:
    stp x19, x30, [sp, #-16]!

    // esegui operazioni qui ..


    // stampo x0 e x1
    mov x19, x0
    mov x20, x1

    print x19
    print x20

return:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)





/*      TIPI DI TRIANGOLI
- NO se A, B e C non rappresentano i lati di un triangolo


- TRIANGOLO EQUILATERO se tutti i lati sono uguali tra loro (A==B e B==C)

- TRIANGOLO ISOSCELE se soltanto due lati sono uguali tra loro (A==B e B!=C, oppure A==C e B!=C, oppure B==C e A!=B)

- TRIANGOLO SCALENO se tutti i lati sono diversi tra loro (A!=B e B!=C e A!=C).
*/

.section .rodata
    get_value: .asciz   "Inserisci un un lato: "
    fmt_scan: .asciz    "%d"

    non_esiste: .asciz  "NON E' UN TRIANGOLO.\n"
    equilatero: .asciz  "EQUILATERO.\n"
    isoscele: .asciz    "ISOSCELE.\n"
    scaleno: .asciz     "SCALENO.\n"



.bss
    lato_a: .word 0
    lato_b: .word 0
    lato_c: .word 0



// Input
.macro scan fmt var
    adr x0, \fmt 
    bl printf
    
    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm

// Output
.macro stampa_ne  
    adr x0, non_esiste
    bl printf       
.endm  
.macro stampa_equilatero
    adr x0, equilatero  
    bl printf       
.endm  
.macro stampa_isoscele   
    adr x0, isoscele
    bl printf       
.endm
.macro stampa_scaleno   
    adr x0, scaleno
    bl printf       
.endm

.text
.global main



main:
    stp x29, x30, [sp, #-16]!

    // Acquisisco i 3 lati.
    scan get_value, lato_a
    scan get_value, lato_b
    scan get_value, lato_c

    // Li memorizzo nei registri w19, w20 e w21.
    ldr w19, lato_a
    ldr w20, lato_b
    ldr w21, lato_c


    esiste_check:
        // un triangolo esiste se la somma dei lati presi a due a due sono >= dell'altro lato
        mov w1, #0  // contiene la somma dei lati (volatile)

        // b+c >= a
        add w1, w20, w21
        cmp w1, w19
        blt print_none

        // a+c >= b
        add w1, w19, w21
        cmp w1, w20
        blt print_none

        // a+b >= c
        add w1, w19, w20
        cmp w1, w21
        blt print_none

        tipologia:
            equilatero_check:
                eq__cmp_ab:
                    cmp w19, w20
                    bne isoscele_check
                eq__cmp_bc:
                    cmp w20, w21
                    beq print_equilatero
            isoscele_check:
                is__cmp_ab:
                    cmp w19, w20
                    bne is__b_bne_c
                    is__a_beq_b:
                        cmp w20, w21
                        bne print_isoscele
                        b scaleno_check
                    is__b_bne_c:
                        cmp w20, w21
                        beq print_isoscele
                        b scaleno_check
            scaleno_check:
                sc__cmp_ab:
                    cmp w19, w20
                    beq non_esiste
                sc__cmp_bc:
                    cmp w20, w21
                    beq non_esiste
                    b print_scaleno

print_none:
    stampa_ne
    b exit
print_equilatero:
    stampa_equilatero
    b exit
print_isoscele:
    stampa_isoscele
    b exit
print_scaleno:
    stampa_scaleno
    b exit


exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)





// Stampa se un numero è pari o dispari
.section .rodata
fmt_ask:        .asciz "Inserisci un numero: "
fmt_pari:       .asciz "Pari.\n"
fmt_dispari:    .asciz "Dispari.\n"

fmt_print:      .asciz "%d\n"
fmt_scan:       .asciz "%d"


.bss
    value:  .word 0



.macro scan fmt var
    adr x0, \fmt 
    bl printf
    
    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm
.macro print n
    adr x0, fmt_print
    mov x1, \n
    bl printf
.endm

.macro stampa_pari
    adr x0, fmt_pari
    bl printf       
.endm  
.macro stampa_dispari
    adr x0, fmt_dispari
    bl printf       
.endm



.text
.global main

main:
    stp x29, x30, [sp, #-16]!


    scan fmt_ask, value         // acquisisco un valore da tastiera
    ldr x19, value              // lo memorizzo in x19
    print x19                   // lo stampo

    tbz x19, [0], pari_case     // se il bit meno significativo è 0, allora stampa pari
    dispari_case:
        stampa_dispari
        b exit
    pari_case:
        stampa_pari
    
    
exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
 




/* SEQUENZA TERMINATA CON UN VALORE NEGATIVO CHE DETERMINA SE UNA SEQUENZA DI NUMERI È STRETTAMENTE CRESCENTE OPPURE NO */
.section .rodata

// Input
fmt_prompt: .asciz "Inserisci un valore:\n\t->\t"
fmt_scan: .asciz "%d"
.macro scan fmt var
    adr x0, \fmt 
    bl printf
    
    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm

// Output
fmt_si: .asciz "\nLa sequenza è crescente.\n"
.macro stampa_si
    adr x0, fmt_si 
    bl printf       
.endm 

fmt_no: .asciz "\nLa sequenza NON è crescente.\n"
.macro stampa_no   
    adr x0, fmt_no 
    bl printf       
.endm


.bss
value: .word 0


.text
.type main, %function
.global main
main:
    stp x19, x30, [sp, #-16]!

   
    mov x25, #0     // totale numeri inseriti
    mov x26, #0     // 0 = Crescente, 1 = Non Crescente

   // acquisisco un valore e lo carico in x20
    scan fmt_prompt, value
    ldr x20, value
    
   // se num < 0 (il 32esimo bit è 1), allora termino e rest. "No."
    cmp x20, #0
    tbnz x20, [31], return
    add x25, x25, #1

    while_greater_than_zero:
        mov x19, x20            // x19 = old

        scan fmt_prompt, value  // acquisisco il nuovo valore
        ldr x20, value          // x20 = new
        
       // se x20 < 0 (il 32esimo bit è 1), allora termino il ciclo e stampo il risultato
        cmp x20, #0
        tbnz x20, [31], return
        add x25, x25, #1

       // se x20 > x19, allora ricomincia. Altrimenti, setta x26 a 1
        cmp x20, x19
        bgt while_greater_than_zero

        set_boolean_false:
            mov x26, #1
            b while_greater_than_zero

return:
   // Se ci sono almeno 2 numeri ..
    cmp x25, #2
    blt non_crescente

   // .. e la variabile booleana è settata a 0, stampa "Si.", altrimenti "No."
    cmp x26, #0
    beq crescente
        non_crescente:
            stampa_no
            b end
        crescente:
            stampa_si
    end:
        mov w0, #0
        ldp x29, x30, [sp], #16
        ret
        .size main, (. - main)





/* aggiungere le righe di codice per memorizzare la somma del vettore tale che C[i] = A[i] + B[i] */
.section .rodata
fmt: .asciz "%d\n"
.align 2

.data
    n:      .word 1, 2, 3, 4, 5
    m:      .word 1, 2, 3, 4, 5
    sum:    .word 0, 0, 0, 0, 0



.macro print_tmp n
    adr x0, fmt
    mov w1, \n
    bl printf
.endm



.macro print i
    adr x0, fmt
    ldr x2, =sum
    ldr w1, [x2, #\i * 4]
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!


    get_addresses:
        ldr x19, =n         // carica in x1 l'indirizzo di n
        ldr x20, =m         // carica in x1 l'indirizzo di m
        ldr x21, =sum       // carica in x1 l'indirizzo di sum



    metodo1:
    /*** METODO 1 - ciclo while ***/
        mov x22, #0     // offset
        mov x23, #0     // index
        mov x24, #4     // dimensione byte

        while__i_lt_five:
            cmp x23, #5     // se il contatore è maggiore o uguale a 5 ..
            beq end_while   // .. il ciclo si interrompe

                mul x22, x23, x24   // calcola l'offset della cella di memoria

                ldr w1, [x19, x22]  // mette in w1, n[x22]
                ldr w2, [x20, x22]  // mette in w1, m[x22]

                add w0, w1, w2      // w0 = n[x22] + m[x22]
                
                str w0, [x21, x22]  // mette w0 nell'indirizzo contenuto in x21, dopo x22 byte

            add x23, x23, #1        // incrementa il contatore
            b while__i_lt_five      // ricomincia il ciclo while
        end_while:


    
    metodo2:
    /*** METODO 2 - a macchinetta ***/
       // sum[0] = n[0] + m[0]
        ldr w1, [x19]       // mette in w1, n[i]
        ldr w2, [x20]       // mette in w1, m[i]
        add w0, w1, w2      // w0 = n[1] + m[2]
        str w0, [x21, #4]   // mette nell'indirizzo contenuto in x21, shiftato di # posti, w0

       // sum[1] = n[1] + m[1]
        ldr w1, [x19, #4]   // mette in w1, n[i]
        ldr w2, [x20, #4]   // mette in w1, m[i]
        add w0, w1, w2      // w0 = n[1] + m[2]
        str w0, [x21, #4]   // mette nell'indirizzo contenuto in x21, shiftato di # posti, w0

       // sum[2] = n[2] + m[2]
        ldr w1, [x19, #8]   // mette in w1, n[i]
        ldr w2, [x20, #8]   // mette in w1, m[i]
        add w0, w1, w2      // w0 = n[0] + m[0]
        str w0, [x21, #8]   // mette nell'indirizzo contenuto in x21, shiftato di # posti, w0

       // sum[3] = n[3] + m[3]
        ldr w1, [x19, #12]   // mette in w1, n[i]
        ldr w2, [x20, #12]   // mette in w1, m[i]
        add w0, w1, w2       // w0 = n[0] + m[0]
        str w0, [x21, #12]   // mette nell'indirizzo contenuto in x21, shiftato di # posti, w0

       // sum[4] = n[4] + m[4]
        ldr w1, [x19, #16]   // mette in w1, n[i]
        ldr w2, [x20, #16]   // mette in w1, m[i]
        add w0, w1, w2       // w0 = n[0] + m[0]
        str w0, [x21, #16]   // mette nell'indirizzo contenuto in x21, shiftato di # posti, w0



    print_sum:
        print 0
        print 1
        print 2
        print 3
        print 4

    return:
        mov w0, #0
        ldp x29, x30, [sp], #16
        ret
        .size main, (. - main)





/* FUNZIONE f(n) = 3 * (n+1) * f(n-1) */
.section .rodata

// Input
fmt_prompt: .asciz "Inserisci un valore: "
fmt_scan: .asciz "%d"
.macro scan fmt var
    adr x0, \fmt 
    bl printf
    
    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm

// Output
fmt_print: .asciz "\nRisultato: %d\n"
.macro print n
    adr x0, fmt_print
    mov x1, \n
    bl printf
.endm



.bss
n: .word 0



.text
.type main, %function
.global main
main:
    stp x19, x30, [sp, #-16]!

    mov x19, #1     // risultato totale inziale
    mov x25, #1     // risultato della ricorsione

    scan fmt_prompt, n  // acquisisco n
    ldr x20, n          // metto n in x20 (lo utilizzo per n-1)
    
    bl recursion        // inizio la ricorsione

return:
    print x19
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)



// Function:    f(N) = [3 * (N+1)] * f(N-1)         [ f(0)=2 ]
.type recursion, %function
    recursion:
        stp x29, x30, [sp, #-16]!

       // base case
        compare_n:
            cmp x20, #0         // se n == 0 ..
            beq n_beq_zero      // .. restituisco 2

       // [3 * (N+1)] * ..
        multiply_first_second:
            mov x3, #3          // x3 = 3
            mul x19, x19, x3    // x19 = x19 * 3

            add x20, x20, #1    // n = n + 1
            mul x19, x19, x20   // x19 = x19 * x20

            sub x20, x20, #2    // n = n - 1 (-1 perchè prima avevo aggiunto 1)
            bl recursion        // ricomincio la ricorsione, stavolta con n-1
            b return_recursion  // evito che proceda a cascata effettuando calcoli ridondanti

       // .. * [f(N-1)]
        n_beq_zero:
            mov x2, #2          // x2 = 2
            mul x19, x19, x2    // x19 = x19 * 2 (perchè f(0)=2 per definizione)

    return_recursion:
        mov w0, #0
        ldp x29, x30, [sp], #16
        ret
        .size recursion, (. - recursion)






/* Function:    f(n) = 2 * f(n-1) - f(n-2)/2    per n >= 2, sapendo che f(0) = 0 e f(1) = 1; */
.section .rodata
fmt_n: .asciz "n: "
fmt_res: .asciz "%ld\n"
fmt_scan: .asciz "%d"
.align 3                // perchè align 3 ???

.data
risultati:  .skip (8 * 50)


.macro print n
    adr x0, fmt_res
    mov x1, \n
    bl printf
.endm


.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!


    adr x20, risultati  // salva in x20 l'indirizzo di memoria di "risultati"
    mov w19, #0         // contatore

    loop:
        cmp w19, #50    // se il contore è uguale a 50 ..
        beq return    // .. il ciclo viene interrotto

            mov x0, x19     // salva in x0 il valore di x19
            bl f_ric        // invoca la funzione ricorsiva

            str x0, [x20, x19, lsl #3]  // salva x0, (x19<<3) celle dopo x20. 

            mov x1, x0          // salva in x1, x0
            adr x0, fmt_res     // salva la fmt_string
            bl printf           // stampa la fmt_string e il valore

            add x19, x19, #1    // incrementa l'indice
            b loop              // ricomincia il loop

    return:
        mov x0, #0
        ldp x19, x20, [sp], #16
        ldp x29, x30, [sp], #16
        ret
        .size main, (. - main)



.type f_ric, %function
f_ric:
    stp x29, x30, [sp, #-16]!
    str x19, [sp, #-8]!

    cmp x0, #2          // se n >= 2 ..
    bge recursive_case  // .. inizia la ricorsione

        base_case:      
            mov x19, x0     // mette in x19, x0
            b end_f_ric     // termina la ricorsione

        recursive_case:
            adr x5, risultati           // salva in x5 l'indirizzo di memoria di "risultati"

            sub x1, x0, #1              // f(n-1)
            ldr x2, [x5, x1, lsl #3]    // carica in x2, il valore contenuto in x5[x1 * 8]
            lsl x2, x2, #1              // x2 *= 2

            sub x3, x19, #2             // f(n-2)
            ldr x4, [x5, x3, lsl #3]    // carica in x4, il valore contenuto in x5[x3 * 8]
            lsr x4, x4, #1              // x4 /= 2
            
            sub x19, x2, x4             // ris = x2 - x4    *dove x2 = 2*f(n-1) e x4 = f(n-2)/2
    
    end_f_ric:
        mov x0, x19
        ldr x19, [sp], #8
        ldp x29, x30, [sp], #16
        ret
        .size f_ric, (. - f_ric)





/* CONVERTE UN NUMERO DA DECIMALE A BINARIO */
.section .rodata
fmt_ask:        .asciz "Inserisci un numero: "
fmt_ln:         .asciz "\n"
fmt_zero:       .asciz "0"
fmt_uno:        .asciz "1"

fmt_print:      .asciz "%d\n"
fmt_scan:       .asciz "%d"


.bss
    value:  .word 0



.macro scan fmt var
    adr x0, \fmt 
    bl printf
    
    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm
.macro println
    adr x0, fmt_ln
    bl printf
.endm

.macro stampa_zero
    adr x0, fmt_zero
    bl printf       
.endm  
.macro stampa_uno
    adr x0, fmt_uno
    bl printf       
.endm



.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!


    scan fmt_ask, value         // acquisisco un valore da tastiera
    ldr x19, value              // lo memorizzo in x19

    bl parte_intera
    
    
exit:
    println
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)





.type parte_intera, %function
parte_intera:
    stp x29, x30, [sp, #-16]!

    cmp x19, #0
    beq end_recursion

    tbz  x19, [0], pari_case        // se il bit meno significativo è 0, allora stampa pari
    tbnz x19, [0], dispari_case     // se il bit meno significativo non è 0, allora stampa dispari

        dispari_case:
            lsr x19, x19, #1
            bl parte_intera
            stampa_uno
            b end_recursion

        pari_case:
            lsr x19, x19, #1
            bl parte_intera
            stampa_zero
            b end_recursion

end_recursion:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size parte_intera, (. - parte_intera)
    