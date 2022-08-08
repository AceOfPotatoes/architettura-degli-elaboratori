.section .rodata
fmt_n: .asciz "Insert a non-negative number (negative to terminate): "
fmt_scan: .asciz "%d"
fmt_count: .asciz "The count is: %d.\n"
.align 2

.bss
n: .word 0 //da utilizzare per memorizzare di volta in volta il numero letto

.macro scan fmt var //da utilizzare per leggere un numero
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
    
    //da completare

    mov w19, #0
    mov w20, #2

    loop:
        scan fmt_n n  
        ldr w1, n 
        cmp w1,#0
        blt end
        udiv w2, w1, w20
        msub w3, w2, w20, w1
        cmp w3, #1
        beq loop
        add w19, w19, #1
        b loop  

    end:
    adr x0, fmt_count
    mov w1, w19
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
