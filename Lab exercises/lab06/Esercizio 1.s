.section .rodata
    fmt_scan: .asciz "%d"  
    fmt_pari: .asciz "PARI"
    fmt_dispari: .asciz "DISPARI"

.bss
    num: .word 0

.macro stampa_pari       
    adr x0, fmt_pari       
    bl printf       
.endm               
 
.macro stampa_dispari     
    adr x0, fmt_dispari      
    bl printf       
.endm  
 
.macro scan fmt var
    adr x0, \fmt
    ldr x1, =\var
    bl scanf
.endm


.text
.global main

main :
    stp x29, x30, [sp, #-16]!
    scan fmt_scan num

    ldr x19, num

    tbz x19, [0], pari_case   //  se l'ultimo bit (posizione 0) è 0, allora esegue pari_case

    dispari_case:
        stampa_dispari
        b exit

    pari_case:
        stampa_pari
        b exit    
 
exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)