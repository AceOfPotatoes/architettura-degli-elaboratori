.section .rodata
fmt_scan:   .asciz "%d"
fmt_limite:      .asciz "Inserisci il numero: "
fmt_numeroprimo: .asciz "%d "
fmt_ciao: .asciz "ciao\n"


.bss
    limite: .word 0
    n:      .word 0

.macro invoca_primo n
    ldr w0, \n
    bl primo
.endm

.macro scansiona fmt var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm

.macro stampa_primo
    ldr x1, n
    adr x0, fmt_numeroprimo
    bl printf
.endm

.macro stampa_xdlol
    adr x0, fmt_ciao
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    str x19, [sp, #-8]!
    scansiona fmt_limite limite
    mov w10, #2
    ldr w19, limite
    loop_main:
        cmp w10, w19
        bgt exit
        ldr x5, =n
        str w10, [x5]
        invoca_primo n 
        cmp w0, #1
        beq print_primo
        ritorno:
        add w10, w10, #1
        b loop_main

print_primo:
    stampa_primo
    b ritorno


exit:
    mov w0, #0
    ldr x19, [sp], #8
    ldp x29, x30, [sp], #16
    
    ret
    .size main, (. - main)

.type primo, %function
primo:
    //x0 -> limite superiore (NON incluso)
    mov w0, #2
    mov w1, #2      //contatore
    loop_primo:    
        
        cmp w1, w0  
        bge fine_loop
        stampa_xdlol
        udiv w6, w0, w1
        bcc non_primo 
        add w1, w1, #1       
        b loop_primo
         
    fine_loop:
        mov w0, #1
        ret

    non_primo: 
        mov w0, #0
        ret

    .size primo, (. - primo)
