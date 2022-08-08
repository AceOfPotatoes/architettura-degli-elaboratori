.section .rodata
fmt_scelta_menu:
    .ascii "0 per inserire un numero decimale.\n"
    .ascii "1 per inserire un numero float.\n"

fmt_inserisci_num:
    .asciz "Inserisci il numero da convertire: \n"
fmt_punto:
    .asciz "."

fmt_scan_float:
    .asciz "%lf"
fmt_scan_deci:
    .asciz "%ld"
fmt_scan_binario:
    .asciz "%b"
fmt_scan_esa:
    .asciz "%x"

fmt_stampa_deci:
    .asciz "Decimale: %ld\n"
fmt_stampa_bin1:
    .asciz "Binario: %d"
fmt_stampa_bin:
    .asciz "%d"
fmt_stampa_esa:
    .asciz "Esadecimale: %x\n"
fmt_stampa_float:
    .asciz "Floating: %.2lf\n"
fmt_stampa_separatore:
    .asciz "\n"

.bss 
tmp_float: .skip 8
tmp_int: .skip 8


.macro scan_float fmt
    adr x0, fmt_inserisci_num
    bl printf

    adr x0, \fmt
    adr x1, tmp_float
    bl scanf


.endm

.macro scan_int
    adr x0, fmt_scelta_menu
    bl printf

    adr x0, fmt_scan_deci
    adr x1, tmp_int
    bl scanf

    ldr w0, tmp_int

.endm


.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!

    scan_int

    cmp w0, #0
    bne skip_no_decimale
    scan_float fmt_scan_deci
    
    adr x0, fmt_stampa_deci
    ldr x1, tmp_float
    bl printf

    adr x0, fmt_stampa_esa
    ldr x1, tmp_float
    bl printf

    adr x0, fmt_stampa_float
    ldr x1, tmp_float
    scvtf d0, x1
    bl printf

    ldr x19, tmp_float
    bl binario
    adr x0, fmt_stampa_separatore
    bl printf

    b fine_loop

    skip_no_decimale:

    cmp w0, #1
    bne skip_no_float
    scan_float fmt_scan_float
    
    adr x0, fmt_stampa_deci
    ldr d0, tmp_float
    fcvtzs x1, d0
    bl printf

    adr x0, fmt_stampa_esa
    ldr d0, tmp_float
    fcvtzs x1, d0
    bl printf

    adr x0, fmt_stampa_float
    ldr d0, tmp_float
    bl printf

    ldr d0, tmp_float
    fcvtzs x19, d0
    bl binario
    adr x0, fmt_punto
    bl printf
    bl binariodecimale

    adr x0, fmt_stampa_separatore
    bl printf

    skip_no_float:



   

fine_loop:



    mov w0, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
.size main, (. - main)

.type binario, %function
binario:
    mov x20, x19
    mov x21, 2

    ricorsione:
    stp x29, x30, [sp, #-16]!
    str x19, [sp, #-8]!
        cmp x20, #1
        beq caso_base

        udiv x1, x20, x21
        msub x19, x1, x21, x20
        mov x20, x1
        bl ricorsione

        adr x0, fmt_stampa_bin
        mov x1, x19
        bl printf

        b endbinario




    caso_base:
        adr x0, fmt_stampa_bin1
        mov x1, 1
        bl printf

    endbinario:
    ldr x19, [sp], #8
    ldp x29, x30, [sp], #16
    ret   
.size binario, (. - binario) 


.type binariodecimale, %function
binariodecimale:
    stp x29, x30, [sp, #-16]!

    ldr d19, tmp_float
    fcvtzs x1, d19
    scvtf d1, x1
    fsub d19, d19, d1
    mov x1, 2
    scvtf d20, x1

    loopbindec:
    fcmp d19, #0.0
    beq endloopbindec

    fmul d19, d19, d20
    fmov d0, d19
    fcvtzs x1, d0
    adr x0, fmt_stampa_bin
    bl printf

    fcvtzs x1, d19
    scvtf d1, x1
    fsub d19, d19, d1

    b loopbindec

    endloopbindec:
    ldp x29, x30, [sp], #16
    ret   
.size binariodecimale, (. - binariodecimale) 
