import socket
import threading
from time import sleep
addr = '192.168.0.10'
port = 8080
UDP = (addr, port)
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
#          -GREEN   -BLUE   -RED
#          -BLUE    -RED    -GREEN
s.sendto(b'\xA0\x01\xA0\x01\xA0\x01\x00', UDP)
sleep(0.9)  # Time in seconds
s.sendto(b'\xA0\x01\xA0\x01\xA0\x01\x01', UDP)
