.text
##### func void delete_new_line (text address, max size) ######
# Entradas:
# $a0 - text adress
# $a1 - max size
# Variables locales:
# $t0 - palabra o byte a verificar si tiene un salto de linea
# $t1 - contador para recorrer la palabra que tiene el salto de linea byte a byte

delete_new_line:
	add $a1, $a1, -4
	add $a0, $a0, $a1

	# Primer ciclo que encuentra la ultima 
	# palabra diferente de null en el espacio
	# reservado inicando desde el final del espacio
	while:	
		beq $a1, $zero, end_delete_new_line # Verificar si se recorrieron todas las palabras
		lw $t0, 0($a0)
		addi $a0, $a0, -4
		addi $a1, $a1, -4 
		beq $t0, $zero, while								# Verifcar si la palabra es igual a null
		addi $a0, $a0, 4

	# Segundo ciclo que encuentra el caracter
	# de salto de linea en la palabra
	while2:
		lb $t0, 0($a0)
		addi $t1, $t1, 1
		addi $a0, $a0, 1
		bne $t0, 10, while2									# Verficar si el caracter actual es el salto de linea
	delete:
		addi $a0, $a0, -1
		sb $zero, 0($a0)

end_delete_new_line:
	jr $ra	
