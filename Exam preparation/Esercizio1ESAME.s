.section .rodata
fmt_prompt:      .asciz "Inserire n: "
fmt_scan:        .asciz "%ld"
fmt_output:      .asciz "<OUTPUT>%llu</OUTPUT>\n"

.align 3

.data
    n_meno_1: .quad 7
    n_meno_2: .quad 10
    f_di_n: .quad 0
    n: .quad 0
    

.macro print num, fmt
    adr x0, \fmt
    ldr x1, \num
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


    cmp x19, #0
    beq stampa_f_di_0       //Se in input viene scritto 0 stampa risultato diretto

    cmp x19, #1
    beq stampa_f_di_1       //Se in input viene scritto 1 stampa risultato diretto

    mov x19, #1             //Contatore loop
    

    loop:
        ldr x20, n              //Carico n
        cmp x19, x20            //Se il contatore è uguale ad n esce
        bge endloop

        ldr x20, n_meno_2
        ldr x21, n_meno_1

        mov x4, #3
        mul x5, x21, x4         //x5 = 3*t(n-1)

        mov x4, #4
        udiv x6, x20, x4        //x6 = t(n-2)//4

        add x22, x5, x6         //x22 = 3*t(n-1) + t(n-2)//4

        ldr x2, =f_di_n         
        str x22, [x2]           //f_di_n = x22 = 3*t(n-1) + t(n-2)//4

        ldr x1, =n_meno_2       //carico indirizzo n_meno_2
        str x21, [x1]           //sostituisco n_meno_2 con x21 (n_meno_1)

        ldr x1, =n_meno_1       //carico indirizzo n_meno_1
        str x22, [x1]           //sostituisco n_meno_2 con x22 (f_di_n)

        add x19, x19, #1        //Incremento contatore
        
        b loop
    endloop:

    print f_di_n, fmt_output
    b exit

    stampa_f_di_0:
        print n_meno_2, fmt_output
        b exit

    stampa_f_di_1:
        print n_meno_1, fmt_output
        b exit

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)

