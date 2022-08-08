.section .rodata
    fmt_scan: .asciz "%d"  
    fmt_elemento: .asciz "Inserisci elemento (termina con n Negativo): "
    fmt_si: .asciz "SI\n"
    fmt_no: .asciz "NO\n"
    

.bss
    nPrec: .word 0
    nSucc: .word 0

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

main :
    stp x29, x30, [sp, #-16]!


    scansiona fmt_elemento, nPrec

    scansiona fmt_elemento, nSucc
    ldr w19, nPrec
    cmp w19, #0     //Controlliamo se nSucc è negativo
    bmi no

    ldr w20, nSucc
    mov w25, #1     //bool Crescente

    loop:
        cmp w20, #0     //Controlliamo se nSucc è negativo
        bmi controllo_crescente 
        
        cmp w19, w20    //Confrontiamo nPrec ed nSucc
        bge imposta_non_crescente
        b end_if
        imposta_non_crescente: 
            mov w25, #0     // Quindi non crescente
        
        end_if:
            mov w19, w20    //nPrec <- nSucc
            scansiona fmt_elemento, nSucc
            ldr w20, nSucc               
            b loop      

controllo_crescente:
    cmp w25, #1     //Se il confronto viene negativo, vuol dire che w25 == 1 (quindi crescente)
    bmi no
    b si

si: 
    stampa_si
    b exit

no:
    stampa_no

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)