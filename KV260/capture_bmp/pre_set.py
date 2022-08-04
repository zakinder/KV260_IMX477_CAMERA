import socket
import struct
import ctypes
import threading
import numpy as np
IMG_W = 1920
IMG_H = 1080
framelen = IMG_H*IMG_W*4
UDP_IP = "0.0.0.0"
UDP_PORT = 8080
sock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
sock.bind(('', UDP_PORT))
file = open('test.bmp',"wb");
while True:
    msg = sock.recvfrom(framelen)[0]
    file.write(msg);