.section .rodata
fmt_scan:       .asciz "%d"
fmt_prompt:      .asciz "Inserisci il numero: "
fmt_ok:         .asciz "OK\n"
fmt_no:         .asciz "NO\n"

.bss
    n: .skip 4
    nPrec: .skip 4

.macro scansiona fmt var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    ldr w1, =\var
    bl scanf
.endm

.macro print_ok
    adr x0, fmt_ok
    bl printf
.endm

.macro print_no
    adr x0, fmt_no
    bl printf
.endm

.text
.type main, %function
.global main
/*
Scrivere un programma AArch64 che, letta da input una sequenza di numeri interi 
positivi terminata da un numero negativo, stampi OK se la sequenza è strettamente 
crescente, NO altrimenti.
 */

main:
    stp x29, x30, [sp, #-16]!

    mov w19, #1          //registro usato come bool, parte da TRUE

    scansiona fmt_prompt n 
    ldr w0, n 
    cmp w0, #0
    bmi ok

    loop:
        ldr x1, =nPrec
        str w0, [x1]
        scansiona fmt_prompt n 
        ldr w0, n
        ldr w1, nPrec
        cmp w0, #0
        bmi endloop   //termina con input negativo 
        cmp w19, #0
        beq salta_cset
        cmp w0, w1
        cset w19, gt 
        salta_cset: 
        b loop
    endloop:

    cmp w19, #1
    bne no    
    ok: 
        print_ok
        b exit
    no: 
        print_no
    
exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
