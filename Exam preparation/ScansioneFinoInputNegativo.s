.section .rodata
fmt_scan:       .asciz "%d"
fmt_prompt:      .asciz "Inserire numero (termina con -405): "
fmt_output:     .asciz "<OUTPUT>%u</OUTPUT>\n"

.bss
    n:          .word 0
    multipli:   .word 0    

.macro scansiona fmt var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    adr x1, \var
    bl scanf
.endm

.macro print_res fmt, n
    adr x0, \fmt
    ldr w1, \n 
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    
    mov w20, #0             //Contatore multipli
    mov w27, #256           //inserisce 256 in un registro, da usare per udiv
    loop_input:
        scansiona fmt_prompt n 
        ldr w25, n
        cmp w25, #-405
        beq endloop_input    //termina con input = -405

        udiv w0, w25, w27
        msub w1, w0, w27, w25           //resto della divisione, se = 0 allora è multiplo

        cmp w1, #0
        bne no_multiplo
        add w20, w20, #1 
        no_multiplo:
        b loop_input
    endloop_input:
   
    adr x0, multipli
    str w20, [x0]

    print_res fmt_output, multipli

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
