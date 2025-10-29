.data

success: .asciiz "\nCompresión exitosa con un ratio aproximado de: "
form_rate: ":1"
fail: .asciiz "\nCompresión no efectiva, archivo resultante más grande que el original"

.text
####### func calculate_compress_rate (size original text, size compressed content ) ######
# Entradas:
# $a0 - tamaño del archivo original 
# $a1 - tamaño del archivo comprimido

# Variables locales:
# $t0 - ratio de compresión
# $f0 copia en punto flotante de $a0
# $f2 copia en punto flotante de $a1
# $f12 resutado de la división $f0/$f2


compress_rate:
	# Se envian las entradas a los registros
	# de punto flotante en la pestaña de Coproc 1
	mtc1 $a0, $f0
	mtc1 $a1, $f2

	div.s $f12, $f0, $f2					# Se guarda el resultado de la disión en el registro f12 para facilitar el syscall
	
	blt $a0, $a1, compress_fail		# Verificar si el tamaño del archivo orignal es menor que comprimido
	
	li $v0, 4
	la $a0,  success
	syscall
	j print_rate

	compress_fail:
		la $a0, fail
		li $v0, 4
		syscall
		j end_compress_rate

	print_rate:
		# Imprimir el resutado de la división
		li $v0, 2
		syscall
		la $a0,  form_rate
		li $v0, 4
		syscall

end_compress_rate:
	jr $ra
