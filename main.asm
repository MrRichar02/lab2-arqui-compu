.data
file_name:	.space 33
.align 2
data_to_compress: .space 4097
.align 2
data_compress: .space 8192
error_message_main:  .asciiz "\n------Error del usuario, ejecute otra vez.--------"
output_file_name:	.asciiz "rle_compress.bin"



.text

Main: 	

	# Obtener nombre del archivo - func Ask_file_name()
	la $a0, file_name  # Entrada 1
	li $a1, 33         # Entrada 2  
	jal Ask_file_name  # Llamado a la función
	
	beq $v0, -1, main_error
	
	# Limpiar el nombre del archivo - func delete_new_line()
	la $a0, file_name   # Entrada 1
	li $a1, 32          # Entrada 2  
	jal delete_new_line # Llamado a la función
	
	# Abrir y leer el archivo - func read_file()
	la $a0, file_name	 # Entrada 1
	la $a1, data_to_compress # Entrada 2
	li $a2, 4097             # Entrada 3
	jal read_file		 # Llamado a la función
	
	beq $v0, -1, main_error
	
	move $s0, $v0 # Variable global - Tamaño del texto leido
	
	# Comprobar carácteres - func check_chars()
	la $a0, data_to_compress # Entrada 1
	move $a1, $s0		 # Entrada 2
	jal check_chars_v1	 # Llamado a la función
	
	beq $v0, -1, main_error
	
	# Comprimir 
	la $a0, data_compress    # Entrada 1
	la $a1, data_to_compress # Entrada 2
	move $a2, $s0		 # Entrada 3
	jal compress	 # Llamado a la función
	
	move $s1, $v0            # Guardar el valor de caracteres resultante de la compresión
	
	# Escribir archivo comprimido
	la $a0, output_file_name	# Entrada 1 
	la $a1, data_compress		# Entrada 2
	move $a2, $s1			# Entrada 3
	jal write_file		# Llamado a la funcion
	
	# Checksum 
	la $a0, data_compress	# Entrada 1
	move $a1, $s1		# Entrada 2
	jal checksum_v2	# Llamado a la funcion
	
	# Radio de comprension func calculate_compress_rate()
	move $a0, $s0			# Entrada 1
	move $a1, $s1			# Entrada 2
	jal  compress_rate	# Llamado a la funcion
	
	j End_main
	
	main_error:
		la $a0, error_message_main
		li $v0, 4
		syscall
		
End_main:
	li $v0, 10
	syscall


#imports
.include "ask_file_name.asm"
.include "delete_new_line.asm"
.include "read_file.asm"
.include "check_chars.asm"
.include "compress.asm"
.include "write_file.asm"
.include "checksum.asm"
.include "compress_rate.asm"
