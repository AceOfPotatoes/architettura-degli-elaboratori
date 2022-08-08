.section .rodata
fmt_un_int: .asciz "%d\n"
fmt_due_int: .asciz "Primo: %d Secondo: %d\n"
fmt_quattro_int: .asciz "Primo: %d Secondo: %d Terzo: %d Quarto: %d\n"
fmt_inserisci: .asciz "Inserisci un intero: "
fmt_scan: .asciz "%d"

.data
n: .word 0

.macro print_n
    adr x0, fmt_un_int
    ldr w1, n
    bl printf
.endm

.macro print fmt var
    adr x0, \fmt
    ldr w1, \var
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

    adr x0, fmt_un_int
    mov w1, #10
    bl printf

    adr x0, fmt_due_int
    mov w1, #10
    mov w2, #20
    bl printf

    adr x0, fmt_quattro_int
    mov w1, #10
    mov w2, #20
    mov w3, #30
    mov w4, #40
    bl printf

    print_n
    print fmt_un_int n

    scan fmt_inserisci n
    print_n
    print fmt_un_int n

    // return 0
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
