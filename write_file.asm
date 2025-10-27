.text
########### func write file ( address output file, address compressed file, compressed file size)
# Entradas:
# a0: direccion nombre archivo
# a1: direccion archivo comprimido
# a2: tamaño archivo comprimido 

# Variables locales
# t0: copia de la direccion del archivo comprimido
# t1: copia  del file descriptor obtenida al abrir el archivo

func_write_file:
	# Abrir archivo con el flag de escritura
	move $t0, $a1
	li $v0, 13
	li $a1, 1						# Flag de escritura
	syscall
	move $t1, $v0				
	
	# Escribir el contenido comprimido
	li $v0, 15
	move $a0, $t1
	move $a1, $t0
	syscall
	
	# Cerrar el archivo 
	li $v0, 16
	move $a0, $t1
	syscall	
	
	jr $ra
