.section .rodata
fmt_prompt_dividendo:   .asciz "Inserire dividendo: "
fmt_prompt_divisore:    .asciz "Inserire divisore: "
fmt_quoziente:          .asciz "Quoziente: %d\n"
fmt_resto:              .asciz "Resto: %d\n"
fmt_scan:               .asciz "%d"

.bss
    dividendo:  .skip 4
    divisore:   .skip 4
    quoziente:  .skip 4
    resto:      .skip 4

.macro scansiona fmt, var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm

.macro stampa fmt, num
    adr x0, \fmt
    ldr w1, \num
    bl printf
.endm

.text
.type main, %function
.global main

/*
Dati in input un dividendo ed un divisore, stampare il loro quoziente ed il resto della divisione intera
*/

main:
    stp x29, x30, [sp, #-16]!
    scansiona fmt_prompt_dividendo, dividendo
    scansiona fmt_prompt_divisore, divisore

    ldr w0, dividendo
    ldr w1, divisore

    udiv w2, w0, w1
    msub w3, w2, w1, w0

    ldr x0, =quoziente
    ldr x1, =resto

    str w2, [x0]
    str w3, [x1]

    stampa_quoziente: 
        stampa fmt_quoziente quoziente

    stampa_resto:
        stampa fmt_resto resto


exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
