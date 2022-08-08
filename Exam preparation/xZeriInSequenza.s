.section .rodata
    fmt_x: .asciz "Inserisci X: "
    fmt_elemento: .asciz "Inserisci elemento (termina con negativo): "
    fmt_scan: .asciz "%d"
    fmt_si: .asciz "SI\n"
    fmt_no: .asciz "NO\n"

.bss
    x:          .word 0     //Numero di zeri necessari per soddisfare la condizione...
    elemento:   .word 0  

.macro stampa_si   
    adr x0, fmt_si  
    bl printf       
.endm  

.macro stampa_no   
    adr x0, fmt_no 
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

    scansiona fmt_x, x
    
    mov w20, #0         //w20 tiene traccia degli zeri inseriti nella sequenza

    loop:
        scansiona fmt_elemento, elemento
        ldr w19, elemento
        cmp w19, #0
        bne endif
            add w20, w20, #1 

        endif: 
        cmp w19, #0
        bpl loop

    ldr w10, x
    cmp w20, w10
    bge si  
    b no

si:
    stampa_si
    b exit

no:
    stampa_no
    b exit

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)