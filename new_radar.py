import socket
import serial

# Seri port ayarları
ser = serial.Serial(
    port='/dev/ttyACM1',  # Arduino'nun bağlı olduğu seri port
    baudrate=57600,         # Arduino ile aynı baud hızı
    timeout=0
)

# Soket ayarları
server_ip = "0.0.0.0"  # Raspberry Pi'nin IP adresi veya "0.0.0.0" tüm arayüzleri dinler
server_port = 12345    # Raspberry Pi'de dinlenecek port numarası
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((server_ip, server_port))
server_socket.listen(1)

print("Raspberry Pi TCP server. Bekleniyor...")

try:
    while True:
        # Bağlantıyı kabul et
        client_socket, client_address = server_socket.accept()
        print("From:", client_address)

        while True:
            # Client'tan veri al
            data = client_socket.recv(1024)
             # Veri alınmadığında döngüyü kır

            # Seri porta veri gönder
            ser.write(data)

        # Bağlantıyı kapat
        client_socket.close()

except KeyboardInterrupt:
    # Ctrl+C'ye basıldığında programı kapat
    ser.close()
    server_socket.close()
    print("Program sonlandırıldı.")