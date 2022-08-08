.section .rodata
fmt_A: .asciz "A[%d]: "
fmt_prog: .asciz "*****\nIn Progressione!\n*****\nd=%d\n*****\n"
fmt_noprog: .asciz "*****\nNON in Progressione!\n*****\n"
fmt_n: .asciz "Inserire il numero di elementi (>2): "
fmt_scan: .asciz "%d"

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    sub sp, sp, #4
        loop_n:
            adr x0, fmt_n
            bl printf

            adr x0, fmt_scan
            mov x1, sp
            bl scanf
            
            ldr w20, [sp]
            cmp w20, #3
            blt loop_n
    add sp, sp, #4

    sub sp, sp, w20, lsl #2
        
        mov w19, #0
        read_loop:
            cmp w19, w20
            bge end_read_loop

            adr x0, fmt_A
            mov w1, w19
            bl printf
            
            adr x0, fmt_scan
            add x1, sp, w19, lsl #2
            bl scanf

            add w19, w19, #1
            b read_loop
        end_read_loop:
        
        ldp w21, w22, [sp]
        sub w22, w22, w21
        mov w19, #2
        prog_loop:    
            cmp w19, w20
            bge prog
            
            madd w0, w19, w22, w21
            ldr w1, [sp, x19, lsl #2]
            add w19, w19, #1
            
            cmp w0, w1
            beq prog_loop

            adr x0, fmt_noprog
            bl printf
            b end_prog_loop
        
        prog:
            adr x0, fmt_prog
            mov w1, w22
            bl printf
        
        end_prog_loop:

    add sp, sp, w20, lsl #2

    mov w0, #0
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
