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
        ######################################## CONTROL
        self.LABEL_4_ENTER=Entry()
        self.LABEL_4_ENTER.insert(0, "2")
        self.LABEL_4=Label(win, text='Control')
        self.LABEL_4.place(x=50, y=25)
        self.LABEL_4_ENTER.place(x=200, y=25)
        ######################################## FRAME DELAY
        self.LABEL_5_ENTER=Entry()
        self.LABEL_5_ENTER.insert(0, "12")
        self.LABEL_5=Label(win, text='Frame Delay')
        self.LABEL_5.place(x=50, y=50)
        self.LABEL_5_ENTER.place(x=200, y=50)
        ######################################## CCM1 BLUE
        self.LABEL_A1_TO_A3=Label(win, text='Blue')
        self.LABEL_A1_TO_A3.place(x=50, y=75)
        self.ENT_A1_VAL=Entry(width=6)
        self.ENT_A1_VAL.insert(0, "1000")
        self.ENT_A1_VAL.place(x=200, y=75)
        self.ENT_A2_VAL=Entry(width=6)
        self.ENT_A2_VAL.insert(0, "0")
        self.ENT_A2_VAL.place(x=250, y=75)
        self.ENT_A3_VAL=Entry(width=6)
        self.ENT_A3_VAL.insert(0, "0")
        self.ENT_A3_VAL.place(x=300, y=75)
        ######################################## CCM1 RED
        self.LABEL_A4_TO_A6=Label(win, text='Red')
        self.LABEL_A4_TO_A6.place(x=50, y=100)
        self.ENT_A4_VAL=Entry(width=6)
        self.ENT_A4_VAL.insert(0, "0")
        self.ENT_A4_VAL.place(x=200, y=100)
        self.ENT_A5_VAL=Entry(width=6)
        self.ENT_A5_VAL.insert(0, "1000")
        self.ENT_A5_VAL.place(x=250, y=100)
        self.ENT_A6_VAL=Entry(width=6)
        self.ENT_A6_VAL.insert(0, "0")
        self.ENT_A6_VAL.place(x=300, y=100)
        ######################################## CCM1 GREEN
        self.LABEL_A7_TO_A9=Label(win, text='Green')
        self.LABEL_A7_TO_A9.place(x=50, y=125)
        self.ENT_A7_VAL=Entry(width=6)
        self.ENT_A7_VAL.insert(0, "0")
        self.ENT_A7_VAL.place(x=200, y=125)
        self.ENT_A8_VAL=Entry(width=6)
        self.ENT_A8_VAL.insert(0, "0")
        self.ENT_A8_VAL.place(x=250, y=125)
        self.ENT_A9_VAL=Entry(width=6)
        self.ENT_A9_VAL.insert(0, "1000")
        self.ENT_A9_VAL.place(x=300, y=125)
        #######################
        self.a1=Button(win, text='CCM1', command=self.ccm1)
        self.a1.place(x=400, y=125)
        ############################################################################################
        
        
        
        #self.LABELC2_ENTER_LSB=Entry(width=4)
        #self.LABELC2_ENTER_LSB.insert(0, "000")
        #self.LABELA3_ENTER_MSB=Entry(width=4)
        #self.LABELA3_ENTER_MSB.insert(0, "030")
        #self.LABELA3_ENTER_LSB=Entry(width=4)
        #self.LABELA3_ENTER_LSB.insert(0, "000")
        #self.LABELB3_ENTER_MSB=Entry(width=4)
        #self.LABELB3_ENTER_MSB.insert(0, "030")
        #self.LABELB3_ENTER_LSB=Entry(width=4)
        #self.LABELB3_ENTER_LSB.insert(0, "000")
        #self.LABELC3_ENTER_MSB=Entry(width=4)
        #self.LABELC3_ENTER_MSB.insert(0, "020")
        #self.LABELC3_ENTER_LSB=Entry(width=4)
        #self.LABELC3_ENTER_LSB.insert(0, "011")

        ######################################## REG11
        self.LABEL_6_ENTER=Entry()
        self.LABEL_6_ENTER.insert(0, "15")
        self.LABEL_6=Label(win, text='CCM1 Selection [REG11]')
        self.LABEL_6.place(x=50, y=150)
        self.LABEL_6_ENTER.place(x=200, y=150)
        ######################################## REG12 
        self.LABEL_7_ENTER=Entry()
        self.LABEL_7_ENTER.insert(0, "15")
        self.LABEL_7=Label(win, text='CCM2 Selection [REG12]')
        self.LABEL_7.place(x=50, y=175)
        self.LABEL_7_ENTER.place(x=200, y=175)
        ######################################## REG13
        self.LABEL_8_ENTER=Entry()
        self.LABEL_8_ENTER.insert(0, "15")
        self.LABEL_8=Label(win, text='CCM3 Selection [REG13]')
        self.LABEL_8.place(x=50, y=200)
        self.LABEL_8_ENTER.place(x=200, y=200)
        ######################################## REG14
        self.LABEL_9_ENTER=Entry()
        self.LABEL_9_ENTER.insert(0, "0")
        self.LABEL_9=Label(win, text='RGB Range1 [REG14]')
        self.LABEL_9.place(x=50, y=225)
        self.LABEL_9_ENTER.place(x=200, y=225)
        ######################################## REG15
        self.LABEL10=Label(win, text='Filter Number [REG15]')
        self.LABEL10.place(x=50, y=250)
        self.LABEL10_ENTER=Entry()
        self.LABEL10_ENTER.insert(0, "13")
        self.LABEL10_ENTER.place(x=200, y=250)
        self.LABEL_10=Label(win, text='15:TestPttern,13:rgbYcbcr,12:HSL,5:RAW-RGB')
        self.LABEL_10.place(x=400, y=250)
        ######################################## REG16
        self.LABEL11=Label(win, text='RGB Range2 [REG16]')
        self.LABEL11.place(x=50, y=275)
        self.LABEL11_ENTER=Entry()
        self.LABEL11_ENTER.insert(0, "0")
        self.LABEL11_ENTER.place(x=200, y=275)
        ######################################## REG17
        self.LABEL12_ENTER=Entry()
        self.LABEL12_ENTER.insert(0, "0")
        self.LABEL12=Label(win, text='Localization [REG17]')
        self.LABEL12.place(x=50, y=300)
        self.LABEL12_ENTER.place(x=200, y=300)
        ####################### IMX CAMERA RESOLUTION
        self.LABEL13_ENTER=Entry()
        self.LABEL13_ENTER.insert(0, "3")
        self.LABEL13=Label(win, text='IMX Camera Resolution')
        self.LABEL13.place(x=50, y=325)
        self.LABEL13_ENTER.place(x=200, y=325)
        ####################### IMAGE-NAME
        self.LABEL14_ENTER=Entry(width=20, text="label")
        self.LABEL14_ENTER.place(x=200, y=350)
        self.LABEL14=Label(win, text='IMAGE-Name')
        self.LABEL14.place(x=50, y=350)
        ####################### IMX CAMERA ADDRESS
        self.LABEL15_ENTER=Entry(width=6)
        self.LABEL15_ENTER.insert(0, "516")
        self.LABEL15_ENTER.place(x=200, y=375)
        self.LABEL15=Label(win, text='IMX Camera Address')
        self.LABEL15.place(x=50, y=375)
        ####################### IMX CAMERA DATA
        self.LABEL16_ENTER=Entry(width=6)
        self.LABEL16_ENTER.insert(0, "1")
        self.LABEL16_ENTER.place(x=200, y=400)
        self.LABEL16=Label(win, text='IMX Camera Data')
        self.LABEL16.place(x=50, y=400)
        self.LABEL16=Button(win, text='IMX477', command=self.imx477)
        self.LABEL16.place(x=300, y=400)
        ####################### REG43
        self.LABEL17_ENTER=Entry(width=6)
        self.LABEL17_ENTER.insert(0, "10")
        self.LABEL17=Label(win, text='Color Channel [REG43]')
        self.LABEL17.place(x=50, y=425)
        self.LABEL17_ENTER.place(x=200, y=425)
        self.LABEL17=Button(win, text='REG43', command=self.reg43)
        self.LABEL17.place(x=300, y=425)
        ######################################## CCM2 BLUE
        self.LABEL_B1_TO_B3=Label(win, text='Blue')
        self.LABEL_B1_TO_B3.place(x=50, y=450)
        self.ENT_B1_VAL=Entry(width=6)
        self.ENT_B1_VAL.insert(0, "1000")
        self.ENT_B1_VAL.place(x=200, y=450)
        self.ENT_B2_VAL=Entry(width=6)
        self.ENT_B2_VAL.insert(0, "0")
        self.ENT_B2_VAL.place(x=250, y=450)
        self.ENT_B3_VAL=Entry(width=6)
        self.ENT_B3_VAL.insert(0, "0")
        self.ENT_B3_VAL.place(x=300, y=450)
        ######################################## CCM2 RED
        self.LABEL_B4_TO_B6=Label(win, text='Red')
        self.LABEL_B4_TO_B6.place(x=50, y=475)
        self.ENT_B4_VAL=Entry(width=6)
        self.ENT_B4_VAL.insert(0, "0")
        self.ENT_B4_VAL.place(x=200, y=475)
        self.ENT_B5_VAL=Entry(width=6)
        self.ENT_B5_VAL.insert(0, "1000")
        self.ENT_B5_VAL.place(x=250, y=475)
        self.ENT_B6_VAL=Entry(width=6)
        self.ENT_B6_VAL.insert(0, "0")
        self.ENT_B6_VAL.place(x=300, y=475)
        ######################################## CCM2 GREEN
        self.LABEL_B7_TO_B9=Label(win, text='Green')
        self.LABEL_B7_TO_B9.place(x=50, y=500)
        self.ENT_B7_VAL=Entry(width=6)
        self.ENT_B7_VAL.insert(0, "0")
        self.ENT_B7_VAL.place(x=200, y=500)
        self.ENT_B8_VAL=Entry(width=6)
        self.ENT_B8_VAL.insert(0, "0")
        self.ENT_B8_VAL.place(x=250, y=500)
        self.ENT_B9_VAL=Entry(width=6)
        self.ENT_B9_VAL.insert(0, "1000")
        self.ENT_B9_VAL.place(x=300, y=500)
        self.C1=Button(win, text='CCM2', command=self.ccm2)
        self.C1.place(x=400, y=500)
        
        ####################### REG19
        self.LABEL18_ENTER=Entry(width=6)
        self.LABEL18_ENTER.insert(0, "10")
        self.LABEL18=Label(win, text='Camera Color [REG19]')
        self.LABEL18.place(x=50, y=525)
        self.LABEL18_ENTER.place(x=200, y=525)
        self.LABEL18=Button(win, text='REG19', command=self.reg_19)
        self.LABEL18.place(x=300, y=525)
        
        
        ######################################## CCM3 BLUE
        self.LABEL_C1_TO_C3=Label(win, text='Blue')
        self.LABEL_C1_TO_C3.place(x=50, y=550)
        self.ENT_C1_VAL=Entry(width=6)
        self.ENT_C1_VAL.insert(0, "1000")
        self.ENT_C1_VAL.place(x=200, y=550)
        self.ENT_C2_VAL=Entry(width=6)
        self.ENT_C2_VAL.insert(0, "0")
        self.ENT_C2_VAL.place(x=250, y=550)
        self.ENT_C3_VAL=Entry(width=6)
        self.ENT_C3_VAL.insert(0, "0")
        self.ENT_C3_VAL.place(x=300, y=550)
        ######################################## CCM3 RED
        self.LABEL_C4_TO_C6=Label(win, text='Red')
        self.LABEL_C4_TO_C6.place(x=50, y=575)
        self.ENT_C4_VAL=Entry(width=6)
        self.ENT_C4_VAL.insert(0, "0")
        self.ENT_C4_VAL.place(x=200, y=575)
        self.ENT_C5_VAL=Entry(width=6)
        self.ENT_C5_VAL.insert(0, "1000")
        self.ENT_C5_VAL.place(x=250, y=575)
        self.ENT_C6_VAL=Entry(width=6)
        self.ENT_C6_VAL.insert(0, "0")
        self.ENT_C6_VAL.place(x=300, y=575)
        ######################################## CCM3 GREEN
        self.LABEL_C7_TO_C9=Label(win, text='Green')
        self.LABEL_C7_TO_C9.place(x=50, y=600)
        self.ENT_C7_VAL=Entry(width=6)
        self.ENT_C7_VAL.insert(0, "0")
        self.ENT_C7_VAL.place(x=200, y=600)
        self.ENT_C8_VAL=Entry(width=6)
        self.ENT_C8_VAL.insert(0, "0")
        self.ENT_C8_VAL.place(x=250, y=600)
        self.ENT_C9_VAL=Entry(width=6)
        self.ENT_C9_VAL.insert(0, "1000")
        self.ENT_C9_VAL.place(x=300, y=600)
        self.D1=Button(win, text='CCM3', command=self.ccm3)
        self.D1.place(x=400, y=600)
        ####################### REG44
        self.LABEL44=Label(win, text='TestPattern [REG44]')
        self.LABEL44.place(x=50, y=625)
        self.LABEL44_ENTER=Entry()
        self.LABEL44_ENTER.insert(0, "18")
        self.LABEL44_ENTER.place(x=200, y=625)
        ####################### REG45
        self.LABEL45=Label(win, text='TestPattern Select [REG45]')
        self.LABEL45.place(x=50, y=650)
        self.LABEL45_ENTER=Entry()
        self.LABEL45_ENTER.insert(0, "1")
        self.LABEL45_ENTER.place(x=200, y=650)
        ####################### REG46
        self.LABEL46=Label(win, text='K Type Select [REG46]')
        self.LABEL46.place(x=50, y=675)
        self.LABEL46_ENTER=Entry()
        self.LABEL46_ENTER.insert(0, "0")
        self.LABEL46_ENTER.place(x=200, y=675)
        self.f2=Button(win, text='REG46', command=self.reg46)
        self.f2.place(x=400, y=675)
        #######################
        self.LABEL20=Label(win, text='REG19')
        self.LABEL20.place(x=50, y=700)
        self.LABEL20_ENTER=Entry()
        self.LABEL20_ENTER.insert(0, "0")
        self.LABEL20_ENTER.place(x=200, y=700)
        self.LABEL20=Button(win, text='REG19', command=self.reg_20)
        self.LABEL20.place(x=400, y=700)
        #######################
        self.b1=Button(win, text='Update', command=self.Submit)
        self.b1.place(x=50, y=750)
        
    def Submit(self):
        control_reg00 =int(2).to_bytes(2, 'little')
        delay_reg10   =int(self.LABEL_5_ENTER.get()).to_bytes(2, 'little')
        a1_reg        =int(self.LABEL_6_ENTER.get()).to_bytes(2, 'little')
        a2_reg        =int(self.LABEL_7_ENTER.get()).to_bytes(2, 'little')
        a3_reg        =int(self.LABEL_8_ENTER.get()).to_bytes(2, 'little')
        a4_reg        =int(self.LABEL_9_ENTER.get()).to_bytes(2, 'little')
        a5_reg        =int(self.LABEL10_ENTER.get()).to_bytes(2, 'little')
        a6_reg        =int(self.LABEL11_ENTER.get()).to_bytes(2, 'little')
        a7_reg        =int(self.LABEL12_ENTER.get()).to_bytes(2, 'little')
        a8_reg        =int(self.LABEL44_ENTER.get()).to_bytes(2, 'little')
        a9_reg        =int(self.LABEL45_ENTER.get()).to_bytes(2, 'little')
        a11_reg        =int(self.LABEL46_ENTER.get()).to_bytes(2, 'little')
        a12_reg        =int(self.LABEL20_ENTER.get()).to_bytes(2, 'little')
        print("tx")
        file = open(self.LABEL14_ENTER.get()+'.bmp',"wb");
        count = 0
        s.sendto(b"".join([control_reg00,a1_reg,a2_reg,a3_reg,a4_reg,a5_reg,a6_reg,a7_reg,a8_reg,a9_reg,delay_reg10,a11_reg,a12_reg]), UDP)
    def ccm1(self):
        control_reg00 =int(11).to_bytes(2, 'little')
        delay_reg10   =int(12).to_bytes(2, 'little')
        a1_reg      =int(self.ENT_A1_VAL.get()).to_bytes(2, 'little')
        a2_reg      =int(self.ENT_A2_VAL.get()).to_bytes(2, 'little')
        a3_reg      =int(self.ENT_A3_VAL.get()).to_bytes(2, 'little')
        a4_reg      =int(self.ENT_A4_VAL.get()).to_bytes(2, 'little')
        a5_reg      =int(self.ENT_A5_VAL.get()).to_bytes(2, 'little')
        a6_reg      =int(self.ENT_A6_VAL.get()).to_bytes(2, 'little')
        a7_reg      =int(self.ENT_A7_VAL.get()).to_bytes(2, 'little')
        a8_reg      =int(self.ENT_A8_VAL.get()).to_bytes(2, 'little')
        a9_reg      =int(self.ENT_A9_VAL.get()).to_bytes(2, 'little')
        reg11       =int(self.LABEL_6_ENTER.get()).to_bytes(2, 'little')
        reg12       =int(self.LABEL_7_ENTER.get()).to_bytes(2, 'little')
        reg13       =int(self.LABEL_8_ENTER.get()).to_bytes(2, 'little')
        reg14       =int(self.LABEL_9_ENTER.get()).to_bytes(2, 'little')
        reg15       =int(self.LABEL10_ENTER.get()).to_bytes(2, 'little')
        reg16       =int(self.LABEL11_ENTER.get()).to_bytes(2, 'little')
        reg17       =int(self.LABEL12_ENTER.get()).to_bytes(2, 'little')
        reg18       =int(self.LABEL13_ENTER.get()).to_bytes(2, 'little')
        reg19       =int(self.LABEL15_ENTER.get()).to_bytes(2, 'little')
        reg20       =int(self.LABEL16_ENTER.get()).to_bytes(2, 'little')
        reg21       =int(self.LABEL17_ENTER.get()).to_bytes(2, 'little')
        s.sendto(b"".join([control_reg00,a1_reg,a2_reg,a3_reg,a4_reg,a5_reg,a6_reg,a7_reg,a8_reg,a9_reg,delay_reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21]), UDP)
    def ccm2(self):
        control_reg00 =int(12).to_bytes(2, 'little')
        delay_reg10   =int(12).to_bytes(2, 'little')
        a1_reg      =int(self.ENT_B1_VAL.get()).to_bytes(2, 'little')
        a2_reg      =int(self.ENT_B2_VAL.get()).to_bytes(2, 'little')
        a3_reg      =int(self.ENT_B3_VAL.get()).to_bytes(2, 'little')
        a4_reg      =int(self.ENT_B4_VAL.get()).to_bytes(2, 'little')
        a5_reg      =int(self.ENT_B5_VAL.get()).to_bytes(2, 'little')
        a6_reg      =int(self.ENT_B6_VAL.get()).to_bytes(2, 'little')
        a7_reg      =int(self.ENT_B7_VAL.get()).to_bytes(2, 'little')
        a8_reg      =int(self.ENT_B8_VAL.get()).to_bytes(2, 'little')
        a9_reg      =int(self.ENT_B9_VAL.get()).to_bytes(2, 'little')
        reg11       =int(self.LABEL_6_ENTER.get()).to_bytes(2, 'little')
        reg12       =int(self.LABEL_7_ENTER.get()).to_bytes(2, 'little')
        reg13       =int(self.LABEL_8_ENTER.get()).to_bytes(2, 'little')
        reg14       =int(self.LABEL_9_ENTER.get()).to_bytes(2, 'little')
        reg15       =int(self.LABEL10_ENTER.get()).to_bytes(2, 'little')
        reg16       =int(self.LABEL11_ENTER.get()).to_bytes(2, 'little')
        reg17       =int(self.LABEL12_ENTER.get()).to_bytes(2, 'little')
        reg18       =int(self.LABEL13_ENTER.get()).to_bytes(2, 'little')
        reg19       =int(self.LABEL15_ENTER.get()).to_bytes(2, 'little')
        reg20       =int(self.LABEL16_ENTER.get()).to_bytes(2, 'little')
        reg21       =int(self.LABEL17_ENTER.get()).to_bytes(2, 'little')
        s.sendto(b"".join([control_reg00,a1_reg,a2_reg,a3_reg,a4_reg,a5_reg,a6_reg,a7_reg,a8_reg,a9_reg,delay_reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21]), UDP)
    def ccm3(self):
        control_reg00 =int(13).to_bytes(2, 'little')
        delay_reg10   =int(12).to_bytes(2, 'little')
        a1_reg      =int(self.ENT_C1_VAL.get()).to_bytes(2, 'little')
        a2_reg      =int(self.ENT_C2_VAL.get()).to_bytes(2, 'little')
        a3_reg      =int(self.ENT_C3_VAL.get()).to_bytes(2, 'little')
        a4_reg      =int(self.ENT_C4_VAL.get()).to_bytes(2, 'little')
        a5_reg      =int(self.ENT_C5_VAL.get()).to_bytes(2, 'little')
        a6_reg      =int(self.ENT_C6_VAL.get()).to_bytes(2, 'little')
        a7_reg      =int(self.ENT_C7_VAL.get()).to_bytes(2, 'little')
        a8_reg      =int(self.ENT_C8_VAL.get()).to_bytes(2, 'little')
        a9_reg      =int(self.ENT_C9_VAL.get()).to_bytes(2, 'little')
        reg11       =int(self.LABEL_6_ENTER.get()).to_bytes(2, 'little')
        reg12       =int(self.LABEL_7_ENTER.get()).to_bytes(2, 'little')
        reg13       =int(self.LABEL_8_ENTER.get()).to_bytes(2, 'little')
        reg14       =int(self.LABEL_9_ENTER.get()).to_bytes(2, 'little')
        reg15       =int(self.LABEL10_ENTER.get()).to_bytes(2, 'little')
        reg16       =int(self.LABEL11_ENTER.get()).to_bytes(2, 'little')
        reg17       =int(self.LABEL12_ENTER.get()).to_bytes(2, 'little')
        reg18       =int(self.LABEL13_ENTER.get()).to_bytes(2, 'little')
        reg19       =int(self.LABEL15_ENTER.get()).to_bytes(2, 'little')
        reg20       =int(self.LABEL16_ENTER.get()).to_bytes(2, 'little')
        reg21       =int(self.LABEL17_ENTER.get()).to_bytes(2, 'little')
        s.sendto(b"".join([control_reg00,a1_reg,a2_reg,a3_reg,a4_reg,a5_reg,a6_reg,a7_reg,a8_reg,a9_reg,delay_reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21]), UDP)
    def imx477(self):
        control_reg00 =int(4).to_bytes(2, 'little')
        delay_reg10   =int(12).to_bytes(2, 'little')
        a1_reg      =int(self.ENT_A1_VAL.get()).to_bytes(2, 'little')
        a2_reg      =int(self.ENT_A2_VAL.get()).to_bytes(2, 'little')
        a3_reg      =int(self.ENT_A3_VAL.get()).to_bytes(2, 'little')
        a4_reg      =int(self.ENT_A4_VAL.get()).to_bytes(2, 'little')
        a5_reg      =int(self.ENT_A5_VAL.get()).to_bytes(2, 'little')
        a6_reg      =int(self.ENT_A6_VAL.get()).to_bytes(2, 'little')
        a7_reg      =int(self.ENT_A7_VAL.get()).to_bytes(2, 'little')
        a8_reg      =int(self.ENT_A8_VAL.get()).to_bytes(2, 'little')
        a9_reg      =int(self.ENT_A9_VAL.get()).to_bytes(2, 'little')
        reg11       =int(self.LABEL_6_ENTER.get()).to_bytes(2, 'little')
        reg12       =int(self.LABEL_7_ENTER.get()).to_bytes(2, 'little')
        reg13       =int(self.LABEL_8_ENTER.get()).to_bytes(2, 'little')
        reg14       =int(self.LABEL_9_ENTER.get()).to_bytes(2, 'little')
        reg15       =int(self.LABEL10_ENTER.get()).to_bytes(2, 'little')
        reg16       =int(self.LABEL11_ENTER.get()).to_bytes(2, 'little')
        reg17       =int(self.LABEL12_ENTER.get()).to_bytes(2, 'little')
        reg18       =int(self.LABEL13_ENTER.get()).to_bytes(2, 'little')
        reg19       =int(self.LABEL15_ENTER.get()).to_bytes(2, 'little')
        reg20       =int(self.LABEL16_ENTER.get()).to_bytes(2, 'little')
        reg21       =int(self.LABEL17_ENTER.get()).to_bytes(2, 'little')
        s.sendto(b"".join([control_reg00,a1_reg,a2_reg,a3_reg,a4_reg,a5_reg,a6_reg,a7_reg,a8_reg,a9_reg,delay_reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21]), UDP)
    def reg43(self):
        control_reg00 =int(8).to_bytes(2, 'little')
        delay_reg10   =int(12).to_bytes(2, 'little')
        a1_reg      =int(self.ENT_A1_VAL.get()).to_bytes(2, 'little')
        a2_reg      =int(self.ENT_A2_VAL.get()).to_bytes(2, 'little')
        a3_reg      =int(self.ENT_A3_VAL.get()).to_bytes(2, 'little')
        a4_reg      =int(self.ENT_A4_VAL.get()).to_bytes(2, 'little')
        a5_reg      =int(self.ENT_A5_VAL.get()).to_bytes(2, 'little')
        a6_reg      =int(self.ENT_A6_VAL.get()).to_bytes(2, 'little')
        a7_reg      =int(self.ENT_A7_VAL.get()).to_bytes(2, 'little')
        a8_reg      =int(self.ENT_A8_VAL.get()).to_bytes(2, 'little')
        a9_reg      =int(self.ENT_A9_VAL.get()).to_bytes(2, 'little')
        reg11       =int(self.LABEL_6_ENTER.get()).to_bytes(2, 'little')
        reg12       =int(self.LABEL_7_ENTER.get()).to_bytes(2, 'little')
        reg13       =int(self.LABEL_8_ENTER.get()).to_bytes(2, 'little')
        reg14       =int(self.LABEL_9_ENTER.get()).to_bytes(2, 'little')
        reg15       =int(self.LABEL10_ENTER.get()).to_bytes(2, 'little')
        reg16       =int(self.LABEL11_ENTER.get()).to_bytes(2, 'little')
        reg17       =int(self.LABEL12_ENTER.get()).to_bytes(2, 'little')
        reg18       =int(self.LABEL13_ENTER.get()).to_bytes(2, 'little')
        reg19       =int(self.LABEL15_ENTER.get()).to_bytes(2, 'little')
        reg20       =int(self.LABEL16_ENTER.get()).to_bytes(2, 'little')
        reg21       =int(self.LABEL17_ENTER.get()).to_bytes(2, 'little')
        s.sendto(b"".join([control_reg00,a1_reg,a2_reg,a3_reg,a4_reg,a5_reg,a6_reg,a7_reg,a8_reg,a9_reg,delay_reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21]), UDP)
    def reg_19(self):
        control_reg00 =int(9).to_bytes(2, 'little')
        delay_reg10   =int(12).to_bytes(2, 'little')
        a1_reg      =int(self.ENT_A1_VAL.get()).to_bytes(2, 'little')
        a2_reg      =int(self.ENT_A2_VAL.get()).to_bytes(2, 'little')
        a3_reg      =int(self.ENT_A3_VAL.get()).to_bytes(2, 'little')
        a4_reg      =int(self.ENT_A4_VAL.get()).to_bytes(2, 'little')
        a5_reg      =int(self.ENT_A5_VAL.get()).to_bytes(2, 'little')
        a6_reg      =int(self.ENT_A6_VAL.get()).to_bytes(2, 'little')
        a7_reg      =int(self.ENT_A7_VAL.get()).to_bytes(2, 'little')
        a8_reg      =int(self.ENT_A8_VAL.get()).to_bytes(2, 'little')
        a9_reg      =int(self.ENT_A9_VAL.get()).to_bytes(2, 'little')
        reg11       =int(self.LABEL_6_ENTER.get()).to_bytes(2, 'little')
        reg12       =int(self.LABEL_7_ENTER.get()).to_bytes(2, 'little')
        reg13       =int(self.LABEL_8_ENTER.get()).to_bytes(2, 'little')
        reg14       =int(self.LABEL_9_ENTER.get()).to_bytes(2, 'little')
        reg15       =int(self.LABEL10_ENTER.get()).to_bytes(2, 'little')
        reg16       =int(self.LABEL11_ENTER.get()).to_bytes(2, 'little')
        reg17       =int(self.LABEL12_ENTER.get()).to_bytes(2, 'little')
        reg18       =int(self.LABEL13_ENTER.get()).to_bytes(2, 'little')
        reg19       =int(self.LABEL15_ENTER.get()).to_bytes(2, 'little')
        reg20       =int(self.LABEL16_ENTER.get()).to_bytes(2, 'little')
        reg21       =int(self.LABEL18_ENTER.get()).to_bytes(2, 'little')
        s.sendto(b"".join([control_reg00,a1_reg,a2_reg,a3_reg,a4_reg,a5_reg,a6_reg,a7_reg,a8_reg,a9_reg,delay_reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21]), UDP)
    def reg46(self):
        control_reg00 =int(5).to_bytes(2, 'little')
        delay_reg10   =int(12).to_bytes(2, 'little')
        a1_reg        =int(self.LABEL46_ENTER.get()).to_bytes(2, 'little')
        s.sendto(b"".join([control_reg00,a1_reg]), UDP)
    def reg_20(self):
        control_reg00 =int(10).to_bytes(2, 'little')
        delay_reg10   =int(12).to_bytes(2, 'little')
        a1_reg        =int(self.LABEL20_ENTER.get()).to_bytes(2, 'little')
        s.sendto(b"".join([control_reg00,a1_reg]), UDP)
window=Tk()
mywin=MyWindow(window)
window.title('Config Camera')
window.geometry("1000x1000+10+10")
window.mainloop()