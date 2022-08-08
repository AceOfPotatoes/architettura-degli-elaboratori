.section .rodata
    fmt_lato1:         .asciz "Primo lato: "  
    fmt_lato2:         .asciz "Secondo lato: "
    fmt_lato3:         .asciz "Terzo lato: "
    fmt_scan:       .asciz "%d"
    fmt_scaleno:    .asciz "TRIANGOLO SCALENO!\n"
    fmt_equilatero: .asciz "TRIANGOLO EQUILATERO!\n"
    fmt_isoscele:   .asciz "TRIANGOLO ISOSCELE!\n"
    fmt_no:         .asciz "NO!\n"

.bss
    lato1: .word 0
    lato2: .word 0
    lato3: .word 0

.macro stampa_no      
    adr x0, fmt_no     
    bl printf       
.endm     

.macro stampa_scaleno      
    adr x0, fmt_scaleno    
    bl printf       
.endm 

.macro stampa_isoscele     
    adr x0, fmt_isoscele    
    bl printf       
.endm 

.macro stampa_equilatero    
    adr x0, fmt_equilatero     
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

    mov w1, #0          //Numero di confronti che soddisfano "EQ"

    scansiona fmt_lato1, lato1
    scansiona fmt_lato2, lato2
    scansiona fmt_lato3, lato3
    
    ldr w10, lato1
    ldr w11, lato2
    ldr w12, lato3

lato1_minore_lato2elato3:
    mov w13, #0
    add w13, w11, w12       //w13 = Somma dei due lati
    cmp w10, w13
    bge no

lato2_minore_lato1elato3:
    mov w13, #0
    add w13, w10, w12       //w13 = Somma dei due lati
    cmp w11, w13
    bge no

lato3_minore_lato1elato2:
    mov w13, #0
    add w13, w10, w11       //w13 = Somma dei due lati
    cmp w12, w13
    bge no
    
    cmp w10, w11
    bne endif1
        add w1, w1, #1
    endif1:

    cmp w11, w12
    bne endif2
        add w1, w1, #1
    endif2:

    cmp w10, w12
    bne endif3
        add w1, w1, #1
    endif3:
    
    cmp w1, #3
    beq equilatero

    cmp w1, #1
    beq isoscele 

    b scaleno 

no:
    stampa_no
    b exit

    
 
equilatero:
    stampa_equilatero
    b exit

isoscele:
    stampa_isoscele 
    b exit

scaleno:
    stampa_scaleno
    b exit

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)