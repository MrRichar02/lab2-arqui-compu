####### func compress (address space reserved, address content, size ) ######
# Entradas:
# $a0 - buffer reservado para el contenido comprimido
# $a1 - dirección base del contenido a comprimir
# $a2 - tamaño del contenido a comprimir

# Variables locales:
# $t0 - contador caracteres, máximo 255
# $t1 - primer caracter a comparar
# $t2 - segundo caracter a comparar

func_compress:
	beq $a2, $zero, end_func_compress
	addi $t0, $t0, 1
	lb $t1, 0($a1)
	lb $t2, 1($a1)
	addi $a1, $a1, 1
	addi $a2, $a2, -1
	beq $t0, 255, store_tupla
	beq $t1, $t2, func_compress
	store_tupla:
		sb $t0, 0($a0)
		sb $t1, 1($a0)
		addi $a0, $a0, 2
		li $t0, 0
	j func_compress
end_func_compress:
	jr $ra
