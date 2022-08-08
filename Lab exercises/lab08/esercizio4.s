.section .rodata
fmt_read: .asciz "Inserisci un anno (0 per terminare): "
fmt_bis: .asciz "BISESTILE!!!\n"
fmt_nobis: .asciz "NON BISESTILE!!!\n"
fmt_scan: .asciz "%d"
fmt: .asciz "%d\n"
.align 2

.bss
y: .word 0

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
    str x19, [sp, #-8]!
    
    mov w19, #0
    loop:

        loop_scan:
            scan fmt_read, y
            ldr w0, y
            cmp w0, w19
            beq end_loop

        bl bisestile
        b loop

    end_loop:

    mov w0, #0
    ldr x19, [sp], #8
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)


.type bisestile, %function
bisestile:
    stp x29, x30, [sp, #-16]!
    str x20, [sp, #-8]!
    
    mov w20, w0
    mov w1, #0
    mov w2, #4
    mov w3, #100

    udiv w4, w20, w2
    msub w4, w4, w2, w20
    cmp w4, w1
    bne else_if
    udiv w4, w20, w3
    msub w4, w4, w3, w20
    cmp w4, w1
    beq else_if

    adr x0, fmt_bis
    bl printf
    b end_if

    else_if:
        mul w19, w2, w3
        udiv w4, w20, w19
        msub w4, w4, w19, w20
        cmp w4, w1
        bne else
    
        adr x0, fmt_bis
        bl printf
        b end_if
    
    else:
        adr x0, fmt_nobis
        bl printf

    end_if:
    mov w19,#0
    ldr x20, [sp], #8
    ldp x29, x30, [sp], #16
    ret
    .size bisestile, (. - bisestile)
