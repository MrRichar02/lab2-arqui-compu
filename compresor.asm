
.data
mensaje_pedir_archivo:	.asciiz "Ingrese el nombre del archivo a comprimir(con la extensión del archivo): "
nombre_archivo_comprimir: .space 32
error_message_file_not_found: .asciiz "\nEl archivo especificado no fue encontrado"
contenido_archivo_lectura: .space 4096
caracter:	.asciiz "\n"

.text

Main: 	
	# Obtener el contenido del archivo del usuario
	jal Leer_archivo
	
	

End_main:
	li $v0, 10
	syscall



Leer_archivo:
	# Print message to indicate the user to write file name 
	li $v0, 4
	la $a0, mensaje_pedir_archivo
	syscall
	
	# Recive user's file name
	li $v0, 8
	la $a0, nombre_archivo_comprimir
	li $a1, 32
	syscall
	
	# Delete \n from end of file 
	la $t0, nombre_archivo_comprimir
	la $t2, caracter
	lb $t2, 0($t2)
		
While:	
	lb $t1, 0($t0)
	addi $t0, $t0, 1
	beq $zero, $t1, End_while
	bne $t2, $t1, While
	sb $zero, -1($t0)

End_while:
	# Open file provided by user on readmode
	li $v0, 13
	la $a0, nombre_archivo_comprimir
	li $a1, 0
	syscall
	
	# Manage open file error 
Error_file_not_found:
	bgt $v0, $zero, Read_file_content
	li $v0, 4
	la $a0, error_message_file_not_found 
	syscall
	j End_main
	
Read_file_content:
	# Reading content from the opened file 
	move $t0, $v0
	li $v0, 14
	move $a0, $t0
	la $a1, contenido_archivo_lectura
	li $a2, 4096
	syscall
	move $t1, $v0
	
	#close opened file
	li $v0, 15
	move $a0, $t0
	syscall
	
	move $v0, $t1
	
	jr $ra
	
	
