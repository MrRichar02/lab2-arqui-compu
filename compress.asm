.text
####### func compress (address space reserved, address content, size ) ######
# Entradas:
# $a0 - buffer reservado para el contenido comprimido
# $a1 - dirección base del contenido a comprimir
# $a2 - tamaño del contenido a comprimir

# Variables locales:
# $t0 - contador caracteres, máximo 255
# $t1 - primer caracter a comparar
# $t2 - segundo caracter a comparar
# $t3 - copia de $a0 (buffer reservado para el contenido comprimido)

# Salidas:
# $v0 - número de caracteres resultado de la compresión

func_compress:
	move $t3, $a0
	li $t0, 0
	while_compress:
		beq $a2, $zero, end_func_compress		# Comprobar si ya se recorrieron todos los caracteres

		addi $t0, $t0, 1

		# Cargar el caracter actual y el siguiente
		# contra el que se va a comparar
		lb $t1, 0($a1)
		lb $t2, 1($a1)

		addi $a1, $a1, 1
		addi $a2, $a2, -1

		beq $t0, 255, store_tupla						# Verficar si el contador de caracteres llego al valor máximo 
		beq $t1, $t2, while_compress				# Verificar si el caracter actual y el siguiente son iguales

		store_tupla:
			# Guardar en memoria la tupla de contador 
			# de caracteres y caracter
			sb $t0, 0($a0)
			sb $t1, 1($a0)

			addi $a0, $a0, 2
			li $t0, 0
		j while_compress
end_func_compress:
	sub $v0, $a0, $t3
	jr $ra
