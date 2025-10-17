import os

def read_file(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
    return content, content.__sizeof__()

def write_file(content):
    with open("rle_compress.bin", 'wb') as file:
        file.write(content)

def codify_rle(input_string):
    codified = []
    count = 1
    for i in range(1, len(input_string)):
        if count == 255:
            codified.append((input_string[i - 1], count))
            count = 1
        elif input_string[i] == input_string[i - 1]:
            count += 1
        else:
            codified.append((input_string[i - 1], count))
            count = 1
    codified.append((input_string[-1], count))
    return codified

def checksum(codified_data):
    total = 0
    for char, count in codified_data:
        total += ord(char)  
        total += count
    return format(total, '08x')

def verify_valid_characters(input_string):
    for char in input_string:
        char_code = ord(char)
        if not ((0x20 <= char_code <= 0x7E) or char_code == 0x0A or char_code == 0x0D):
            return False
    return True

def main():
    print("=== Compresor RLE ===")
    
    # Solicitar ruta del archivo
    file_path = input("Ingrese la ruta del archivo a comprimir: ")

    # Leer el archivo
    try:
        content, size = read_file(file_path)
        print(f"Archivo leído exitosamente. Tamaño: {size} bytes")
    except Exception as e:
        print(f"Error al leer el archivo: {e}")
        return
    
    # Verificar que no esté vacío
    if size == 0:
        print("Error: El archivo está vacío.")
        return
    
    # Verificar que no sea mayor a 4 KiB
    if size > 4096:
        print(f"Error: El archivo es demasiado grande ({size} bytes).")
        print("El tamaño máximo permitido es 4 KiB (4096 bytes).")
        return

    
    # Verificar caracteres válidos
    if not verify_valid_characters(content):
        print("Error: El archivo contiene caracteres no válidos.")
        print("Solo se permiten caracteres ASCII imprimibles (0x20-0x7E), LF (0x0A) y CR (0x0D).")
        return
    
    # Codificar con RLE
    codified = codify_rle(content)
    print(f"Datos codificados: {len(codified)} tuplas")
    
    # Calcular checksum
    checksum_value = checksum(codified)
    print(f"Checksum: {checksum_value}")
    
    # Convertir a bytes para escribir
    binary_data = bytearray()
    for char, count in codified:
        binary_data.append(count)  
        binary_data.append(ord(char)) 
        print(f"Agregado al binario: count={count}, char='{char}'")
            
    # Escribir archivo comprimido
    try:
        write_file(bytes(binary_data))
        print(f"Archivo comprimido guardado como 'rle_compress.bin'")
        print(f"Tamaño original: {size} bytes")
        print(f"Tamaño comprimido: {len(binary_data)} bytes")
        
        # Calcular tasa de compresión (tamaño entrada / tamaño salida)
        ratio = size / len(binary_data) 
        
        if ratio < 1:
            print(f"Tasa de compresión: {ratio:.2f}:1")
            print("La compresión NO fue efectiva (el archivo comprimido es más grande).")
        else:
            print(f"Tasa de compresión: {ratio:.2f}:1")
    except Exception as e:
        print(f"Error al escribir el archivo: {e}")

main()
