.section .rodata
fmt_mese:           .asciz "INSERISCI MESE: "
fmt_inverno:        .asciz "INVERNO\n"
fmt_primavera:      .asciz "PRIMAVERA\n"
fmt_estate:         .asciz "ESTATE\n"
fmt_autunno:        .asciz "AUTUNNO\n"
fmt_non_valido:     .asciz "MESE NON VALIDO\n"
fmt_giorno:         .asciz "SPECIFICA GIORNO: "
fmt_scan:           .asciz "%d"

.bss
    mese:   .skip 4
    giorno: .skip 4

.macro scansiona fmt var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    ldr w1, =\var
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
Programma che stabilisce stagione
input 3-6-9-12 richiederanno l'inserimento del giorno
se giorno > 20, allora si considera stagione successiva
se giorno < 20, allora si considera stagione precedente
*/

main:
    stp x29, x30, [sp, #-16]!
    scansiona fmt_mese mese
    ldr w20, mese

    cmp w20, #1
    beq stampa_inverno
    blt mese_non_valido
    cmp w20, #12
    bgt mese_non_valido
    bne salta_giorno_dicembre
    scansiona fmt_giorno giorno
    ldr w21, giorno
    cmp w21, #20
    ble stampa_autunno
    b stampa_inverno
    
    salta_giorno_dicembre:
    cmp w20, #2
    beq stampa_inverno
    cmp w20, #4
    beq stampa_primavera
    cmp w20, #5
    beq stampa_primavera
    cmp w20, #7
    beq stampa_estate
    cmp w20, #8
    beq stampa_estate
    cmp w20, #10
    beq stampa_autunno
    cmp w20, #11
    beq stampa_autunno

    cmp w20, #3
    bne salta_giorno_marzo
    scansiona fmt_giorno giorno
    ldr w21, giorno
    cmp w21, #20
    ble stampa_inverno
    b stampa_primavera
    salta_giorno_marzo:

    cmp w20, #6
    bne salta_giorno_giugno
    scansiona fmt_giorno giorno
    ldr w21, giorno
    cmp w21, #20
    ble stampa_primavera
    b stampa_estate
    salta_giorno_giugno:

    cmp w20, #9
    bne salta_giorno_settembre
    scansiona fmt_giorno giorno
    ldr w21, giorno
    cmp w21, #20
    ble stampa_estate
    b stampa_autunno
    salta_giorno_settembre:
    
    
stampa_inverno:
    print_risultato fmt_inverno
    b exit

stampa_primavera:
    print_risultato fmt_primavera
    b exit

stampa_estate:
    print_risultato fmt_estate
    b exit

stampa_autunno:
    print_risultato fmt_autunno
    b exit

mese_non_valido:
    print_risultato fmt_non_valido

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
