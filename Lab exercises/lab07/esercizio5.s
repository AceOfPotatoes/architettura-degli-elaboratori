.section .rodata
fmt_scan:   .asciz "%d"
fmt_numero:      .asciz "Inserisci il numero: "
fmt_contatore: .asciz "La lunghezza dell'iterazione è %d. \n "


.bss
    n:      .word 0

.macro scansiona fmt var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm



.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!

    //ora prendo da input il numero
    scansiona fmt_numero n
    
    ldr w19, n
    bl collatz
    adr x0, fmt_contatore
    bl printf


exit:
    mov w0, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    
    ret
    .size main, (. - main)

.type collatz, %function
collatz:
    stp x29, x30, [sp, #-16]!

    caso_base:
    cmp w19, #1
    mov w20, #1
    beq fine_ricorsione

    ricorsione:
    /*qui controllo se è pari o dispari */
    mov w2, #2
    udiv w3, w19, w2
    msub w4, w3, w2, w19
    cmp w4, #01
    beq dispari
    mov w19, w3
    bl collatz
    add w20, w20, #1
    b fine_ricorsione

    dispari:
    mov w2,#3
    mov w3, #1
    madd w19, w19, w2, w3
    bl collatz
    add w20, w20, #1  

    fine_ricorsione:
    mov w1, w20
    ldp x29, x30, [sp], #16
    ret

    .size collatz, (. - collatz)
