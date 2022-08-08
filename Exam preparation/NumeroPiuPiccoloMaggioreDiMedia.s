.section .rodata
fmt_inserisci_num:
    .asciz "Inserisci il numero da inserire nell'array (negativo per terminare): \n"
fmt_array_vuoto:
    .asciz "L'array è vuoto, impossibile procedere al calcolo.\n"
fmt_scan:
    .asciz "%d"
fmt_media:
    .asciz "La media è %d.\n"
fmt_piccolo:
    .asciz "Il numero più piccolo rispetto alla media è %d\n"
fmt_grande:
    .asciz "Il numero più grande è %d\n"



.bss 
n: .skip 400
tmp_int: .skip 4


.macro scan_int
    adr x0, fmt_inserisci_num
    bl printf

    adr x0, fmt_scan
    adr x1, tmp_int
    bl scanf

    ldr w0, tmp_int
.endm



.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!

mov w19, #0
ldr x20, =n
loop:
    cmp w19, #100
    bge fine_loop

    scan_int
    cmp w0, #0
    blt fine_loop

    str w0, [x20], #4
    add w19, w19, #1
    b loop

fine_loop:

    bl calcola_media


    mov w0, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
.size main, (. - main)

.type calcola_media, %function
calcola_media:
    stp x29, x30, [sp, #-16]!
    stp x20, x21, [sp, #-16]!

    cmp w19, #0
    beq escape_array_vuoto

    mov w2, #0 //contatore
    ldr x20, =n

    inizia_a_sommare:
        cmp w2, w19
        bge completa_il_calcolo
        
        ldr w3, [x20], #4
        add w1, w1, w3
        add w2, w2, #1
        b inizia_a_sommare

        completa_il_calcolo:
            sdiv w1, w1, w19
            mov w21, w1

            adr x0, fmt_media
            bl printf

            bl piupiccolo

            b fine_calcoli
    
    escape_array_vuoto:
        adr x0, fmt_array_vuoto
        bl printf
    
    fine_calcoli:
    
    mov w0, #0
    ldp x20, x21, [sp], #16
    ldp x29, x30, [sp], #16
    ret
.size calcola_media, (. - calcola_media)

.type piupiccolo, %function
piupiccolo:
    stp x29, x30, [sp, #-16]!

    mov w2, #0
    ldr x20, =n
    mov w22, #1

    inizia_a_cercare_piccolo:
        cmp w2, w19
        bge fine_ricerca_piccolo

        ldr w3, [x20], #4
        cmp w3, w21
        blt aumenta_contatore
        
        cmp w22, #1
        bne almeno_uno
        mov w1, w3
        mov w22, #0
        b aumenta_contatore

        almeno_uno:
        cmp w3, w1
        bge aumenta_contatore
        mov w1, w3

        aumenta_contatore:
            add w2, w2, #1
            b inizia_a_cercare_piccolo

    fine_ricerca_piccolo:
        adr x0, fmt_piccolo
        bl printf
    
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
.size piupiccolo, (. - piupiccolo)





