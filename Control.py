import serial
import socket

# Seri port ayarları
ser = serial.Serial(
    port='COM9',      # Seri portunuzu buraya girin (Windows'ta "COMx" gibi)
    baudrate=57600,    # Baud hızınızı buraya girin (FPGA'den gönderilen hızla eşleşmelidir)
    timeout=0
    # Seri veri beklerken timeout süresi
)

# Soket ayarları
server_ip = "192.168.137.251"  # Raspberry Pi'nin IP adresi
server_port = 12345             # Raspberry Pi'de dinlenecek port numarası
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect((server_ip, server_port))

try:
    while True:
        # Seriden veri oku
        data = ser.read(1)
        if data:
            last_character_hex = data[-1]

            if last_character_hex == b'\x01':
                data_to_send = '1'
            elif last_character_hex == b'\x02':
                data_to_send = '2'
            elif last_character_hex == b'\x03':
                data_to_send = '3'
            elif last_character_hex == b'\x04':
                data_to_send = '4'
            else:
                data_to_send = str(last_character_hex)

            # Veriyi Raspberry Pi'ye gönder
            client_socket.sendall(data_to_send.encode())

except KeyboardInterrupt:
    # Ctrl+C'ye basıldığında programı kapat
    ser.close()
    client_socket.close()
    print("Program sonlandırıldı.")