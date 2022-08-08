.section .rodata
    fmt_n1: .asciz "Primo numero: "  
    fmt_n2: .asciz "Secondo numero: "
    fmt_n3: .asciz "Terzo numero: "
    fmt_scan: .asciz "%d"
    fmt_ripetuto: .asciz "Numero ripetuto: %d\n"
    fmt_ok: .asciz "OK!\n"

.bss
    n1: .word 0
    n2: .word 0
    n3: .word 0
    rip: .word 0

.macro stampa_ok      
    adr x0, fmt_ok      
    bl printf       
.endm               
 
.macro stampa_ripetuto var    
    adr x0, fmt_ripetuto
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

    scansiona fmt_n1, n1
    scansiona fmt_n2, n2
    scansiona fmt_n3, n3

    ldr w10, n1
    ldr w11, n2
    cmp w10, w11
    beq ripetuto

    ldr w10, n1
    ldr w11, n3
    cmp w10, w11
    beq ripetuto

    ldr w10, n2
    ldr w11, n3
    cmp w10, w11
    beq ripetuto
    
    stampa_ok
    b exit

ripetuto:
    ldr x5, =rip
    str w10, [x5] 
    stampa_ripetuto rip
 
exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)