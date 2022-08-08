.section .rodata
    fmt_inf: .asciz "Estremo inferiore: "
    fmt_sup: .asciz "Estremo superiore: "
    fmt_scan: .asciz "%d"
    fmt_somma: .asciz "La somma è uguale a: %d\n"

.bss
    inf:    .word 0
    sup:    .word 0
    somma:  .word 0 

.macro stampa_somma var    
    adr x0, fmt_somma
    ldr x1, \var     
    bl printf       
.endm  
 
.macro scansiona fmt var
    adr x0, \fmt 
    bl printf
    
    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm

.text
.global main

main:
    stp x29, x30, [sp, #-16]!

    scansiona fmt_inf, inf
    scansiona fmt_sup, sup

    
    ldr w19, inf
    ldr w20, sup
    add w20, w20, #1
    mov w21, #0

    loop:        
        add w21, w21, w19
        add w19, w19, #1
        cmp w19, w20
        bne loop

stampa:
    ldr x5, =somma
    str w21, [x5]
    stampa_somma somma
 
exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)