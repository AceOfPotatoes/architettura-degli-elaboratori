.section .rodata
fmt_menu: .asciz "Scegli l'operazione da eseguire:\n1.Deposita\n2.Preleva\n3.Esci\n>>"
fmt_scelta: .asciz "Scelta inserita!\n"
fmt_saldo: .asciz "\n*******\nIl saldo disponibile è %d\n*******\n"
fmt_importo: .asciz "Inserisci l'importo\n>> "
fmt_nodisp: .asciz "ATTENZIONE: Importo non disponibile!\n"
fmt_err: .asciz "ATTENZIONE: Scelta errata!\n"
fmt_scan: .asciz "%d"
.align 2

.bss
scelta: .word 0
saldo: .word 0
importo: .word 0

.macro print fmt 
    adr x0, \fmt
    bl printf
.endm

.macro print_v fmt value 
    adr x0, \fmt
    ldr x1, \value
    bl printf
.endm

.macro scan fmt var
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
    str x21, [sp, #-8]!
    
    loop:
        print_v fmt_saldo, saldo 
        
        scan fmt_menu, scelta

        ldr w0, scelta
        cmp w0, #3
        beq endloop    

        mov w19, w0

        print fmt_scelta 

        cmp w19, #1
        beq deposita
        cmp w19, #2
        beq preleva

        b err

        deposita:
            scan fmt_importo, importo
            ldr w20, saldo
            ldr w21, importo
            add w20, w20, w21
            ldr x21, =saldo
            str w20, [x21]
            mov w0,#0
            b loop
        preleva:
            scan fmt_importo, importo
            ldr w20, saldo
            ldr w21, importo
            sub w20, w20, w21
            cmp w20, #0
            blt nodisp 
  
            ldr x21, =saldo
            str w20, [x21]
            b loop

            nodisp:
                print fmt_nodisp
                b loop
                
        err:
            print fmt_err
            b loop

    endloop:

    mov w0, #0
    ldr x21, [sp], #8
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
