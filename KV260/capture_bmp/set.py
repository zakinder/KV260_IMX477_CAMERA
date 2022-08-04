import socket
import threading
addr = '192.168.1.10'
port = 8080
UDP = (addr, port)
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(b'\x00\x00\x00\x00\x07', UDP)