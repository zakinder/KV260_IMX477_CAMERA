from tkinter import *
import socket
import threading
from time import sleep




addr = '192.168.0.10'
port = 8080
UDP = (addr, port)
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
#          -GREEN   -BLUE   -RED
#          -BLUE    -RED    -GREEN




class MyWindow:
    def __init__(self, win):

        self.LABEL_1=Label(win, text='BLUE')
        self.LABEL_2=Label(win, text='RED_MSB')
        self.LABEL_3=Label(win, text='GREEN_MSB')

    
    
    
        self.LABEL_4=Label(win, text='CONTROL')
        self.LABEL_5=Label(win, text='DELAY')
        
        self.LABEL_6=Label(win, text='REG11')
        self.LABEL_7=Label(win, text='REG12')
        self.LABEL_8=Label(win, text='REG13')
        self.LABEL_9=Label(win, text='REG14')
        self.LABEL10=Label(win, text='REG15')
        self.LABEL11=Label(win, text='REG16')
        self.LABEL12=Label(win, text='REG17')
        self.LABEL13=Label(win, text='IMX477')
        self.LABEL14=Label(win, text='IMAGE-NAME')
        self.LABEL15=Label(win, text='IMX477-A')
        self.LABEL16=Label(win, text='IMX477-D')
        
        self.LABEL_4_ENTER=Entry()
        self.LABEL_4_ENTER.insert(0, "4")
        self.LABEL_5_ENTER=Entry()
        self.LABEL_5_ENTER.insert(0, "0")
        self.LABEL_6_ENTER=Entry()
        self.LABEL_6_ENTER.insert(0, "15")
        self.LABEL_7_ENTER=Entry()
        self.LABEL_7_ENTER.insert(0, "0")
        self.LABEL_8_ENTER=Entry()
        self.LABEL_8_ENTER.insert(0, "0")
        self.LABEL_9_ENTER=Entry()
        self.LABEL_9_ENTER.insert(0, "0")
        self.LABEL10_ENTER=Entry()
        self.LABEL10_ENTER.insert(0, "8")
        self.LABEL11_ENTER=Entry()
        self.LABEL11_ENTER.insert(0, "0")
        self.LABEL12_ENTER=Entry()
        self.LABEL12_ENTER.insert(0, "0")
        self.LABEL13_ENTER=Entry()
        self.LABEL13_ENTER.insert(0, "3")
        
        self.LABELA15_ENTER_MSB=Entry(width=4)
        self.LABELA15_ENTER_MSB.insert(0, "020")
        self.LABELB15_ENTER_LSB=Entry(width=4)
        self.LABELB15_ENTER_LSB.insert(0, "011")
        
        self.LABELA16_ENTER_MSB=Entry(width=4)
        self.LABELA16_ENTER_MSB.insert(0, "020")
        self.LABELB16_ENTER_LSB=Entry(width=4)
        self.LABELB16_ENTER_LSB.insert(0, "011")
        
        self.LABELA1_ENTER_MSB=Entry(width=4)
        self.LABELA1_ENTER_MSB.insert(0, "020")
        self.LABELA1_ENTER_LSB=Entry(width=4)
        self.LABELA1_ENTER_LSB.insert(0, "011")
        self.LABELB1_ENTER_MSB=Entry(width=4)
        self.LABELB1_ENTER_MSB.insert(0, "030")
        self.LABELB1_ENTER_LSB=Entry(width=4)
        self.LABELB1_ENTER_LSB.insert(0, "000")
        self.LABELC1_ENTER_MSB=Entry(width=4)
        self.LABELC1_ENTER_MSB.insert(0, "030")
        self.LABELC1_ENTER_LSB=Entry(width=4)
        self.LABELC1_ENTER_LSB.insert(0, "000")
        
        
        
        
        self.LABELA2_ENTER_MSB=Entry(width=4)
        self.LABELA2_ENTER_MSB.insert(0, "030")
        self.LABELA2_ENTER_LSB=Entry(width=4)
        self.LABELA2_ENTER_LSB.insert(0, "000")
        self.LABELB2_ENTER_MSB=Entry(width=4)
        self.LABELB2_ENTER_MSB.insert(0, "020")
        self.LABELB2_ENTER_LSB=Entry(width=4)
        self.LABELB2_ENTER_LSB.insert(0, "011")
        self.LABELC2_ENTER_MSB=Entry(width=4)
        self.LABELC2_ENTER_MSB.insert(0, "030")
        self.LABELC2_ENTER_LSB=Entry(width=4)
        self.LABELC2_ENTER_LSB.insert(0, "000")
        
        
        self.LABELA3_ENTER_MSB=Entry(width=4)
        self.LABELA3_ENTER_MSB.insert(0, "030")
        self.LABELA3_ENTER_LSB=Entry(width=4)
        self.LABELA3_ENTER_LSB.insert(0, "000")
        self.LABELB3_ENTER_MSB=Entry(width=4)
        self.LABELB3_ENTER_MSB.insert(0, "030")
        self.LABELB3_ENTER_LSB=Entry(width=4)
        self.LABELB3_ENTER_LSB.insert(0, "000")
        self.LABELC3_ENTER_MSB=Entry(width=4)
        self.LABELC3_ENTER_MSB.insert(0, "020")
        self.LABELC3_ENTER_LSB=Entry(width=4)
        self.LABELC3_ENTER_LSB.insert(0, "011")
        self.TXT_ENTER_LSB=Entry(width=20, text="label")
        
        
        self.LABEL_4.place(x=50, y=25)
        self.LABEL_4_ENTER.place(x=200, y=25)
        
        self.LABEL_5.place(x=50, y=50)
        self.LABEL_5_ENTER.place(x=200, y=50)
        
        self.LABEL_1.place(x=50, y=75)
        self.LABELA1_ENTER_MSB.place(x=200, y=75)
        self.LABELA1_ENTER_LSB.place(x=230, y=75)
        self.LABELB1_ENTER_MSB.place(x=300, y=75)
        self.LABELB1_ENTER_LSB.place(x=330, y=75)
        self.LABELC1_ENTER_MSB.place(x=400, y=75)
        self.LABELC1_ENTER_LSB.place(x=430, y=75)
        
        self.LABEL_2.place(x=50, y=100)
        self.LABELA2_ENTER_MSB.place(x=200, y=100)
        self.LABELA2_ENTER_LSB.place(x=230, y=100)
        self.LABELB2_ENTER_MSB.place(x=300, y=100)
        self.LABELB2_ENTER_LSB.place(x=330, y=100)
        self.LABELC2_ENTER_MSB.place(x=400, y=100)
        self.LABELC2_ENTER_LSB.place(x=430, y=100)
        
        self.LABEL_3.place(x=50, y=125)
        self.LABELA3_ENTER_MSB.place(x=200, y=125)
        self.LABELA3_ENTER_LSB.place(x=230, y=125)
        self.LABELB3_ENTER_MSB.place(x=300, y=125)
        self.LABELB3_ENTER_LSB.place(x=330, y=125)
        self.LABELC3_ENTER_MSB.place(x=400, y=125)
        self.LABELC3_ENTER_LSB.place(x=430, y=125)
        
        self.LABEL_6.place(x=50, y=150)
        self.LABEL_6_ENTER.place(x=200, y=150)
        self.LABEL_7.place(x=50, y=175)
        self.LABEL_7_ENTER.place(x=200, y=175)
        self.LABEL_8.place(x=50, y=200)
        self.LABEL_8_ENTER.place(x=200, y=200)
        self.LABEL_9.place(x=50, y=225)
        self.LABEL_9_ENTER.place(x=200, y=225)
        self.LABEL10.place(x=50, y=250)
        self.LABEL10_ENTER.place(x=200, y=250)
        self.LABEL11.place(x=50, y=275)
        self.LABEL11_ENTER.place(x=200, y=275)
        self.LABEL12.place(x=50, y=300)
        self.LABEL12_ENTER.place(x=200, y=300)
        self.LABEL13.place(x=50, y=325)
        self.LABEL13_ENTER.place(x=200, y=325)
        self.LABEL14.place(x=50, y=350)
        self.TXT_ENTER_LSB.place(x=200, y=350)

        self.LABEL15.place(x=50, y=375)
        self.LABELA15_ENTER_MSB.place(x=200, y=375)
        self.LABELB15_ENTER_LSB.place(x=230, y=375)

        self.LABEL16.place(x=50, y=400)
        self.LABELA16_ENTER_MSB.place(x=200, y=400)
        self.LABELB16_ENTER_LSB.place(x=230, y=400)
        
        
        self.b1=Button(win, text='Update', command=self.add)
        self.b1.place(x=50, y=425)



    def add(self):
        control_reg =int(self.LABEL_4_ENTER.get()).to_bytes(1, 'big')
        delay_reg   =int(self.LABEL_5_ENTER.get()).to_bytes(1, 'big')
        a1_reg      =int(self.LABELA1_ENTER_MSB.get()).to_bytes(1, 'big')
        a2_reg      =int(self.LABELA1_ENTER_LSB.get()).to_bytes(1, 'big')
        a3_reg      =int(self.LABELB1_ENTER_MSB.get()).to_bytes(1, 'big')
        a4_reg      =int(self.LABELB1_ENTER_LSB.get()).to_bytes(1, 'big')
        a5_reg      =int(self.LABELC1_ENTER_MSB.get()).to_bytes(1, 'big')
        a6_reg      =int(self.LABELC1_ENTER_LSB.get()).to_bytes(1, 'big')
        a7_reg      =int(self.LABELA2_ENTER_MSB.get()).to_bytes(1, 'big')
        a8_reg      =int(self.LABELA2_ENTER_LSB.get()).to_bytes(1, 'big')
        a9_reg      =int(self.LABELB2_ENTER_MSB.get()).to_bytes(1, 'big')
        a10_reg     =int(self.LABELB2_ENTER_LSB.get()).to_bytes(1, 'big')
        a11_reg     =int(self.LABELC2_ENTER_MSB.get()).to_bytes(1, 'big')
        a12_reg     =int(self.LABELC2_ENTER_LSB.get()).to_bytes(1, 'big')
        a13_reg     =int(self.LABELA3_ENTER_MSB.get()).to_bytes(1, 'big')
        a14_reg     =int(self.LABELA3_ENTER_LSB.get()).to_bytes(1, 'big')
        a15_reg     =int(self.LABELB3_ENTER_MSB.get()).to_bytes(1, 'big')
        a16_reg     =int(self.LABELB3_ENTER_LSB.get()).to_bytes(1, 'big')
        a17_reg     =int(self.LABELC3_ENTER_MSB.get()).to_bytes(1, 'big')
        a18_reg     =int(self.LABELC3_ENTER_LSB.get()).to_bytes(1, 'big')
        a20_reg     =int(self.LABEL_6_ENTER.get()).to_bytes(1, 'big')
        a21_reg     =int(self.LABEL_7_ENTER.get()).to_bytes(1, 'big')
        a22_reg     =int(self.LABEL_8_ENTER.get()).to_bytes(1, 'big')
        a23_reg     =int(self.LABEL_9_ENTER.get()).to_bytes(1, 'big')
        a24_reg     =int(self.LABEL10_ENTER.get()).to_bytes(1, 'big')
        a25_reg     =int(self.LABEL11_ENTER.get()).to_bytes(1, 'big')
        a26_reg     =int(self.LABEL12_ENTER.get()).to_bytes(1, 'big')
        a27_reg     =int(self.LABEL13_ENTER.get()).to_bytes(1, 'big')
        
        a28_reg     =int(self.LABELA15_ENTER_MSB.get()).to_bytes(1, 'big')
        a29_reg     =int(self.LABELB15_ENTER_LSB.get()).to_bytes(1, 'big')
        a30_reg     =int(self.LABELA16_ENTER_MSB.get()).to_bytes(1, 'big')
        a31_reg     =int(self.LABELB16_ENTER_LSB.get()).to_bytes(1, 'big')
        
        print("tx")
        file = open(self.TXT_ENTER_LSB.get()+'.bmp',"wb");
        count = 0
        s.sendto(b"".join([control_reg,a1_reg,a2_reg,a3_reg,a4_reg,a5_reg,a6_reg,a7_reg,a8_reg,a9_reg,a10_reg,a11_reg,a12_reg,a13_reg,a14_reg,a15_reg,a16_reg,a17_reg,a18_reg,delay_reg,a20_reg,a21_reg,a22_reg,a23_reg,a24_reg,a25_reg,a26_reg,a27_reg,a28_reg,a29_reg,a30_reg,a31_reg]), UDP)
window=Tk()
mywin=MyWindow(window)
window.title('Config Camera')
window.geometry("500x500+10+10")
window.mainloop()