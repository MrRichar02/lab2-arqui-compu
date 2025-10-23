.data 

message_not_found: .asciiz "El archivo no fue encontrado"
message_too_big: .asciiz "El archivo supera el máximo permitido 4Kib"
message_empty: .asciiz "El archivo está vacío"

.text

################
# Función: Read_file
# Utilidad: Intenta abrir y leer el archivo especificado por el usuario
# Entradas: 
# $a0: dirección de un string que corresponde al nombre del archivo
# $a1: dirección del inicio de un spacio reservado para almacenar el contenido del archivo
# $a2: tamaño máximo permitido de lectura
# Salidas:
# $v0 = "(tamaña de la lectura), Lectura exitosa" o "(-1), lectura no exitosa, vacía, o muy grande"
# Variables:
# $t0: File descriptor
# $t1: Tamaño del archivo leido o error (-1)
# $t2: Dirección del espacio donde se almacenara el contenido leido del archivo 
read_file:
	move $t2, $a1
	
	# Abrir el archivo 
	li $v0, 13
	li $a1, 0	# Bandera de lectura		
	syscall
	
	# Comprobar si el archivo abrió correctamente
	blt $v0, $zero, file_not_found
	
	move $t0, $v0

	# Leer el contenido del archivo
	move $a0, $v0
	li $v0, 14
	move $a1, $t2
	# nota: $a2 ya tiene el número de caracteres a leer
	syscall
	move $t1, $v0
	
	# Comprobar si el archivo esta vacio
	beq $t1, $zero, file_empty
	# Comprobar si el archivo sobrepasa el tamaño limite 
	beq $t1, $a2, file_too_big
	
	j close_file
	
	# Archivo no encontrado
	file_not_found:
		la $a0, message_not_found
		li $v0, 4
		syscall
		li $t1, -1
		j end_read_file	
	# Archivo vacío
	file_empty:
		la $a0, message_empty
		li $v0, 4
		syscall
		li $t1, -1
		j close_file
	# Archivo más grande de lo permitido
	file_too_big:
		la $a0, message_too_big
		li $v0, 4
		syscall
		li $t1, -1
		j close_file
	# Cerrar el archivo 
	close_file:
		li $v0, 16
		move $a0, $t0
		syscall
		

end_read_file:
	move $v0, $t1
	jr $ra
