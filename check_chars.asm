####### func check_chars ( Address file to compress, size of file)
# entradas:
# a0 direccion archivo a verficar
# a1 tamaño del archivo a verificar

# variables:
# t0: En este se va guardando el valor de cada palabra 
# t1: Contador utlizado para recorrer los 4 caracteres de la palabra acutal
# t2: En este se van almacenando los caracteres de cada palabra 
# t3: Contador de valores nulos, se usa para permitir casos donde no se llena completamente el ultimo bloque 

# Salidas:
# v0 = 1 todos los caracteres son validos 
# v0 = 0 se encontro un caracter invalido 

check_chars:
	ble $a1, $zero, good_end
	lw $t0, 0($a0)
	li $t1, 0  # Inicializar el contador para recorrer los caracteres en 0
	
	for:
		beq $t3, 4, error
		beq $t1, 32, end_for
		srlv $t2, $t0, $t1
		andi $t2, $t2, 0xFF
		
		addi, $t1, $t1, 8
		
		bgt $t2, 0x7e, error
		bgt $t2, 0x1F, for
		beq $t2, 0x0a, for
		beq $t2, 0x0d, for
		
		beq $t2, $zero, case_null
		
		j error
		
		case_null:
			addi $t3, $t3, 1
			j for
		
	end_for:
		addi $a0, $a0, 4
		subi, $a1, $a1, 4
		j check_chars
		
	good_end:
		li $v0, 1
		j end_check_chars

	error:
		li $v0, -1

end_check_chars:
	jr $ra
