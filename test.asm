.data
mensaje: .asciiz "Ingresa algo"
mensaje1: .space 25

.text

main:
la $a0, mensaje
li $v0, 4
syscall

la $a0, mensaje1
li $v0, 8
syscall

lw $s0, 100($a0)


