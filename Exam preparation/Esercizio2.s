.section .rodata
fmt_prompt:      .asciz "Inserire n: "
fmt_scan:        .asciz "%d"
fmt_output:      .asciz "<OUTPUT>%u</OUTPUT>\n"

.align 2

.bss
    n:      .skip 4
    somma:  .skip 4

.macro print fmt, num
    adr x0, \fmt
    ldr w1, \num
    bl printf
.endm

.macro scansiona fmt, n 
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    adr x1, \n
    bl scanf
.endm

.text
.type main, %function
.global main

main:
    stp x29, x30, [sp, #-16]!

    scansiona fmt_prompt, n

    mov w19, #0             //in questo registro verrà inserita la somma delle cifre    
    ldr w20, n              //in questo registro viene caricato n da usare per la conversione
    mov w25, #2             //inserisce 2, che servirà per l'udiv
    
    //il seguente loop andrà avanti fino a che w20 non sarà uguale a 0
    loop:
        cmp w20, #0
        beq endloop

        udiv w22, w20, w25          //w22 = w20/2
        msub w1, w22, w25, w20

        add w19, w19, w1            //aggiungo resto (cifra binaria) alla somma
        udiv w20, w20, w25

        b loop
    endloop:
    
    adr x0, somma
    str w19, [x0]                   //memorizzo la somma

    print fmt_output, somma

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
