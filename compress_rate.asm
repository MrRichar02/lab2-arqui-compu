.data

success: .asciiz "Compresión exitosa con un ratio aproximado de: "
compress_rate: .space 1
form_rate: ":1"
fail: .asciiz "Compresión no efectiva, archivo resultante más grande que el original"

.text

####### func calculate_compress_rate (size original text, size compressed content ) ######
# Entradas:
# $a0 - size original text
# $a1 - size compressed content

# Variables locales:
# $t0 - ratio de compresión


calculate_compress_rate:
	div $a0, $a1
	mflo $t0
	sb $t0, compress_rate
	blt $t0, 1, compress_fail
	la $a0,  success
	li $v0, 4
	syscall
	j print_rate
	compress_fail:
		la $a0, fail
		li $v0, 4
		syscall
		j end_calculate_compress_rate
	print_rate:
		move $a0, $t0
		li $v0, 1
		syscall
		la $a0,  form_rate
		li $v0, 4
		syscall
end_calculate_compress_rate:
	jr $ra
	
	
	
	