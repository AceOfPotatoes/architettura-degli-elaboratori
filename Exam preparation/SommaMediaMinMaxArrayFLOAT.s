.section .rodata
    fmt_prompt:         .asciz "Inserire un numero reale (termina con 0): "
    fmt_scan_float:     .asciz "%lf"
    fmt_vuoto:          .asciz "VUOTO\n"

    // Formattazione per stampare ogni valore uno per volta (la funzione printf lo recuperera' dal registro d0)
    fmt_min: .asciz "Minimo: %.2lf\n"
    fmt_max: .asciz "Massimo:%.2lf\n"
    fmt_somma: .asciz "Somma: %.2lf\n"
    fmt_media: .asciz "Media: %.2lf\n"

.align 3

.bss
    array:      .skip (8*50)
    tmp_double: .skip 8
    min:        .skip 8
    max:        .skip 8
    somma:      .skip 8
    media:      .skip 8

.data
    zero_float: .double 0.0

.macro stampa_double fmt, n
    adr x0, \fmt
    ldr d0, \n
    bl printf
.endm

.macro stampa_vuoto
    adr x0, fmt_vuoto
    bl printf
.endm

.macro scansiona_double fmt, n
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan_float
    adr x1, \n
    bl scanf 
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    
    ldr x20, =array          //indirizzo dell'array
    mov w19, #0             //contatore elementi dell'array 

    loop_input:
        scansiona_double fmt_prompt, tmp_double
        ldr d0, tmp_double
        fcmp d0, #0.0
        beq endloop_input
        str d0, [x20], #8
        add w19, w19, #1
        b loop_input
    endloop_input:

    ldr d0, zero_float        //Usa d0 per il minimo
    ldr d1, zero_float        //Usa d1 per il massimo
    ldr d2, zero_float        //Usa d2 per la somma
    ldr d3, zero_float        //Usa d3 per la media

    ldr x20, =array          //ri-carico indirizzo dell'array
    cmp w19, #0             //controllo che l'array non sia vuoto
    beq stampa_no_elementi
    
    ldr d20, [x20], #8       //Carico il primo elemento dell'array
    add d2, d2, d20         //Aggiungo alla somma il valore
    fmov d0, d20             //Suppongo che il min sia il primo elemento
    fmov d1, d20             //Suppongo che il max sia il primo elemento
    
    mov w0, #1              //Contatore loop
    loop_scansione:
        cmp w0, w19
        beq endloop_scansione

        ldr d20, [x20], #8       //Carico il primo elemento dell'array
        fadd d2, d2, d20         //Aggiungo alla somma il valore
        
        fcmp d20, d0
        fcsel d0, d20, d0, lt
        fcmp d20, d1
        fcsel d1, d20, d1, gt

        add w0, w0, #1
        b loop_scansione
    endloop_scansione:

    calcola_media:
        scvtf d5, w19
        fdiv d3, d2, d5

    invia_in_memoria:
        ldr x0, =min
        ldr x1, =max
        ldr x2, =somma
        ldr x3, =media
        str d0, [x0]
        str d1, [x1]
        str d2, [x2]
        str d3, [x3]

    stampa_elementi:
        stampa_double fmt_min, min
        stampa_double fmt_max, max
        stampa_double fmt_somma, somma
        stampa_double fmt_media, media
        b exit

    stampa_no_elementi:
        stampa_vuoto
        b exit

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    