##### func checksum (address contenido comprimido, size) return valor_checksum ####
# Entradas:
# $a0 - dirección base del contenido comprimido
# $a1 - tamaño del array


.data
.align 2
bytes_prueba: .byte 1, 2, 3, 4, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120

.text
la $a0, bytes_prueba
li $a1, 16

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
	beq $t6,$a1, end_func_checksum_v1
	lw $t0, 0($a0)
	andi $t1, $t0, 0xFF
	srl  $t2, $t0, 8
	andi $t2, $t2, 0xFF
	srl  $t3, $t0, 16
	andi $t3, $t3, 0xFF
	srl  $t4, $t0, 24
	andi $t4, $t4, 0xFF
	add $t5, $t5, $t1
	add $t5, $t5, $t2
	add $t5, $t5, $t3
	add $t5, $t5, $t4
	addi $a0, $a0, 4
	addi $t6, $t6, 4
	j func_checksum_v1
end_func_checksum_v1:
	move $v0, $t5 
	jr $ra
	
# Variables Locales v2
# $t0 -  byte cargadoo
# $t1 -  valor acumulado de la suma de bytes
# $t2 -  contador para criterio de parada

# Salidas v2
# $v0 - checksum calculado

func_checksum_v2:
	beq $t2,$a1, end_func_checksum_v2
	lb $t0, 0($a0)
	add $t1, $t1, $t0
	addi $a0, $a0, 1
	addi $t2, $t2, 1
	j func_checksum_v2
end_func_checksum_v2:
	move $v0, $t1
	jr $ra


	
	