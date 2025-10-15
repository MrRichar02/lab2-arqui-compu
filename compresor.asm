.data
message_file_name:	.asciiz "Ingrese el nombre del archivo a comprimir(con la extensión del archivo): "
file_name:	.space 32
error_message_file_not_found: .asciiz "\nEl archivo especificado no fue encontrado"
error_message_file_too_big: .asciiz "\nEl archivo especificado es demasiado grande uwu"
compressing: .asciiz "\nCompressing aña"
data_to_compress: .space 4097
caracter:	.asciiz "\n"

.text

Main: 	

	# Obtener nombre del archivo
	la $a0, message_file_name
	li $a1, 32
	la $a2, file_name
	jal Ask_file_name

	# Obtener el contenido del archivo del usuario
	move $a0, $v0
	la $a1, data_to_compress
	jal Read_file
	
	bne $v0, $zero, Check_file_size
	li $v0, 4
	la $a0, error_message_file_not_found 
	syscall
	j End_main
	
Check_file_size:
	bgt $v0, $zero, Compress
	li $v0, 4
	la $a0, error_message_file_too_big
	syscall
	j End_main

Compress:
	li $v0, 4
	la $a0, compressing 
	syscall
	
End_main:
	li $v0, 10
	syscall

################
# Función: Ask_file_name
# Utilidad: Envia un mensaje al usuario para indicarle que digite el nombre del archivo 
# a comprimir y almacena el nombre del archivo quitando el salto de linea del final si
# este lo tiene
# Entradas: 
# $a0: dirección de un string terminado en NULL que corresponde al mensaje a mostrar 
# para preguntar por el nombre del archivo
# $a1: tamaño máximo del nombre del archivo
# $a2: dirección del inicio de un spacio reservado para almacenar el nombre del archivo
# Salidas:
# $v0: dirección de un string que corresponde al nombre del archivo
# Variables:
# $t0: Primero es la dirección a un string que contiene el salto de linea, luego obtiene el valor del string
# $t1: Obtiene el valor de todos los bytes que forman parte del nombre de archivo que ingresa el usuario
Ask_file_name:
	# Imprimir mensaje base para pedir el nombre del archivo
	li $v0, 4
	syscall
	
	# Recibir el nombre del archivo del usuario
	li $v0, 8
	move $a0, $a2
	syscall
	
	# Eliminar el salto de linea al final del nombre del archivo si este lo tiene  
	la $t0, caracter
	lb $t0, 0($t0)
		
While:	
	lb $t1, 0($a0)
	addi $a0, $a0, 1
	beq $zero, $t1, End_ask_file_name
	bne $t2, $t1, While
	sb $zero, -1($a0)
	
End_ask_file_name:
	move $v0, $a2	
	jr $ra


################
# Función: Read_file
# Utilidad: Intenta abrir y leer el archivo especificado por el usuario
# Entradas: 
# $a0: dirección de un string que corresponde al nombre del archivo
# $a1: dirección del inicio de un spacio reservado para almacenar el contenido del archivo
# Salidas:
# $v0: dirección del inicio del contenido leido del archivo
# $v0 = 0 Archivo no encontrado
# $v0 = 0 Archivo supera el tamaño máximo
# Variables:
# $t0: File descriptor
# $t1: Tamaño del archivo leido
# $t2: Dirección del espacio donde se alacenara el contenido leido del archivo 
Read_file:
	move $t2, $a1
	
	# Abrir el archivo 
	li $v0, 13
	li $a1, 0	# Bandera de lectura		
	syscall
	
	# Comprobar si el archivo esta vacío
	blt $v0, $zero, Read_file_not_found
	move $t0, $v0

	# Leer el contenido del archivo 
	li $v0, 14
	move $a0, $t0
	move $a1,$t2
	li $a2, 4097
	syscall
	move $t1, $v0
	
	# Comprobar si el archivo sobrepasa el tamaño limite 
	beq $v0, $a2, Read_file_too_big
	
	# Cerrar el archivo
	li $v0, 15
	syscall
	
	move $v0, $t1
	j End_read_file
	

Read_file_too_big:
	# Cerrar el archivo 
	li $v0, 15
	syscall
	li $v0, -1
	j End_read_file

Read_file_not_found:
	li $v0, 0

End_read_file:
	jr $ra
	
	
