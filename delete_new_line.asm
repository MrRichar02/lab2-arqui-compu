
##### func void delete_new_line (text address, max size) ######
# Entradas:
# $a0 - text adress
# $a1 - max size
# Variables locales:
# $t0 - palabra o byte a verificar si tiene un salto de linea
# $t1 - contador para recorrer la palabra que tiene el salto de linea byte a byte

delete_new_line:
	add $a0, $a0, $a1
	while:	
		beq $a1, $zero, end_delete_new_line # Se utiliza ahora $a1 como criterio de parada
		lw $t0, 0($a0)
		addi $a0, $a0, -4
		addi $a1, $a1, -4 
		beq $t0, $zero, while
	addi $a0, $a0, 4
	while2:
		beq $t1, 4, end_delete_new_line
		lb $t0, 0($a0)
		addi $t1, $t1, 1
		addi $a0, $a0, 1
		bne $t0, 10, while2
	delete:
		addi $a0, $a0, -1
		sb $zero, 0($a0)

end_delete_new_line:
	jr $ra	
 	
	
	
	

