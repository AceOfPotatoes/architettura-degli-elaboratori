.section .rodata
fmt_readM: .asciz "Inserisci un numero: "
fmt_readN: .asciz "Inserisci l'esponente (>0): "
fmt_scan: .asciz "%d"
fmt: .asciz "Il risultato e' %d\n"
.align 2

.data
m: .word 0
n: .word 0

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
    
    scan fmt_readM, m
    scan fmt_readN, n

    ldr w0, m
    ldr w1, n
    bl potenza
    mov w1, w0
    adr x0, fmt
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)

.type potenza, %function
potenza:
    stp x29, x30, [sp, #-16]!
    str x19, [sp, #-8]!

    cmp w1, #1
    bgt ricorsivo

    base: 
        b end        

    ricorsivo:
        mov w19, w0
        sub w1, w1, #1
        bl potenza
        mul w19, w19, w0
    end:

    mov w0, w19
    ldr x19, [sp], #8
    ldp x29, x30, [sp], #16
    ret
    .size potenza, (. - potenza)   
