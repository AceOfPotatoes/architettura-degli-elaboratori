.section .rodata
fmt_scan:       .asciz "%d"
fmt_prompt:     .asciz "Inserisci un numero (-1 per terminare): "
fmt_prompt_n:   .asciz "Inserisci il numero di 0 consecutivi da considerare: "
fmt_ok:         .asciz "OK\n"
fmt_no:         .asciz "NO\n"

.bss
    n:               .skip 4
    max_n:           .skip 4
    elemento:        .skip 4

.macro scansiona fmt, var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    ldr w1, =\var
    bl scanf
.endm

.macro print fmt
    adr x0, \fmt
    bl printf
.endm

.text
.type main, %function
.global main

main:
    stp x29, x30, [sp, #-16]!

    mov w19, #0             //registro usato come contatore "0" CONSECUTIVI            

    scansiona fmt_prompt_n, n         //prendo in input il numero di consecutivi da considerare


    loop:
        scansiona fmt_prompt, elemento
        ldr w5, elemento
        cmp w5, #-1
        beq controllo_zeri
        cmp w5, #0
        bne reset_zeri       
        add w19, w19, #1
        b loop
        reset_zeri:        
            ldr w0, max_n
            cmp w19, w0
            ble no_scambio
            ldr x0, =max_n
            str w19, [x0]
            mov w19, #0
            no_scambio:
        b loop

    controllo_zeri:
        reset_zeri_finale:        
            ldr w0, max_n
            cmp w19, w0
            ble no_scambio_finale
            ldr x0, =max_n
            str w19, [x0]
            mov w19, #0
        no_scambio_finale:
        ldr w0, n
        ldr w1, max_n
        cmp w1, w0
        blt stampa_no

    stampa_ok:
        print fmt_ok
        b exit

    stampa_no: 
        print fmt_no

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
