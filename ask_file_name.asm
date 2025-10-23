.data
message_file_name: .asciiz "Ingrese el nombre del archivo a comprimir (con su extensión).\nMáximo 32 carácteres: "
error_message: .asciiz "\nNombre del archivo más grande del permitido"

.text
################
# Función: Ask_file_name
# Utilidad: Envia un mensaje al usuario para indicarle que digite el nombre del archivo 
# a comprimir y almacena el nombre del archivo 
# Entradas: 
# $a0: dirección del inicio de un spacio reservado para almacenar el nombre del archivo
# $a1: tamaño máximo de la entrada del archivo
# Salidas:
# $v0: flag de error, -1 para error
# Variables:
# $t0: dirección del inicio de un spacio reservado para almacenar el nombre del archivo (copia)
# $t1: últimoo caracter del nombre del archivo
Ask_file_name:
	move $t0, $a0
	# Imprimir mensaje base para pedir el nombre del archivo
	la $a0, message_file_name
	li $v0, 4
	syscall
	
	# Recibir el nombre del archivo del usuario
	li $v0, 8
	addi $a1, $a1, 1
	move $a0, $t0
	syscall
	
	# Validar longitud del nombre del archivo
	lb $t1, 32($t0)
	beq $t1, $zero, name_valid
	la $a0,  error_message
	li $v0, 4
	syscall
	li $v0, -1
	j End_ask_file_name
	
	name_valid:
		li $v0, 1	

End_ask_file_name:	
	jr $ra
