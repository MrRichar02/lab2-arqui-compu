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
addi $a1, $zero, 25
li $v0, 8
syscall

addi $a0, $a0, 28
while:	
	lw $s0, 0($a0)
	addi $a0, $a0, -4
	beq $s0, $zero, while
	addi $a0, $a0, 4
	
	addi $s2, $s2, 4
while2:	
	beq $s2, 0, switch1
	beq $s2, 1, switch2
	beq $s2, 2, switch3
	beq $s2, 3, switch4
switch1:
	srl $s1, $s0, 24
	j end_switch
switch2:
	sll $s1, $s0, 8
	srl $s1, $s1, 24
	j end_switch
switch3:
	sll $s1, $s0, 16
	srl $s1, $s1, 24
	j end_switch
switch4:
	sll $s1, $s0, 24
	srl $s1, $s1, 24
	j end_switch 
end_switch:
	addi $s2, $s2, -1  	
	bne $s1, 10 , while2   

add $s0, $a0, $s2
sb $zero, 0($s0)
	
 	
	
	
	

