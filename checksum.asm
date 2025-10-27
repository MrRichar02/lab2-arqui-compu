.data
.align 2
mensaje:	.asciiz "El resultado del checksum fue: "

.text
##### func checksum (address contenido comprimido, size) return valor_checksum ####
# Entradas:
# $a0 - dirección base del contenido comprimido
# $a1 - tamaño del array

# Variables Locales v1
# $t0 -  palabra cargada
# $t1 -  primer byte de la palabra cargada
# $t2 -  segundo byte de la palabra cargada
# $t3 -	 tercer byte de la palabra cargada
# $t4 -  cuarto byte de la palabra cargada
# $t5 -  valor acumulado de la suma de bytes
# $t6 -  contador para criterio de parada

# Salidas v1
# $v0 - checksum calculado

func_checksum_v1:
	bge $t6,$a1, end_func_checksum_v1		# Verificar si ya se recorrieron todas las palabras
	lw $t0, 0($a0)

	# Guardar cada caracter de la palabra actual entre los registros t1 -t4
	andi $t1, $t0, 0xFF
	srl  $t2, $t0, 8
	andi $t2, $t2, 0xFF
	srl  $t3, $t0, 16
	andi $t3, $t3, 0xFF
	srl  $t4, $t0, 24
	andi $t4, $t4, 0xFF
	
	# Añadir la suma de todos los caracteres al registro 5
	add $t5, $t5, $t1
	add $t5, $t5, $t2
	add $t5, $t5, $t3
	add $t5, $t5, $t4

	addi $a0, $a0, 4
	addi $t6, $t6, 4
	j func_checksum_v1
end_func_checksum_v1:

	li $v0, 4
	la $a0, mensaje
	syscall

	# Mostar el resultado del checksum usando el syscall 34 para el formato
	li $v0 34
	move $a0, $t5
	syscall

	move $v0, $t5 
	
	jr $ra
	
# Variables Locales v2
# $t0 -  byte cargadoo
# $t1 -  valor acumulado de la suma de bytes
# $t2 -  contador para criterio de parada

# Salidas v2
# $v0 - checksum calculado

func_checksum_v2:
	li $t1, 0
while_checksum_v2:
	beq $t2,$a1, end_func_checksum_v2		# Verificar si ya se recorrieron todos los caracteres
	
	# Sumar el valor de cada caracter
	# al registro t1
	lb $t0, 0($a0)
	add $t1, $t1, $t0
	addi $a0, $a0, 1
	addi $t2, $t2, 1
	j while_checksum_v2
end_func_checksum_v2:
	li $v0, 4
	la $a0, mensaje
	syscall

	# Mostar el resultado del checksum usando el syscall 34 para el formato
	li $v0 34
	move $a0, $t1
	syscall

	move $v0, $t1 
	
	jr $ra
	move $v0, $t1
	jr $ra
