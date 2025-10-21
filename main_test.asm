.data

text1: .asciiz "ingresa algo:  "
text2: .asciiz "aqui hay un salto"
.align 2
buffer: .space 28


.text

la $a0, text1
li $v0, 4
syscall

la $a0, buffer
addi $a1, $zero, 28
li $v0, 8
syscall

addi $a1, $zero, 28
jal delete_new_line

.include "test2.asm"