.global main

.section .rodata
mesg1:
    .string "********************************\n"
mesg2:
    .string "*Architettura degli Elaboratori*\n"

.text
main:
    stp     x29, x30, [sp, #-16]!
    
    /* 
    * load e print mesg1
    * load e print mesg2            Commento 1 (multilinea)
    * load e print mesg1
    */

    adr     x0, mesg1
    bl      printf
    adr     x0, mesg2
    bl      printf
    adr     x0, mesg1
    bl      printf

    // return 0                     Commento 2 (linea singola)
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
