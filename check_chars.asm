####### func check_chars ( Address file to compress, size of file)
# entradas:
# a0 direccion archivo a verficar
# a1 tamaño del archivo a verificar

# Salidas:
# v0 = 1 todos los caracteres son validos 
# v0 = -1 se encontro un caracter invalido 

# Version 1
# Variables:
# t0: byte actual a verificar
# t1: alacena el resultado para comprobar si la direccion del byte actual es multiplo de 4 o no
check_chars_v1:
	ble $a1, $zero, good_end_chars_v1
	lbu $t0, 0($a0)
	addi $a0, $a0, 1
	subi $a1, $a1, 1
	bgt $t0, 0x7e, error_check_chars_v1
	bgt $t0, 0x1F, check_chars_v1
	beq $t0, 10, check_chars_v1
	beq $t0, 0, case_null_chars_v1
				
	j error_check_chars_v1

case_null_chars_v1:
	subi $a0, $a0, 1
	andi $t1, $a0, 0xFF
	addi $a0, $a0, 1
	bne $t1, $zero, check_chars_v1
	j error_check_chars_v1
	
good_end_chars_v1:
	li $v0, 1
	j end_check_chars_v1

error_check_chars_v1:
	li $v0, 4
	la $a0, invalidad_char_error
	syscall
	li $v0, -1

end_check_chars_v1:
	jr $ra

# Version 2
# variables:
# t0: En este se va guardando el valor de cada palabra 
# t1: Contador utlizado para recorrer los 4 caracteres de la palabra acutal
# t2: En este se van almacenando los caracteres de cada palabra 
# t3: Contador de valores nulos, se usa para permitir casos donde no se llena completamente el ultimo bloque 
check_chars_v2:
	ble $a1, $zero, good_end_chars_v2
	lw $t0, 0($a0)
	li $t1, 0  # Inicializar el contador para recorrer los caracteres en 0
	
	for_chars_v2:
		# beq $t3, 4, error_chars_v2
		beq $t1, 32, end_for_chars_v2
		srlv $t2, $t0, $t1
		andi $t2, $t2, 0xFF
		
		addi, $t1, $t1, 8
		
		bgt $t2, 0x7e, error_chars_v2
		bgt $t2, 0x1F, for_chars_v2
		beq $t2, 0x0a, for_chars_v2
		beq $t2, 0x0d, for_chars_v2
				
		beq $t2, $zero, case_null_chars_v2
		
		j error_chars_v2
		
		case_null_chars_v2:
			bne $t0, $zero, end_for_chars_v2
			j error_chars_v2
		
	end_for_chars_v2:
		addi $a0, $a0, 4
		subi, $a1, $a1, 4
		j check_chars_v2
		
	good_end_chars_v2:
		li $v0, 1
		j end_check_chars_v2

	error_chars_v2:
		li $v0, 4
		la $a0, invalidad_char_error
		syscall
		li $v0, -1

end_check_chars_v2:
	jr $ra