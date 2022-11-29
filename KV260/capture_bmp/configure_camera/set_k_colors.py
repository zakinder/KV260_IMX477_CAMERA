from tkinter import *
import socket
import threading
from time import sleep
addr = '192.168.0.10'
port = 8080
UDP = (addr, port)
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
infile = open("beta.txt", 'r') 

####################### 0-85 #######################
r_001 =infile.readline()
g_001 =infile.readline()
b_001 =infile.readline()
r_002 =infile.readline()
g_002 =infile.readline()
b_002 =infile.readline()
r_003 =infile.readline()
g_003 =infile.readline()
b_003 =infile.readline()
r_004 =infile.readline()
g_004 =infile.readline()
b_004 =infile.readline()
r_005 =infile.readline()
g_005 =infile.readline()
b_005 =infile.readline()
r_006 =infile.readline()
g_006 =infile.readline()
b_006 ="0"
r_007 ="90"
g_007 ="20"
b_007 ="0"
r_008 ="80"
g_008 ="80"
b_008 ="0"
r_009 ="80"
g_009 ="50"
b_009 ="20"
r_010 ="80"
g_010 ="40"
b_010 ="10"
r_011 ="80"
g_011 ="40"
b_011 ="10"
r_012 ="80"
g_012 ="30"
b_012 ="0"
r_013 ="80"
g_013 ="30"
b_013 ="0"
r_014 ="70"
g_014 ="70"
b_014 ="0"
r_015 ="70"
g_015 ="50"
b_015 ="15"
r_016 ="70"
g_016 ="30"
b_016 ="15"
r_017 ="70"
g_017 ="10"
b_017 ="0"
r_018 ="60"
g_018 ="60"
b_018 ="0"
r_019 ="60"
g_019 ="30"
b_019 ="20"
r_020 ="60"
g_020 ="20"
b_020 ="10"
r_021 ="60"
g_021 ="10"
b_021 ="0"
r_022 ="40"
g_022 ="40"
b_022 ="0"
r_023 ="40"
g_023 ="20"
b_023 ="10"
r_024 ="40"
g_024 ="10"
b_024 ="5"
r_025 ="40"
g_025 ="10"
b_025 ="0"
r_026 ="30"
g_026 ="30"
b_026 ="0"
r_027 ="30"
g_027 ="20"
b_027 ="15"
r_028 ="30"
g_028 ="15"
b_028 ="0"
r_029 ="30"
g_029 ="10"
b_029 ="0"
r_030 ="20"
g_030 ="10"
b_030 ="0"
infile.close()
####################### 85-170 #######################
r_031 =240            # 85-170
g_031 =200            # 85-170
b_031 =0              # 85-170
r_032 =240            # 85-170
g_032 =180            # 85-170
b_032 =0              # 85-170
r_033 =230            # 85-170
g_033 =180            # 85-170
b_033 =0              # 85-170
r_034 =230            # 85-170
g_034 =170            # 85-170
b_034 =0              # 85-170
r_035 =230            # 85-170
g_035 =160            # 85-170
b_035 =0              # 85-170
r_036 =230            # 85-170
g_036 =180            # 85-170
b_036 =0              # 85-170
r_037 =200            # 85-170
g_037 =160            # 85-170
b_037 =0              # 85-170
r_038 =200            # 85-170
g_038 =150            # 85-170
b_038 =0              # 85-170
r_039 =200            # 85-170
g_039 =140            # 85-170
b_039 =0              # 85-170
r_040 =200            # 85-170
g_040 =130            # 85-170
b_040 =0              # 85-170
r_041 =200            # 85-170
g_041 =100            # 85-170
b_041 =0              # 85-170
r_042 =160            # 85-170
g_042 =160            # 85-170
b_042 =0              # 85-170
r_043 =160            # 85-170
g_043 =120            # 85-170
b_043 =70             # 85-170
r_044 =160            # 85-170
g_044 =110            # 85-170
b_044 =50             # 85-170
r_045 =160            # 85-170
g_045 =100            # 85-170
b_045 =40             # 85-170
r_046 =160            # 85-170
g_046 =90             # 85-170
b_046 =30             # 85-170
r_047 =160            # 85-170
g_047 =50             # 85-170
b_047 =10             # 85-170
r_048 =150            # 85-170
g_048 =80             # 85-170
b_048 =20             # 85-170
r_049 =140            # 85-170
g_049 =140            # 85-170
b_049 =0              # 85-170
r_050 =140            # 85-170
g_050 =100            # 85-170
b_050 =40             # 85-170
r_051 =140            # 85-170
g_051 =80             # 85-170
b_051 =40             # 85-170
r_052 =140            # 85-170
g_052 =60             # 85-170
b_052 =0              # 85-170
r_053 =120            # 85-170
g_053 =120            # 85-170
b_053 =0              # 85-170
r_054 =120            # 85-170
g_054 =50             # 85-170
b_054 =0              # 85-170
r_055 =120            # 85-170
g_055 =80             # 85-170
b_055 =0              # 85-170
r_056 =120            # 85-170
g_056 =70             # 85-170
b_056 =0              # 85-170
r_057 =100            # 85-170
g_057 =100            # 85-170
b_057 =0              # 85-170
r_058 =100            # 85-170
g_058 =50             # 85-170
b_058 =0              # 85-170
r_059 =100            # 85-170
g_059 =90             # 85-170
b_059 =0              # 85-170
r_060 =100            # 85-170
g_060 =25             # 85-170
b_060 =0              # 85-170
####################### 170-255 #######################
r_061 =240   
g_061 =200
b_061 =0  
r_062 =240
g_062 =180
b_062 =0  
r_063 =230
g_063 =180
b_063 =0  
r_064 =230
g_064 =170
b_064 =0  
r_065 =230
g_065 =160
b_065 =0  
r_066 =230
g_066 =180
b_066 =0  
r_067 =200
g_067 =160
b_067 =0  
r_068 =200
g_068 =150
b_068 =0  
r_069 =200
g_069 =140
b_069 =0  
r_070 =200
g_070 =130
b_070 =0  
r_071 =200
g_071 =100
b_071 =0  
r_072 =160
g_072 =160
b_072 =0  
r_073 =160
g_073 =120
b_073 =70 
r_074 =160
g_074 =110
b_074 =50 
r_075 =160
g_075 =100
b_075 =40 
r_076 =160
g_076 =90 
b_076 =30 
r_077 =160
g_077 =50 
b_077 =10 
r_078 =150
g_078 =80 
b_078 =20 
r_079 =140
g_079 =140
b_079 =0  
r_080 =140
g_080 =100
b_080 =40 
r_081 =140
g_081 =80 
b_081 =40 
r_082 =140
g_082 =60 
b_082 =0  
r_083 =120
g_083 =120
b_083 =0  
r_084 =120
g_084 =50 
b_084 =0  
r_085 =120
g_085 =80 
b_085 =0  
r_086 =120
g_086 =70 
b_086 =0  
r_087 =100
g_087 =100
b_087 =0  
r_088 =100
g_088 =50 
b_088 =0  
r_089 =100
g_089 =90 
b_089 =0  
r_090 =100
g_090 =25 
b_090 =0  
#######################
class MyWindow:
    def __init__(self, win):
        self.LAB_INDEX_001_00=Label(win, text='RGB 170-85 CLUSTER VALUES')
        self.LAB_INDEX_001_00.place(x=100, y=25)
        #######################
        self.LAB_INDEX_001_00=Label(win, text='001')
        self.LAB_INDEX_001_00.place(x=50, y=75)
        self.ENT_INDEX_001_01=Entry(width=6)
        self.ENT_INDEX_001_01.insert(0, r_031)
        self.ENT_INDEX_001_01.place(x=100, y=75)
        self.ENT_INDEX_001_02=Entry(width=6)
        self.ENT_INDEX_001_02.insert(0, g_031)
        self.ENT_INDEX_001_02.place(x=150, y=75)
        self.ENT_INDEX_001_03=Entry(width=6)
        self.ENT_INDEX_001_03.insert(0, b_031)
        self.ENT_INDEX_001_03.place(x=200, y=75)
        self.IX1=Button(win, text='IX_01', command=self.IX1)
        self.IX1.place(x=250, y=75)
        #######################
        self.LAB_INDEX_002_00=Label(win, text='002')
        self.LAB_INDEX_002_00.place(x=50, y=100)
        self.ENT_INDEX_002_01=Entry(width=6)
        self.ENT_INDEX_002_01.insert(0, r_032)
        self.ENT_INDEX_002_01.place(x=100, y=100)
        self.ENT_INDEX_002_02=Entry(width=6)
        self.ENT_INDEX_002_02.insert(0, g_032)
        self.ENT_INDEX_002_02.place(x=150, y=100)
        self.ENT_INDEX_002_03=Entry(width=6)
        self.ENT_INDEX_002_03.insert(0, b_032)
        self.ENT_INDEX_002_03.place(x=200, y=100)
        self.IX1=Button(win, text='IX_02', command=self.IX2)
        self.IX1.place(x=250, y=100)
        #######################
        self.LAB_INDEX_003_00=Label(win, text='003')
        self.LAB_INDEX_003_00.place(x=50, y=125)
        self.ENT_INDEX_003_01=Entry(width=6)
        self.ENT_INDEX_003_01.insert(0, r_033)
        self.ENT_INDEX_003_01.place(x=100, y=125)
        self.ENT_INDEX_003_02=Entry(width=6)
        self.ENT_INDEX_003_02.insert(0, g_033)
        self.ENT_INDEX_003_02.place(x=150, y=125)
        self.ENT_INDEX_003_03=Entry(width=6)
        self.ENT_INDEX_003_03.insert(0, b_033)
        self.ENT_INDEX_003_03.place(x=200, y=125)
        self.IX1=Button(win, text='IX_03', command=self.IX3)
        self.IX1.place(x=250, y=125)
        #######################
        self.LAB_INDEX_004_00=Label(win, text='004')
        self.LAB_INDEX_004_00.place(x=50, y=150)
        self.ENT_INDEX_004_01=Entry(width=6)
        self.ENT_INDEX_004_01.insert(0, r_034)
        self.ENT_INDEX_004_01.place(x=100, y=150)
        self.ENT_INDEX_004_02=Entry(width=6)
        self.ENT_INDEX_004_02.insert(0, g_034)
        self.ENT_INDEX_004_02.place(x=150, y=150)
        self.ENT_INDEX_004_03=Entry(width=6)
        self.ENT_INDEX_004_03.insert(0, b_034)
        self.ENT_INDEX_004_03.place(x=200, y=150)
        self.IX4=Button(win, text='IX_04', command=self.IX4)
        self.IX4.place(x=250, y=150)
        #######################
        self.LAB_INDEX_005_00=Label(win, text='005')
        self.LAB_INDEX_005_00.place(x=50, y=175)
        self.ENT_INDEX_005_01=Entry(width=6)
        self.ENT_INDEX_005_01.insert(0, r_035)
        self.ENT_INDEX_005_01.place(x=100, y=175)
        self.ENT_INDEX_005_02=Entry(width=6)
        self.ENT_INDEX_005_02.insert(0, g_035)
        self.ENT_INDEX_005_02.place(x=150, y=175)
        self.ENT_INDEX_005_03=Entry(width=6)
        self.ENT_INDEX_005_03.insert(0, b_035)
        self.ENT_INDEX_005_03.place(x=200, y=175)
        self.IX1=Button(win, text='IX_05', command=self.IX5)
        self.IX1.place(x=250, y=175)
        #######################
        self.LAB_INDEX_006_00=Label(win, text='006')
        self.LAB_INDEX_006_00.place(x=50, y=200)
        self.ENT_INDEX_006_01=Entry(width=6)
        self.ENT_INDEX_006_01.insert(0, r_036)
        self.ENT_INDEX_006_01.place(x=100, y=200)
        self.ENT_INDEX_006_02=Entry(width=6)
        self.ENT_INDEX_006_02.insert(0, g_036)
        self.ENT_INDEX_006_02.place(x=150, y=200)
        self.ENT_INDEX_006_03=Entry(width=6)
        self.ENT_INDEX_006_03.insert(0, b_036)
        self.ENT_INDEX_006_03.place(x=200, y=200)
        self.IX1=Button(win, text='IX_06', command=self.IX6)
        self.IX1.place(x=250, y=200)
        #######################
        self.LAB_INDEX_007_00=Label(win, text='007')
        self.LAB_INDEX_007_00.place(x=50, y=225)
        self.ENT_INDEX_007_01=Entry(width=6)
        self.ENT_INDEX_007_01.insert(0, r_037)
        self.ENT_INDEX_007_01.place(x=100, y=225)
        self.ENT_INDEX_007_02=Entry(width=6)
        self.ENT_INDEX_007_02.insert(0, g_037)
        self.ENT_INDEX_007_02.place(x=150, y=225)
        self.ENT_INDEX_007_03=Entry(width=6)
        self.ENT_INDEX_007_03.insert(0, b_037)
        self.ENT_INDEX_007_03.place(x=200, y=225)
        self.IX1=Button(win, text='IX_07', command=self.IX7)
        self.IX1.place(x=250, y=225)
        #######################
        self.LAB_INDEX_008_00=Label(win, text='008')
        self.LAB_INDEX_008_00.place(x=50, y=250)
        self.ENT_INDEX_008_01=Entry(width=6)
        self.ENT_INDEX_008_01.insert(0, r_038)
        self.ENT_INDEX_008_01.place(x=100, y=250)
        self.ENT_INDEX_008_02=Entry(width=6)
        self.ENT_INDEX_008_02.insert(0, g_038)
        self.ENT_INDEX_008_02.place(x=150, y=250)
        self.ENT_INDEX_008_03=Entry(width=6)
        self.ENT_INDEX_008_03.insert(0, b_038)
        self.ENT_INDEX_008_03.place(x=200, y=250)
        self.IX1=Button(win, text='IX_08', command=self.IX8)
        self.IX1.place(x=250, y=250)
        #######################
        self.LAB_INDEX_009_00=Label(win, text='009')
        self.LAB_INDEX_009_00.place(x=50, y=275)
        self.ENT_INDEX_009_01=Entry(width=6)
        self.ENT_INDEX_009_01.insert(0, r_039)
        self.ENT_INDEX_009_01.place(x=100, y=275)
        self.ENT_INDEX_009_02=Entry(width=6)
        self.ENT_INDEX_009_02.insert(0, g_039)
        self.ENT_INDEX_009_02.place(x=150, y=275)
        self.ENT_INDEX_009_03=Entry(width=6)
        self.ENT_INDEX_009_03.insert(0, b_039)
        self.ENT_INDEX_009_03.place(x=200, y=275)
        self.IX1=Button(win, text='IX_09', command=self.IX9)
        self.IX1.place(x=250, y=275)
        #######################
        self.LAB_INDEX_010_00=Label(win, text='010')
        self.LAB_INDEX_010_00.place(x=50, y=300)
        self.ENT_INDEX_010_01=Entry(width=6)
        self.ENT_INDEX_010_01.insert(0, r_040)
        self.ENT_INDEX_010_01.place(x=100, y=300)
        self.ENT_INDEX_010_02=Entry(width=6)
        self.ENT_INDEX_010_02.insert(0, g_040)
        self.ENT_INDEX_010_02.place(x=150, y=300)
        self.ENT_INDEX_010_03=Entry(width=6)
        self.ENT_INDEX_010_03.insert(0, b_040)
        self.ENT_INDEX_010_03.place(x=200, y=300)
        self.IX1=Button(win, text='IX_10', command=self.IX10)
        self.IX1.place(x=250, y=300)
        #######################
        self.LAB_INDEX_011_00=Label(win, text='011')
        self.LAB_INDEX_011_00.place(x=50, y=325)
        self.ENT_INDEX_011_01=Entry(width=6)
        self.ENT_INDEX_011_01.insert(0, r_041)
        self.ENT_INDEX_011_01.place(x=100, y=325)
        self.ENT_INDEX_011_02=Entry(width=6)
        self.ENT_INDEX_011_02.insert(0, g_041)
        self.ENT_INDEX_011_02.place(x=150, y=325)
        self.ENT_INDEX_011_03=Entry(width=6)
        self.ENT_INDEX_011_03.insert(0, b_041)
        self.ENT_INDEX_011_03.place(x=200, y=325)
        self.IX1=Button(win, text='IX_11', command=self.IX11)
        self.IX1.place(x=250, y=325)
        #######################
        self.LAB_INDEX_012_00=Label(win, text='012')
        self.LAB_INDEX_012_00.place(x=50, y=350)
        self.ENT_INDEX_012_01=Entry(width=6)
        self.ENT_INDEX_012_01.insert(0, r_042)
        self.ENT_INDEX_012_01.place(x=100, y=350)
        self.ENT_INDEX_012_02=Entry(width=6)
        self.ENT_INDEX_012_02.insert(0, g_042)
        self.ENT_INDEX_012_02.place(x=150, y=350)
        self.ENT_INDEX_012_03=Entry(width=6)
        self.ENT_INDEX_012_03.insert(0, b_042)
        self.ENT_INDEX_012_03.place(x=200, y=350)
        self.IX1=Button(win, text='IX_12', command=self.IX12)
        self.IX1.place(x=250, y=350)
        #######################
        self.LAB_INDEX_013_00=Label(win, text='013')
        self.LAB_INDEX_013_00.place(x=50, y=375)
        self.ENT_INDEX_013_01=Entry(width=6)
        self.ENT_INDEX_013_01.insert(0, r_043)
        self.ENT_INDEX_013_01.place(x=100, y=375)
        self.ENT_INDEX_013_02=Entry(width=6)
        self.ENT_INDEX_013_02.insert(0, g_043)
        self.ENT_INDEX_013_02.place(x=150, y=375)
        self.ENT_INDEX_013_03=Entry(width=6)
        self.ENT_INDEX_013_03.insert(0, b_043)
        self.ENT_INDEX_013_03.place(x=200, y=375)
        self.IX1=Button(win, text='IX_13', command=self.IX13)
        self.IX1.place(x=250, y=375)
        #######################
        self.LAB_INDEX_014_00=Label(win, text='014')
        self.LAB_INDEX_014_00.place(x=50, y=400)
        self.ENT_INDEX_014_01=Entry(width=6)
        self.ENT_INDEX_014_01.insert(0, r_044)
        self.ENT_INDEX_014_01.place(x=100, y=400)
        self.ENT_INDEX_014_02=Entry(width=6)
        self.ENT_INDEX_014_02.insert(0, g_044)
        self.ENT_INDEX_014_02.place(x=150, y=400)
        self.ENT_INDEX_014_03=Entry(width=6)
        self.ENT_INDEX_014_03.insert(0, b_044)
        self.ENT_INDEX_014_03.place(x=200, y=400)
        self.IX4=Button(win, text='IX_14', command=self.IX14)
        self.IX4.place(x=250, y=400)
        #######################
        self.LAB_INDEX_015_00=Label(win, text='015')
        self.LAB_INDEX_015_00.place(x=50, y=425)
        self.ENT_INDEX_015_01=Entry(width=6)
        self.ENT_INDEX_015_01.insert(0, r_045)
        self.ENT_INDEX_015_01.place(x=100, y=425)
        self.ENT_INDEX_015_02=Entry(width=6)
        self.ENT_INDEX_015_02.insert(0, g_045)
        self.ENT_INDEX_015_02.place(x=150, y=425)
        self.ENT_INDEX_015_03=Entry(width=6)
        self.ENT_INDEX_015_03.insert(0, b_045)
        self.ENT_INDEX_015_03.place(x=200, y=425)
        self.IX1=Button(win, text='IX_15', command=self.IX15)
        self.IX1.place(x=250, y=425)
        #######################
        self.LAB_INDEX_016_00=Label(win, text='016')
        self.LAB_INDEX_016_00.place(x=50, y=450)
        self.ENT_INDEX_016_01=Entry(width=6)
        self.ENT_INDEX_016_01.insert(0, r_046)
        self.ENT_INDEX_016_01.place(x=100, y=450)
        self.ENT_INDEX_016_02=Entry(width=6)
        self.ENT_INDEX_016_02.insert(0, g_046)
        self.ENT_INDEX_016_02.place(x=150, y=450)
        self.ENT_INDEX_016_03=Entry(width=6)
        self.ENT_INDEX_016_03.insert(0, b_046)
        self.ENT_INDEX_016_03.place(x=200, y=450)
        self.IX1=Button(win, text='IX_16', command=self.IX16)
        self.IX1.place(x=250, y=450)
        #######################
        self.LAB_INDEX_017_00=Label(win, text='017')
        self.LAB_INDEX_017_00.place(x=50, y=475)
        self.ENT_INDEX_017_01=Entry(width=6)
        self.ENT_INDEX_017_01.insert(0, r_047)
        self.ENT_INDEX_017_01.place(x=100, y=475)
        self.ENT_INDEX_017_02=Entry(width=6)
        self.ENT_INDEX_017_02.insert(0, g_047)
        self.ENT_INDEX_017_02.place(x=150, y=475)
        self.ENT_INDEX_017_03=Entry(width=6)
        self.ENT_INDEX_017_03.insert(0, b_047)
        self.ENT_INDEX_017_03.place(x=200, y=475)
        self.IX1=Button(win, text='IX_17', command=self.IX17)
        self.IX1.place(x=250, y=475)
        #######################
        self.LAB_INDEX_018_00=Label(win, text='018')
        self.LAB_INDEX_018_00.place(x=50, y=500)
        self.ENT_INDEX_018_01=Entry(width=6)
        self.ENT_INDEX_018_01.insert(0, r_048)
        self.ENT_INDEX_018_01.place(x=100, y=500)
        self.ENT_INDEX_018_02=Entry(width=6)
        self.ENT_INDEX_018_02.insert(0, g_048)
        self.ENT_INDEX_018_02.place(x=150, y=500)
        self.ENT_INDEX_018_03=Entry(width=6)
        self.ENT_INDEX_018_03.insert(0, b_048)
        self.ENT_INDEX_018_03.place(x=200, y=500)
        self.IX1=Button(win, text='IX_18', command=self.IX18)
        self.IX1.place(x=250, y=500)
        #######################
        self.LAB_INDEX_019_00=Label(win, text='019')
        self.LAB_INDEX_019_00.place(x=50, y=525)
        self.ENT_INDEX_019_01=Entry(width=6)
        self.ENT_INDEX_019_01.insert(0, r_049)
        self.ENT_INDEX_019_01.place(x=100, y=525)
        self.ENT_INDEX_019_02=Entry(width=6)
        self.ENT_INDEX_019_02.insert(0, g_049)
        self.ENT_INDEX_019_02.place(x=150, y=525)
        self.ENT_INDEX_019_03=Entry(width=6)
        self.ENT_INDEX_019_03.insert(0, b_049)
        self.ENT_INDEX_019_03.place(x=200, y=525)
        self.IX1=Button(win, text='IX_19', command=self.IX19)
        self.IX1.place(x=250, y=525)
        #######################
        self.LAB_INDEX_020_00=Label(win, text='020')
        self.LAB_INDEX_020_00.place(x=50, y=550)
        self.ENT_INDEX_020_01=Entry(width=6)
        self.ENT_INDEX_020_01.insert(0, r_050)
        self.ENT_INDEX_020_01.place(x=100, y=550)
        self.ENT_INDEX_020_02=Entry(width=6)
        self.ENT_INDEX_020_02.insert(0, g_050)
        self.ENT_INDEX_020_02.place(x=150, y=550)
        self.ENT_INDEX_020_03=Entry(width=6)
        self.ENT_INDEX_020_03.insert(0, b_050)
        self.ENT_INDEX_020_03.place(x=200, y=550)
        self.IX1=Button(win, text='IX_20', command=self.IX20)
        self.IX1.place(x=250, y=550)
        #######################
        self.LAB_INDEX_021_00=Label(win, text='021')
        self.LAB_INDEX_021_00.place(x=50, y=575)
        self.ENT_INDEX_021_01=Entry(width=6)
        self.ENT_INDEX_021_01.insert(0, r_051)
        self.ENT_INDEX_021_01.place(x=100, y=575)
        self.ENT_INDEX_021_02=Entry(width=6)
        self.ENT_INDEX_021_02.insert(0, g_051)
        self.ENT_INDEX_021_02.place(x=150, y=575)
        self.ENT_INDEX_021_03=Entry(width=6)
        self.ENT_INDEX_021_03.insert(0, b_051)
        self.ENT_INDEX_021_03.place(x=200, y=575)
        self.IX1=Button(win, text='IX_21', command=self.IX21)
        self.IX1.place(x=250, y=575)
        #######################
        self.LAB_INDEX_022_00=Label(win, text='022')
        self.LAB_INDEX_022_00.place(x=50, y=600)
        self.ENT_INDEX_022_01=Entry(width=6)
        self.ENT_INDEX_022_01.insert(0, r_052)
        self.ENT_INDEX_022_01.place(x=100, y=600)
        self.ENT_INDEX_022_02=Entry(width=6)
        self.ENT_INDEX_022_02.insert(0, g_052)
        self.ENT_INDEX_022_02.place(x=150, y=600)
        self.ENT_INDEX_022_03=Entry(width=6)
        self.ENT_INDEX_022_03.insert(0, b_052)
        self.ENT_INDEX_022_03.place(x=200, y=600)
        self.IX1=Button(win, text='IX_22', command=self.IX22)
        self.IX1.place(x=250, y=600)
        #######################
        self.LAB_INDEX_023_00=Label(win, text='023')
        self.LAB_INDEX_023_00.place(x=50, y=625)
        self.ENT_INDEX_023_01=Entry(width=6)
        self.ENT_INDEX_023_01.insert(0, r_053)
        self.ENT_INDEX_023_01.place(x=100, y=625)
        self.ENT_INDEX_023_02=Entry(width=6)
        self.ENT_INDEX_023_02.insert(0, g_053)
        self.ENT_INDEX_023_02.place(x=150, y=625)
        self.ENT_INDEX_023_03=Entry(width=6)
        self.ENT_INDEX_023_03.insert(0, b_053)
        self.ENT_INDEX_023_03.place(x=200, y=625)
        self.IX1=Button(win, text='IX_23', command=self.IX23)
        self.IX1.place(x=250, y=625)
        #######################
        self.LAB_INDEX_024_00=Label(win, text='024')
        self.LAB_INDEX_024_00.place(x=50, y=650)
        self.ENT_INDEX_024_01=Entry(width=6)
        self.ENT_INDEX_024_01.insert(0, r_054)
        self.ENT_INDEX_024_01.place(x=100, y=650)
        self.ENT_INDEX_024_02=Entry(width=6)
        self.ENT_INDEX_024_02.insert(0, g_054)
        self.ENT_INDEX_024_02.place(x=150, y=650)
        self.ENT_INDEX_024_03=Entry(width=6)
        self.ENT_INDEX_024_03.insert(0, b_054)
        self.ENT_INDEX_024_03.place(x=200, y=650)
        self.IX4=Button(win, text='IX_24', command=self.IX24)
        self.IX4.place(x=250, y=650)
        #######################
        self.LAB_INDEX_025_00=Label(win, text='025')
        self.LAB_INDEX_025_00.place(x=50, y=675)
        self.ENT_INDEX_025_01=Entry(width=6)
        self.ENT_INDEX_025_01.insert(0, r_055)
        self.ENT_INDEX_025_01.place(x=100, y=675)
        self.ENT_INDEX_025_02=Entry(width=6)
        self.ENT_INDEX_025_02.insert(0, g_055)
        self.ENT_INDEX_025_02.place(x=150, y=675)
        self.ENT_INDEX_025_03=Entry(width=6)
        self.ENT_INDEX_025_03.insert(0, b_055)
        self.ENT_INDEX_025_03.place(x=200, y=675)
        self.IX1=Button(win, text='IX_25', command=self.IX25)
        self.IX1.place(x=250, y=675)
        #######################
        self.LAB_INDEX_026_00=Label(win, text='026')
        self.LAB_INDEX_026_00.place(x=50, y=700)
        self.ENT_INDEX_026_01=Entry(width=6)
        self.ENT_INDEX_026_01.insert(0, r_056)
        self.ENT_INDEX_026_01.place(x=100, y=700)
        self.ENT_INDEX_026_02=Entry(width=6)
        self.ENT_INDEX_026_02.insert(0, g_056)
        self.ENT_INDEX_026_02.place(x=150, y=700)
        self.ENT_INDEX_026_03=Entry(width=6)
        self.ENT_INDEX_026_03.insert(0, b_056)
        self.ENT_INDEX_026_03.place(x=200, y=700)
        self.IX1=Button(win, text='IX_26', command=self.IX26)
        self.IX1.place(x=250, y=700)
        #######################
        self.LAB_INDEX_027_00=Label(win, text='027')
        self.LAB_INDEX_027_00.place(x=50, y=725)
        self.ENT_INDEX_027_01=Entry(width=6)
        self.ENT_INDEX_027_01.insert(0, r_057)
        self.ENT_INDEX_027_01.place(x=100, y=725)
        self.ENT_INDEX_027_02=Entry(width=6)
        self.ENT_INDEX_027_02.insert(0, g_057)
        self.ENT_INDEX_027_02.place(x=150, y=725)
        self.ENT_INDEX_027_03=Entry(width=6)
        self.ENT_INDEX_027_03.insert(0, b_057)
        self.ENT_INDEX_027_03.place(x=200, y=725)
        self.IX1=Button(win, text='IX_27', command=self.IX27)
        self.IX1.place(x=250, y=725)
        #######################
        self.LAB_INDEX_028_00=Label(win, text='028')
        self.LAB_INDEX_028_00.place(x=50, y=750)
        self.ENT_INDEX_028_01=Entry(width=6)
        self.ENT_INDEX_028_01.insert(0, r_058)
        self.ENT_INDEX_028_01.place(x=100, y=750)
        self.ENT_INDEX_028_02=Entry(width=6)
        self.ENT_INDEX_028_02.insert(0, g_058)
        self.ENT_INDEX_028_02.place(x=150, y=750)
        self.ENT_INDEX_028_03=Entry(width=6)
        self.ENT_INDEX_028_03.insert(0, b_058)
        self.ENT_INDEX_028_03.place(x=200, y=750)
        self.IX1=Button(win, text='IX_28', command=self.IX28)
        self.IX1.place(x=250, y=750)
        #######################
        self.LAB_INDEX_029_00=Label(win, text='029')
        self.LAB_INDEX_029_00.place(x=50, y=775)
        self.ENT_INDEX_029_01=Entry(width=6)
        self.ENT_INDEX_029_01.insert(0, r_059)
        self.ENT_INDEX_029_01.place(x=100, y=775)
        self.ENT_INDEX_029_02=Entry(width=6)
        self.ENT_INDEX_029_02.insert(0, g_059)
        self.ENT_INDEX_029_02.place(x=150, y=775)
        self.ENT_INDEX_029_03=Entry(width=6)
        self.ENT_INDEX_029_03.insert(0, b_059)
        self.ENT_INDEX_029_03.place(x=200, y=775)
        self.IX1=Button(win, text='IX_29', command=self.IX29)
        self.IX1.place(x=250, y=775)
        #######################
        self.LAB_INDEX_030_00=Label(win, text='030')
        self.LAB_INDEX_030_00.place(x=50, y=800)
        self.ENT_INDEX_030_01=Entry(width=6)
        self.ENT_INDEX_030_01.insert(0, r_060)
        self.ENT_INDEX_030_01.place(x=100, y=800)
        self.ENT_INDEX_030_02=Entry(width=6)
        self.ENT_INDEX_030_02.insert(0, g_060)
        self.ENT_INDEX_030_02.place(x=150, y=800)
        self.ENT_INDEX_030_03=Entry(width=6)
        self.ENT_INDEX_030_03.insert(0, b_060)
        self.ENT_INDEX_030_03.place(x=200, y=800)
        self.IX1=Button(win, text='IX_30', command=self.IX30)
        self.IX1.place(x=250, y=800)
        #######################
        self.LAB_INDEX_001_00=Label(win, text='RGB 85-0 CLUSTER VALUES')
        self.LAB_INDEX_001_00.place(x=400, y=25)
        #######################
        self.LAB_INDEXX_001_00=Label(win, text='001')
        self.LAB_INDEXX_001_00.place(x=300, y=75)
        self.ENT_INDEXX_001_01=Entry(width=6)
        self.ENT_INDEXX_001_01.insert(0, r_001)
        self.ENT_INDEXX_001_01.place(x=400, y=75)
        self.ENT_INDEXX_001_02=Entry(width=6)
        self.ENT_INDEXX_001_02.insert(0, g_001)
        self.ENT_INDEXX_001_02.place(x=450, y=75)
        self.ENT_INDEXX_001_03=Entry(width=6)
        self.ENT_INDEXX_001_03.insert(0, b_001)
        self.ENT_INDEXX_001_03.place(x=500, y=75)
        self.IXX1=Button(win, text='IX_01', command=self.IXX1)
        self.IXX1.place(x=550, y=75)
        #######################
        self.LAB_INDEXX_002_00=Label(win, text='002')
        self.LAB_INDEXX_002_00.place(x=300, y=100)
        self.ENT_INDEXX_002_01=Entry(width=6)
        self.ENT_INDEXX_002_01.insert(0, r_002)
        self.ENT_INDEXX_002_01.place(x=400, y=100)
        self.ENT_INDEXX_002_02=Entry(width=6)
        self.ENT_INDEXX_002_02.insert(0, g_002)
        self.ENT_INDEXX_002_02.place(x=450, y=100)
        self.ENT_INDEXX_002_03=Entry(width=6)
        self.ENT_INDEXX_002_03.insert(0, b_002)
        self.ENT_INDEXX_002_03.place(x=500, y=100)
        self.IXX1=Button(win, text='IX_02', command=self.IXX2)
        self.IXX1.place(x=550, y=100)
        #######################
        self.LAB_INDEXX_003_00=Label(win, text='003')
        self.LAB_INDEXX_003_00.place(x=300, y=125)
        self.ENT_INDEXX_003_01=Entry(width=6)
        self.ENT_INDEXX_003_01.insert(0, r_003)
        self.ENT_INDEXX_003_01.place(x=400, y=125)
        self.ENT_INDEXX_003_02=Entry(width=6)
        self.ENT_INDEXX_003_02.insert(0, g_003)
        self.ENT_INDEXX_003_02.place(x=450, y=125)
        self.ENT_INDEXX_003_03=Entry(width=6)
        self.ENT_INDEXX_003_03.insert(0, b_003)
        self.ENT_INDEXX_003_03.place(x=500, y=125)
        self.IXX1=Button(win, text='IX_03', command=self.IXX3)
        self.IXX1.place(x=550, y=125)
        #######################
        self.LAB_INDEXX_004_00=Label(win, text='004')
        self.LAB_INDEXX_004_00.place(x=300, y=150)
        self.ENT_INDEXX_004_01=Entry(width=6)
        self.ENT_INDEXX_004_01.insert(0, r_004)
        self.ENT_INDEXX_004_01.place(x=400, y=150)
        self.ENT_INDEXX_004_02=Entry(width=6)
        self.ENT_INDEXX_004_02.insert(0, g_004)
        self.ENT_INDEXX_004_02.place(x=450, y=150)
        self.ENT_INDEXX_004_03=Entry(width=6)
        self.ENT_INDEXX_004_03.insert(0, b_004)
        self.ENT_INDEXX_004_03.place(x=500, y=150)
        self.IXX4=Button(win, text='IX_04', command=self.IXX4)
        self.IXX4.place(x=550, y=150)
        #######################
        self.LAB_INDEXX_005_00=Label(win, text='005')
        self.LAB_INDEXX_005_00.place(x=300, y=175)
        self.ENT_INDEXX_005_01=Entry(width=6)
        self.ENT_INDEXX_005_01.insert(0, r_005)
        self.ENT_INDEXX_005_01.place(x=400, y=175)
        self.ENT_INDEXX_005_02=Entry(width=6)
        self.ENT_INDEXX_005_02.insert(0, g_005)
        self.ENT_INDEXX_005_02.place(x=450, y=175)
        self.ENT_INDEXX_005_03=Entry(width=6)
        self.ENT_INDEXX_005_03.insert(0, b_005)
        self.ENT_INDEXX_005_03.place(x=500, y=175)
        self.IXX1=Button(win, text='IX_05', command=self.IXX5)
        self.IXX1.place(x=550, y=175)
        #######################
        self.LAB_INDEXX_006_00=Label(win, text='006')
        self.LAB_INDEXX_006_00.place(x=300, y=200)
        self.ENT_INDEXX_006_01=Entry(width=6)
        self.ENT_INDEXX_006_01.insert(0, r_006)
        self.ENT_INDEXX_006_01.place(x=400, y=200)
        self.ENT_INDEXX_006_02=Entry(width=6)
        self.ENT_INDEXX_006_02.insert(0, g_006)
        self.ENT_INDEXX_006_02.place(x=450, y=200)
        self.ENT_INDEXX_006_03=Entry(width=6)
        self.ENT_INDEXX_006_03.insert(0, b_006)
        self.ENT_INDEXX_006_03.place(x=500, y=200)
        self.IXX1=Button(win, text='IX_06', command=self.IXX6)
        self.IXX1.place(x=550, y=200)
        #######################
        self.LAB_INDEXX_007_00=Label(win, text='007')
        self.LAB_INDEXX_007_00.place(x=300, y=225)
        self.ENT_INDEXX_007_01=Entry(width=6)
        self.ENT_INDEXX_007_01.insert(0, r_007)
        self.ENT_INDEXX_007_01.place(x=400, y=225)
        self.ENT_INDEXX_007_02=Entry(width=6)
        self.ENT_INDEXX_007_02.insert(0, g_007)
        self.ENT_INDEXX_007_02.place(x=450, y=225)
        self.ENT_INDEXX_007_03=Entry(width=6)
        self.ENT_INDEXX_007_03.insert(0, b_007)
        self.ENT_INDEXX_007_03.place(x=500, y=225)
        self.IXX1=Button(win, text='IX_07', command=self.IXX7)
        self.IXX1.place(x=550, y=225)
        #######################
        self.LAB_INDEXX_008_00=Label(win, text='008')
        self.LAB_INDEXX_008_00.place(x=300, y=250)
        self.ENT_INDEXX_008_01=Entry(width=6)
        self.ENT_INDEXX_008_01.insert(0, r_008)
        self.ENT_INDEXX_008_01.place(x=400, y=250)
        self.ENT_INDEXX_008_02=Entry(width=6)
        self.ENT_INDEXX_008_02.insert(0, g_008)
        self.ENT_INDEXX_008_02.place(x=450, y=250)
        self.ENT_INDEXX_008_03=Entry(width=6)
        self.ENT_INDEXX_008_03.insert(0, b_008)
        self.ENT_INDEXX_008_03.place(x=500, y=250)
        self.IXX1=Button(win, text='IX_08', command=self.IXX8)
        self.IXX1.place(x=550, y=250)
        #######################
        self.LAB_INDEXX_009_00=Label(win, text='009')
        self.LAB_INDEXX_009_00.place(x=300, y=275)
        self.ENT_INDEXX_009_01=Entry(width=6)
        self.ENT_INDEXX_009_01.insert(0, r_009)
        self.ENT_INDEXX_009_01.place(x=400, y=275)
        self.ENT_INDEXX_009_02=Entry(width=6)
        self.ENT_INDEXX_009_02.insert(0, g_009)
        self.ENT_INDEXX_009_02.place(x=450, y=275)
        self.ENT_INDEXX_009_03=Entry(width=6)
        self.ENT_INDEXX_009_03.insert(0, b_009)
        self.ENT_INDEXX_009_03.place(x=500, y=275)
        self.IXX1=Button(win, text='IX_09', command=self.IXX9)
        self.IXX1.place(x=550, y=275)
        #######################
        self.LAB_INDEXX_010_00=Label(win, text='010')
        self.LAB_INDEXX_010_00.place(x=300, y=300)
        self.ENT_INDEXX_010_01=Entry(width=6)
        self.ENT_INDEXX_010_01.insert(0, r_010)
        self.ENT_INDEXX_010_01.place(x=400, y=300)
        self.ENT_INDEXX_010_02=Entry(width=6)
        self.ENT_INDEXX_010_02.insert(0, g_010)
        self.ENT_INDEXX_010_02.place(x=450, y=300)
        self.ENT_INDEXX_010_03=Entry(width=6)
        self.ENT_INDEXX_010_03.insert(0, b_010)
        self.ENT_INDEXX_010_03.place(x=500, y=300)
        self.IXX1=Button(win, text='IX_10', command=self.IXX10)
        self.IXX1.place(x=550, y=300)
        #######################
        self.LAB_INDEXX_011_00=Label(win, text='011')
        self.LAB_INDEXX_011_00.place(x=300, y=325)
        self.ENT_INDEXX_011_01=Entry(width=6)
        self.ENT_INDEXX_011_01.insert(0, r_011)
        self.ENT_INDEXX_011_01.place(x=400, y=325)
        self.ENT_INDEXX_011_02=Entry(width=6)
        self.ENT_INDEXX_011_02.insert(0, g_011)
        self.ENT_INDEXX_011_02.place(x=450, y=325)
        self.ENT_INDEXX_011_03=Entry(width=6)
        self.ENT_INDEXX_011_03.insert(0, b_011)
        self.ENT_INDEXX_011_03.place(x=500, y=325)
        self.IXX1=Button(win, text='IX_11', command=self.IXX11)
        self.IXX1.place(x=550, y=325)
        #######################
        self.LAB_INDEXX_012_00=Label(win, text='012')
        self.LAB_INDEXX_012_00.place(x=300, y=350)
        self.ENT_INDEXX_012_01=Entry(width=6)
        self.ENT_INDEXX_012_01.insert(0, r_012)
        self.ENT_INDEXX_012_01.place(x=400, y=350)
        self.ENT_INDEXX_012_02=Entry(width=6)
        self.ENT_INDEXX_012_02.insert(0, g_012)
        self.ENT_INDEXX_012_02.place(x=450, y=350)
        self.ENT_INDEXX_012_03=Entry(width=6)
        self.ENT_INDEXX_012_03.insert(0, b_012)
        self.ENT_INDEXX_012_03.place(x=500, y=350)
        self.IXX1=Button(win, text='IX_12', command=self.IXX12)
        self.IXX1.place(x=550, y=350)
        #######################
        self.LAB_INDEXX_013_00=Label(win, text='013')
        self.LAB_INDEXX_013_00.place(x=300, y=375)
        self.ENT_INDEXX_013_01=Entry(width=6)
        self.ENT_INDEXX_013_01.insert(0, r_013)
        self.ENT_INDEXX_013_01.place(x=400, y=375)
        self.ENT_INDEXX_013_02=Entry(width=6)
        self.ENT_INDEXX_013_02.insert(0, g_013)
        self.ENT_INDEXX_013_02.place(x=450, y=375)
        self.ENT_INDEXX_013_03=Entry(width=6)
        self.ENT_INDEXX_013_03.insert(0, b_013)
        self.ENT_INDEXX_013_03.place(x=500, y=375)
        self.IXX1=Button(win, text='IX_13', command=self.IXX13)
        self.IXX1.place(x=550, y=375)
        #######################
        self.LAB_INDEXX_014_00=Label(win, text='014')
        self.LAB_INDEXX_014_00.place(x=300, y=400)
        self.ENT_INDEXX_014_01=Entry(width=6)
        self.ENT_INDEXX_014_01.insert(0, r_014)
        self.ENT_INDEXX_014_01.place(x=400, y=400)
        self.ENT_INDEXX_014_02=Entry(width=6)
        self.ENT_INDEXX_014_02.insert(0, g_014)
        self.ENT_INDEXX_014_02.place(x=450, y=400)
        self.ENT_INDEXX_014_03=Entry(width=6)
        self.ENT_INDEXX_014_03.insert(0, b_014)
        self.ENT_INDEXX_014_03.place(x=500, y=400)
        self.IXX4=Button(win, text='IX_14', command=self.IXX14)
        self.IXX4.place(x=550, y=400)
        #######################
        self.LAB_INDEXX_015_00=Label(win, text='015')
        self.LAB_INDEXX_015_00.place(x=300, y=425)
        self.ENT_INDEXX_015_01=Entry(width=6)
        self.ENT_INDEXX_015_01.insert(0, r_015)
        self.ENT_INDEXX_015_01.place(x=400, y=425)
        self.ENT_INDEXX_015_02=Entry(width=6)
        self.ENT_INDEXX_015_02.insert(0, g_015)
        self.ENT_INDEXX_015_02.place(x=450, y=425)
        self.ENT_INDEXX_015_03=Entry(width=6)
        self.ENT_INDEXX_015_03.insert(0, b_015)
        self.ENT_INDEXX_015_03.place(x=500, y=425)
        self.IXX1=Button(win, text='IX_15', command=self.IXX15)
        self.IXX1.place(x=550, y=425)
        #######################
        self.LAB_INDEXX_016_00=Label(win, text='016')
        self.LAB_INDEXX_016_00.place(x=300, y=450)
        self.ENT_INDEXX_016_01=Entry(width=6)
        self.ENT_INDEXX_016_01.insert(0, r_016)
        self.ENT_INDEXX_016_01.place(x=400, y=450)
        self.ENT_INDEXX_016_02=Entry(width=6)
        self.ENT_INDEXX_016_02.insert(0, g_016)
        self.ENT_INDEXX_016_02.place(x=450, y=450)
        self.ENT_INDEXX_016_03=Entry(width=6)
        self.ENT_INDEXX_016_03.insert(0, b_016)
        self.ENT_INDEXX_016_03.place(x=500, y=450)
        self.IXX1=Button(win, text='IX_16', command=self.IXX16)
        self.IXX1.place(x=550, y=450)
        #######################
        self.LAB_INDEXX_017_00=Label(win, text='017')
        self.LAB_INDEXX_017_00.place(x=300, y=475)
        self.ENT_INDEXX_017_01=Entry(width=6)
        self.ENT_INDEXX_017_01.insert(0, r_017)
        self.ENT_INDEXX_017_01.place(x=400, y=475)
        self.ENT_INDEXX_017_02=Entry(width=6)
        self.ENT_INDEXX_017_02.insert(0, g_017)
        self.ENT_INDEXX_017_02.place(x=450, y=475)
        self.ENT_INDEXX_017_03=Entry(width=6)
        self.ENT_INDEXX_017_03.insert(0, b_017)
        self.ENT_INDEXX_017_03.place(x=500, y=475)
        self.IXX1=Button(win, text='IX_17', command=self.IXX17)
        self.IXX1.place(x=550, y=475)
        #######################
        self.LAB_INDEXX_018_00=Label(win, text='018')
        self.LAB_INDEXX_018_00.place(x=300, y=500)
        self.ENT_INDEXX_018_01=Entry(width=6)
        self.ENT_INDEXX_018_01.insert(0, r_018)
        self.ENT_INDEXX_018_01.place(x=400, y=500)
        self.ENT_INDEXX_018_02=Entry(width=6)
        self.ENT_INDEXX_018_02.insert(0, g_018)
        self.ENT_INDEXX_018_02.place(x=450, y=500)
        self.ENT_INDEXX_018_03=Entry(width=6)
        self.ENT_INDEXX_018_03.insert(0, b_018)
        self.ENT_INDEXX_018_03.place(x=500, y=500)
        self.IXX1=Button(win, text='IX_18', command=self.IXX18)
        self.IXX1.place(x=550, y=500)
        #######################
        self.LAB_INDEXX_019_00=Label(win, text='019')
        self.LAB_INDEXX_019_00.place(x=300, y=525)
        self.ENT_INDEXX_019_01=Entry(width=6)
        self.ENT_INDEXX_019_01.insert(0, r_019)
        self.ENT_INDEXX_019_01.place(x=400, y=525)
        self.ENT_INDEXX_019_02=Entry(width=6)
        self.ENT_INDEXX_019_02.insert(0, g_019)
        self.ENT_INDEXX_019_02.place(x=450, y=525)
        self.ENT_INDEXX_019_03=Entry(width=6)
        self.ENT_INDEXX_019_03.insert(0, b_019)
        self.ENT_INDEXX_019_03.place(x=500, y=525)
        self.IXX1=Button(win, text='IX_19', command=self.IXX19)
        self.IXX1.place(x=550, y=525)
        #######################
        self.LAB_INDEXX_020_00=Label(win, text='020')
        self.LAB_INDEXX_020_00.place(x=300, y=550)
        self.ENT_INDEXX_020_01=Entry(width=6)
        self.ENT_INDEXX_020_01.insert(0, r_020)
        self.ENT_INDEXX_020_01.place(x=400, y=550)
        self.ENT_INDEXX_020_02=Entry(width=6)
        self.ENT_INDEXX_020_02.insert(0, g_020)
        self.ENT_INDEXX_020_02.place(x=450, y=550)
        self.ENT_INDEXX_020_03=Entry(width=6)
        self.ENT_INDEXX_020_03.insert(0, b_020)
        self.ENT_INDEXX_020_03.place(x=500, y=550)
        self.IXX1=Button(win, text='IX_20', command=self.IXX20)
        self.IXX1.place(x=550, y=550)
        #######################
        self.LAB_INDEXX_021_00=Label(win, text='021')
        self.LAB_INDEXX_021_00.place(x=300, y=575)
        self.ENT_INDEXX_021_01=Entry(width=6)
        self.ENT_INDEXX_021_01.insert(0, r_021)
        self.ENT_INDEXX_021_01.place(x=400, y=575)
        self.ENT_INDEXX_021_02=Entry(width=6)
        self.ENT_INDEXX_021_02.insert(0, g_021)
        self.ENT_INDEXX_021_02.place(x=450, y=575)
        self.ENT_INDEXX_021_03=Entry(width=6)
        self.ENT_INDEXX_021_03.insert(0, b_021)
        self.ENT_INDEXX_021_03.place(x=500, y=575)
        self.IXX1=Button(win, text='IX_21', command=self.IXX21)
        self.IXX1.place(x=550, y=575)
        #######################
        self.LAB_INDEXX_022_00=Label(win, text='022')
        self.LAB_INDEXX_022_00.place(x=300, y=600)
        self.ENT_INDEXX_022_01=Entry(width=6)
        self.ENT_INDEXX_022_01.insert(0, r_022)
        self.ENT_INDEXX_022_01.place(x=400, y=600)
        self.ENT_INDEXX_022_02=Entry(width=6)
        self.ENT_INDEXX_022_02.insert(0, g_022)
        self.ENT_INDEXX_022_02.place(x=450, y=600)
        self.ENT_INDEXX_022_03=Entry(width=6)
        self.ENT_INDEXX_022_03.insert(0, b_022)
        self.ENT_INDEXX_022_03.place(x=500, y=600)
        self.IXX1=Button(win, text='IX_22', command=self.IXX22)
        self.IXX1.place(x=550, y=600)
        #######################
        self.LAB_INDEXX_023_00=Label(win, text='023')
        self.LAB_INDEXX_023_00.place(x=300, y=625)
        self.ENT_INDEXX_023_01=Entry(width=6)
        self.ENT_INDEXX_023_01.insert(0, r_023)
        self.ENT_INDEXX_023_01.place(x=400, y=625)
        self.ENT_INDEXX_023_02=Entry(width=6)
        self.ENT_INDEXX_023_02.insert(0, g_023)
        self.ENT_INDEXX_023_02.place(x=450, y=625)
        self.ENT_INDEXX_023_03=Entry(width=6)
        self.ENT_INDEXX_023_03.insert(0, b_023)
        self.ENT_INDEXX_023_03.place(x=500, y=625)
        self.IXX1=Button(win, text='IX_23', command=self.IXX23)
        self.IXX1.place(x=550, y=625)
        #######################
        self.LAB_INDEXX_024_00=Label(win, text='024')
        self.LAB_INDEXX_024_00.place(x=300, y=650)
        self.ENT_INDEXX_024_01=Entry(width=6)
        self.ENT_INDEXX_024_01.insert(0, r_024)
        self.ENT_INDEXX_024_01.place(x=400, y=650)
        self.ENT_INDEXX_024_02=Entry(width=6)
        self.ENT_INDEXX_024_02.insert(0, g_024)
        self.ENT_INDEXX_024_02.place(x=450, y=650)
        self.ENT_INDEXX_024_03=Entry(width=6)
        self.ENT_INDEXX_024_03.insert(0, b_024)
        self.ENT_INDEXX_024_03.place(x=500, y=650)
        self.IXX4=Button(win, text='IX_24', command=self.IXX24)
        self.IXX4.place(x=550, y=650)
        #######################
        self.LAB_INDEXX_025_00=Label(win, text='025')
        self.LAB_INDEXX_025_00.place(x=300, y=675)
        self.ENT_INDEXX_025_01=Entry(width=6)
        self.ENT_INDEXX_025_01.insert(0, r_025)
        self.ENT_INDEXX_025_01.place(x=400, y=675)
        self.ENT_INDEXX_025_02=Entry(width=6)
        self.ENT_INDEXX_025_02.insert(0, g_025)
        self.ENT_INDEXX_025_02.place(x=450, y=675)
        self.ENT_INDEXX_025_03=Entry(width=6)
        self.ENT_INDEXX_025_03.insert(0, b_025)
        self.ENT_INDEXX_025_03.place(x=500, y=675)
        self.IXX1=Button(win, text='IX_25', command=self.IXX25)
        self.IXX1.place(x=550, y=675)
        #######################
        self.LAB_INDEXX_026_00=Label(win, text='026')
        self.LAB_INDEXX_026_00.place(x=300, y=700)
        self.ENT_INDEXX_026_01=Entry(width=6)
        self.ENT_INDEXX_026_01.insert(0, r_026)
        self.ENT_INDEXX_026_01.place(x=400, y=700)
        self.ENT_INDEXX_026_02=Entry(width=6)
        self.ENT_INDEXX_026_02.insert(0, g_026)
        self.ENT_INDEXX_026_02.place(x=450, y=700)
        self.ENT_INDEXX_026_03=Entry(width=6)
        self.ENT_INDEXX_026_03.insert(0, b_026)
        self.ENT_INDEXX_026_03.place(x=500, y=700)
        self.IXX1=Button(win, text='IX_26', command=self.IXX26)
        self.IXX1.place(x=550, y=700)
        #######################
        self.LAB_INDEXX_027_00=Label(win, text='027')
        self.LAB_INDEXX_027_00.place(x=300, y=725)
        self.ENT_INDEXX_027_01=Entry(width=6)
        self.ENT_INDEXX_027_01.insert(0, r_027)
        self.ENT_INDEXX_027_01.place(x=400, y=725)
        self.ENT_INDEXX_027_02=Entry(width=6)
        self.ENT_INDEXX_027_02.insert(0, g_027)
        self.ENT_INDEXX_027_02.place(x=450, y=725)
        self.ENT_INDEXX_027_03=Entry(width=6)
        self.ENT_INDEXX_027_03.insert(0, b_027)
        self.ENT_INDEXX_027_03.place(x=500, y=725)
        self.IXX1=Button(win, text='IX_27', command=self.IXX27)
        self.IXX1.place(x=550, y=725)
        #######################
        self.LAB_INDEXX_028_00=Label(win, text='028')
        self.LAB_INDEXX_028_00.place(x=300, y=750)
        self.ENT_INDEXX_028_01=Entry(width=6)
        self.ENT_INDEXX_028_01.insert(0, r_028)
        self.ENT_INDEXX_028_01.place(x=400, y=750)
        self.ENT_INDEXX_028_02=Entry(width=6)
        self.ENT_INDEXX_028_02.insert(0, g_028)
        self.ENT_INDEXX_028_02.place(x=450, y=750)
        self.ENT_INDEXX_028_03=Entry(width=6)
        self.ENT_INDEXX_028_03.insert(0, b_028)
        self.ENT_INDEXX_028_03.place(x=500, y=750)
        self.IXX1=Button(win, text='IX_28', command=self.IXX28)
        self.IXX1.place(x=550, y=750)
        #######################
        self.LAB_INDEXX_029_00=Label(win, text='029')
        self.LAB_INDEXX_029_00.place(x=300, y=775)
        self.ENT_INDEXX_029_01=Entry(width=6)
        self.ENT_INDEXX_029_01.insert(0, r_029)
        self.ENT_INDEXX_029_01.place(x=400, y=775)
        self.ENT_INDEXX_029_02=Entry(width=6)
        self.ENT_INDEXX_029_02.insert(0, g_029)
        self.ENT_INDEXX_029_02.place(x=450, y=775)
        self.ENT_INDEXX_029_03=Entry(width=6)
        self.ENT_INDEXX_029_03.insert(0, b_029)
        self.ENT_INDEXX_029_03.place(x=500, y=775)
        self.IXX1=Button(win, text='IX_29', command=self.IXX29)
        self.IXX1.place(x=550, y=775)
        #######################
        self.LAB_INDEXX_030_00=Label(win, text='030')
        self.LAB_INDEXX_030_00.place(x=300, y=800)
        self.ENT_INDEXX_030_01=Entry(width=6)
        self.ENT_INDEXX_030_01.insert(0, r_030)
        self.ENT_INDEXX_030_01.place(x=400, y=800)
        self.ENT_INDEXX_030_02=Entry(width=6)
        self.ENT_INDEXX_030_02.insert(0, g_030)
        self.ENT_INDEXX_030_02.place(x=450, y=800)
        self.ENT_INDEXX_030_03=Entry(width=6)
        self.ENT_INDEXX_030_03.insert(0, b_030)
        self.ENT_INDEXX_030_03.place(x=500, y=800)
        self.IXX1=Button(win, text='IX_30', command=self.IXX30)
        self.IXX1.place(x=550, y=800)
        #######################
        self.LAB_INDEX_001_00=Label(win, text='RGB 170-255 CLUSTER VALUES')
        self.LAB_INDEX_001_00.place(x=700, y=25)
        #######################
        self.LAB_INDEXXX_001_00=Label(win, text='061')
        self.LAB_INDEXXX_001_00.place(x=600, y=75)
        self.ENT_INDEXXX_001_01=Entry(width=6)
        self.ENT_INDEXXX_001_01.insert(0, r_061)
        self.ENT_INDEXXX_001_01.place(x=700, y=75)
        self.ENT_INDEXXX_001_02=Entry(width=6)
        self.ENT_INDEXXX_001_02.insert(0, g_061)
        self.ENT_INDEXXX_001_02.place(x=750, y=75)
        self.ENT_INDEXXX_001_03=Entry(width=6)
        self.ENT_INDEXXX_001_03.insert(0, b_061)
        self.ENT_INDEXXX_001_03.place(x=800, y=75)
        self.IXXX1=Button(win, text='IX_01', command=self.IXXX1)
        self.IXXX1.place(x=850, y=75)
        #######################
        self.LAB_INDEXXX_002_00=Label(win, text='062')
        self.LAB_INDEXXX_002_00.place(x=600, y=100)
        self.ENT_INDEXXX_002_01=Entry(width=6)
        self.ENT_INDEXXX_002_01.insert(0, r_062)
        self.ENT_INDEXXX_002_01.place(x=700, y=100)
        self.ENT_INDEXXX_002_02=Entry(width=6)
        self.ENT_INDEXXX_002_02.insert(0, g_062)
        self.ENT_INDEXXX_002_02.place(x=750, y=100)
        self.ENT_INDEXXX_002_03=Entry(width=6)
        self.ENT_INDEXXX_002_03.insert(0, b_062)
        self.ENT_INDEXXX_002_03.place(x=800, y=100)
        self.IXXX1=Button(win, text='IX_02', command=self.IXXX2)
        self.IXXX1.place(x=850, y=100)
        #######################
        self.LAB_INDEXXX_003_00=Label(win, text='003')
        self.LAB_INDEXXX_003_00.place(x=600, y=125)
        self.ENT_INDEXXX_003_01=Entry(width=6)
        self.ENT_INDEXXX_003_01.insert(0, r_063)
        self.ENT_INDEXXX_003_01.place(x=700, y=125)
        self.ENT_INDEXXX_003_02=Entry(width=6)
        self.ENT_INDEXXX_003_02.insert(0, g_063)
        self.ENT_INDEXXX_003_02.place(x=750, y=125)
        self.ENT_INDEXXX_003_03=Entry(width=6)
        self.ENT_INDEXXX_003_03.insert(0, b_063)
        self.ENT_INDEXXX_003_03.place(x=800, y=125)
        self.IXXX1=Button(win, text='IX_03', command=self.IXXX3)
        self.IXXX1.place(x=850, y=125)
        #######################
        self.LAB_INDEXXX_004_00=Label(win, text='004')
        self.LAB_INDEXXX_004_00.place(x=600, y=150)
        self.ENT_INDEXXX_004_01=Entry(width=6)
        self.ENT_INDEXXX_004_01.insert(0, r_064)
        self.ENT_INDEXXX_004_01.place(x=700, y=150)
        self.ENT_INDEXXX_004_02=Entry(width=6)
        self.ENT_INDEXXX_004_02.insert(0, g_064)
        self.ENT_INDEXXX_004_02.place(x=750, y=150)
        self.ENT_INDEXXX_004_03=Entry(width=6)
        self.ENT_INDEXXX_004_03.insert(0, b_064)
        self.ENT_INDEXXX_004_03.place(x=800, y=150)
        self.IXX4=Button(win, text='IX_04', command=self.IXXX4)
        self.IXX4.place(x=850, y=150)
        #######################
        self.LAB_INDEXXX_005_00=Label(win, text='005')
        self.LAB_INDEXXX_005_00.place(x=600, y=175)
        self.ENT_INDEXXX_005_01=Entry(width=6)
        self.ENT_INDEXXX_005_01.insert(0, r_065)
        self.ENT_INDEXXX_005_01.place(x=700, y=175)
        self.ENT_INDEXXX_005_02=Entry(width=6)
        self.ENT_INDEXXX_005_02.insert(0, g_065)
        self.ENT_INDEXXX_005_02.place(x=750, y=175)
        self.ENT_INDEXXX_005_03=Entry(width=6)
        self.ENT_INDEXXX_005_03.insert(0, b_065)
        self.ENT_INDEXXX_005_03.place(x=800, y=175)
        self.IXXX1=Button(win, text='IX_05', command=self.IXXX5)
        self.IXXX1.place(x=850, y=175)
        #######################
        self.LAB_INDEXXX_006_00=Label(win, text='006')
        self.LAB_INDEXXX_006_00.place(x=600, y=200)
        self.ENT_INDEXXX_006_01=Entry(width=6)
        self.ENT_INDEXXX_006_01.insert(0, r_066)
        self.ENT_INDEXXX_006_01.place(x=700, y=200)
        self.ENT_INDEXXX_006_02=Entry(width=6)
        self.ENT_INDEXXX_006_02.insert(0, g_066)
        self.ENT_INDEXXX_006_02.place(x=750, y=200)
        self.ENT_INDEXXX_006_03=Entry(width=6)
        self.ENT_INDEXXX_006_03.insert(0, b_066)
        self.ENT_INDEXXX_006_03.place(x=800, y=200)
        self.IXXX1=Button(win, text='IX_06', command=self.IXXX6)
        self.IXXX1.place(x=850, y=200)
        #######################
        self.LAB_INDEXXX_007_00=Label(win, text='007')
        self.LAB_INDEXXX_007_00.place(x=600, y=225)
        self.ENT_INDEXXX_007_01=Entry(width=6)
        self.ENT_INDEXXX_007_01.insert(0, r_067)
        self.ENT_INDEXXX_007_01.place(x=700, y=225)
        self.ENT_INDEXXX_007_02=Entry(width=6)
        self.ENT_INDEXXX_007_02.insert(0, g_067)
        self.ENT_INDEXXX_007_02.place(x=750, y=225)
        self.ENT_INDEXXX_007_03=Entry(width=6)
        self.ENT_INDEXXX_007_03.insert(0, b_067)
        self.ENT_INDEXXX_007_03.place(x=800, y=225)
        self.IXXX1=Button(win, text='IX_07', command=self.IXXX7)
        self.IXXX1.place(x=850, y=225)
        #######################
        self.LAB_INDEXXX_008_00=Label(win, text='008')
        self.LAB_INDEXXX_008_00.place(x=600, y=250)
        self.ENT_INDEXXX_008_01=Entry(width=6)
        self.ENT_INDEXXX_008_01.insert(0, r_068)
        self.ENT_INDEXXX_008_01.place(x=700, y=250)
        self.ENT_INDEXXX_008_02=Entry(width=6)
        self.ENT_INDEXXX_008_02.insert(0, g_068)
        self.ENT_INDEXXX_008_02.place(x=750, y=250)
        self.ENT_INDEXXX_008_03=Entry(width=6)
        self.ENT_INDEXXX_008_03.insert(0, b_068)
        self.ENT_INDEXXX_008_03.place(x=800, y=250)
        self.IXXX1=Button(win, text='IX_08', command=self.IXXX8)
        self.IXXX1.place(x=850, y=250)
        #######################
        self.LAB_INDEXXX_009_00=Label(win, text='009')
        self.LAB_INDEXXX_009_00.place(x=600, y=275)
        self.ENT_INDEXXX_009_01=Entry(width=6)
        self.ENT_INDEXXX_009_01.insert(0, r_069)
        self.ENT_INDEXXX_009_01.place(x=700, y=275)
        self.ENT_INDEXXX_009_02=Entry(width=6)
        self.ENT_INDEXXX_009_02.insert(0, g_069)
        self.ENT_INDEXXX_009_02.place(x=750, y=275)
        self.ENT_INDEXXX_009_03=Entry(width=6)
        self.ENT_INDEXXX_009_03.insert(0, b_069)
        self.ENT_INDEXXX_009_03.place(x=800, y=275)
        self.IXXX1=Button(win, text='IX_09', command=self.IXXX9)
        self.IXXX1.place(x=850, y=275)
        #######################
        self.LAB_INDEXXX_010_00=Label(win, text='010')
        self.LAB_INDEXXX_010_00.place(x=600, y=300)
        self.ENT_INDEXXX_010_01=Entry(width=6)
        self.ENT_INDEXXX_010_01.insert(0, r_070)
        self.ENT_INDEXXX_010_01.place(x=700, y=300)
        self.ENT_INDEXXX_010_02=Entry(width=6)
        self.ENT_INDEXXX_010_02.insert(0, g_070)
        self.ENT_INDEXXX_010_02.place(x=750, y=300)
        self.ENT_INDEXXX_010_03=Entry(width=6)
        self.ENT_INDEXXX_010_03.insert(0, b_070)
        self.ENT_INDEXXX_010_03.place(x=800, y=300)
        self.IXXX1=Button(win, text='IX_10', command=self.IXXX10)
        self.IXXX1.place(x=850, y=300)
        #######################
        self.LAB_INDEXXX_011_00=Label(win, text='011')
        self.LAB_INDEXXX_011_00.place(x=600, y=325)
        self.ENT_INDEXXX_011_01=Entry(width=6)
        self.ENT_INDEXXX_011_01.insert(0, r_071)
        self.ENT_INDEXXX_011_01.place(x=700, y=325)
        self.ENT_INDEXXX_011_02=Entry(width=6)
        self.ENT_INDEXXX_011_02.insert(0, g_071)
        self.ENT_INDEXXX_011_02.place(x=750, y=325)
        self.ENT_INDEXXX_011_03=Entry(width=6)
        self.ENT_INDEXXX_011_03.insert(0, b_071)
        self.ENT_INDEXXX_011_03.place(x=800, y=325)
        self.IXXX1=Button(win, text='IX_11', command=self.IXXX11)
        self.IXXX1.place(x=850, y=325)
        #######################
        self.LAB_INDEXXX_012_00=Label(win, text='012')
        self.LAB_INDEXXX_012_00.place(x=600, y=350)
        self.ENT_INDEXXX_012_01=Entry(width=6)
        self.ENT_INDEXXX_012_01.insert(0, r_072)
        self.ENT_INDEXXX_012_01.place(x=700, y=350)
        self.ENT_INDEXXX_012_02=Entry(width=6)
        self.ENT_INDEXXX_012_02.insert(0, g_072)
        self.ENT_INDEXXX_012_02.place(x=750, y=350)
        self.ENT_INDEXXX_012_03=Entry(width=6)
        self.ENT_INDEXXX_012_03.insert(0, b_072)
        self.ENT_INDEXXX_012_03.place(x=800, y=350)
        self.IXXX1=Button(win, text='IX_12', command=self.IXXX12)
        self.IXXX1.place(x=850, y=350)
        #######################
        self.LAB_INDEXXX_013_00=Label(win, text='013')
        self.LAB_INDEXXX_013_00.place(x=600, y=375)
        self.ENT_INDEXXX_013_01=Entry(width=6)
        self.ENT_INDEXXX_013_01.insert(0, r_073)
        self.ENT_INDEXXX_013_01.place(x=700, y=375)
        self.ENT_INDEXXX_013_02=Entry(width=6)
        self.ENT_INDEXXX_013_02.insert(0, "30")
        self.ENT_INDEXXX_013_02.place(x=750, y=375)
        self.ENT_INDEXXX_013_03=Entry(width=6)
        self.ENT_INDEXXX_013_03.insert(0, "0")
        self.ENT_INDEXXX_013_03.place(x=800, y=375)
        self.IXXX1=Button(win, text='IX_13', command=self.IXXX13)
        self.IXXX1.place(x=850, y=375)
        #######################
        self.LAB_INDEXXX_014_00=Label(win, text='014')
        self.LAB_INDEXXX_014_00.place(x=600, y=400)
        self.ENT_INDEXXX_014_01=Entry(width=6)
        self.ENT_INDEXXX_014_01.insert(0, r_074)
        self.ENT_INDEXXX_014_01.place(x=700, y=400)
        self.ENT_INDEXXX_014_02=Entry(width=6)
        self.ENT_INDEXXX_014_02.insert(0, g_074)
        self.ENT_INDEXXX_014_02.place(x=750, y=400)
        self.ENT_INDEXXX_014_03=Entry(width=6)
        self.ENT_INDEXXX_014_03.insert(0, b_074)
        self.ENT_INDEXXX_014_03.place(x=800, y=400)
        self.IXX4=Button(win, text='IX_14', command=self.IXXX14)
        self.IXX4.place(x=850, y=400)
        #######################
        self.LAB_INDEXXX_015_00=Label(win, text='015')
        self.LAB_INDEXXX_015_00.place(x=600, y=425)
        self.ENT_INDEXXX_015_01=Entry(width=6)
        self.ENT_INDEXXX_015_01.insert(0, r_075)
        self.ENT_INDEXXX_015_01.place(x=700, y=425)
        self.ENT_INDEXXX_015_02=Entry(width=6)
        self.ENT_INDEXXX_015_02.insert(0, g_075)
        self.ENT_INDEXXX_015_02.place(x=750, y=425)
        self.ENT_INDEXXX_015_03=Entry(width=6)
        self.ENT_INDEXXX_015_03.insert(0, b_075)
        self.ENT_INDEXXX_015_03.place(x=800, y=425)
        self.IXXX1=Button(win, text='IX_15', command=self.IXXX15)
        self.IXXX1.place(x=850, y=425)
        #######################
        self.LAB_INDEXXX_016_00=Label(win, text='016')
        self.LAB_INDEXXX_016_00.place(x=600, y=450)
        self.ENT_INDEXXX_016_01=Entry(width=6)
        self.ENT_INDEXXX_016_01.insert(0, r_076)
        self.ENT_INDEXXX_016_01.place(x=700, y=450)
        self.ENT_INDEXXX_016_02=Entry(width=6)
        self.ENT_INDEXXX_016_02.insert(0, g_076)
        self.ENT_INDEXXX_016_02.place(x=750, y=450)
        self.ENT_INDEXXX_016_03=Entry(width=6)
        self.ENT_INDEXXX_016_03.insert(0, b_076)
        self.ENT_INDEXXX_016_03.place(x=800, y=450)
        self.IXXX1=Button(win, text='IX_16', command=self.IXXX16)
        self.IXXX1.place(x=850, y=450)
        #######################
        self.LAB_INDEXXX_017_00=Label(win, text='017')
        self.LAB_INDEXXX_017_00.place(x=600, y=475)
        self.ENT_INDEXXX_017_01=Entry(width=6)
        self.ENT_INDEXXX_017_01.insert(0, r_077)
        self.ENT_INDEXXX_017_01.place(x=700, y=475)
        self.ENT_INDEXXX_017_02=Entry(width=6)
        self.ENT_INDEXXX_017_02.insert(0, g_077)
        self.ENT_INDEXXX_017_02.place(x=750, y=475)
        self.ENT_INDEXXX_017_03=Entry(width=6)
        self.ENT_INDEXXX_017_03.insert(0, b_077)
        self.ENT_INDEXXX_017_03.place(x=800, y=475)
        self.IXXX1=Button(win, text='IX_17', command=self.IXXX17)
        self.IXXX1.place(x=850, y=475)
        #######################
        self.LAB_INDEXXX_018_00=Label(win, text='018')
        self.LAB_INDEXXX_018_00.place(x=600, y=500)
        self.ENT_INDEXXX_018_01=Entry(width=6)
        self.ENT_INDEXXX_018_01.insert(0, r_078)
        self.ENT_INDEXXX_018_01.place(x=700, y=500)
        self.ENT_INDEXXX_018_02=Entry(width=6)
        self.ENT_INDEXXX_018_02.insert(0, g_078)
        self.ENT_INDEXXX_018_02.place(x=750, y=500)
        self.ENT_INDEXXX_018_03=Entry(width=6)
        self.ENT_INDEXXX_018_03.insert(0, b_078)
        self.ENT_INDEXXX_018_03.place(x=800, y=500)
        self.IXXX1=Button(win, text='IX_18', command=self.IXXX18)
        self.IXXX1.place(x=850, y=500)
        #######################
        self.LAB_INDEXXX_019_00=Label(win, text='019')
        self.LAB_INDEXXX_019_00.place(x=600, y=525)
        self.ENT_INDEXXX_019_01=Entry(width=6)
        self.ENT_INDEXXX_019_01.insert(0, r_079)
        self.ENT_INDEXXX_019_01.place(x=700, y=525)
        self.ENT_INDEXXX_019_02=Entry(width=6)
        self.ENT_INDEXXX_019_02.insert(0, g_079)
        self.ENT_INDEXXX_019_02.place(x=750, y=525)
        self.ENT_INDEXXX_019_03=Entry(width=6)
        self.ENT_INDEXXX_019_03.insert(0, b_079)
        self.ENT_INDEXXX_019_03.place(x=800, y=525)
        self.IXXX1=Button(win, text='IX_19', command=self.IXXX19)
        self.IXXX1.place(x=850, y=525)
        #######################
        self.LAB_INDEXXX_020_00=Label(win, text='020')
        self.LAB_INDEXXX_020_00.place(x=600, y=550)
        self.ENT_INDEXXX_020_01=Entry(width=6)
        self.ENT_INDEXXX_020_01.insert(0, r_080)
        self.ENT_INDEXXX_020_01.place(x=700, y=550)
        self.ENT_INDEXXX_020_02=Entry(width=6)
        self.ENT_INDEXXX_020_02.insert(0, g_080)
        self.ENT_INDEXXX_020_02.place(x=750, y=550)
        self.ENT_INDEXXX_020_03=Entry(width=6)
        self.ENT_INDEXXX_020_03.insert(0, b_080)
        self.ENT_INDEXXX_020_03.place(x=800, y=550)
        self.IXXX1=Button(win, text='IX_20', command=self.IXXX20)
        self.IXXX1.place(x=850, y=550)
        #######################
        self.LAB_INDEXXX_021_00=Label(win, text='021')
        self.LAB_INDEXXX_021_00.place(x=600, y=575)
        self.ENT_INDEXXX_021_01=Entry(width=6)
        self.ENT_INDEXXX_021_01.insert(0, r_081)
        self.ENT_INDEXXX_021_01.place(x=700, y=575)
        self.ENT_INDEXXX_021_02=Entry(width=6)
        self.ENT_INDEXXX_021_02.insert(0, g_081)
        self.ENT_INDEXXX_021_02.place(x=750, y=575)
        self.ENT_INDEXXX_021_03=Entry(width=6)
        self.ENT_INDEXXX_021_03.insert(0, b_081)
        self.ENT_INDEXXX_021_03.place(x=800, y=575)
        self.IXXX1=Button(win, text='IX_21', command=self.IXXX21)
        self.IXXX1.place(x=850, y=575)
        #######################
        self.LAB_INDEXXX_022_00=Label(win, text='022')
        self.LAB_INDEXXX_022_00.place(x=600, y=600)
        self.ENT_INDEXXX_022_01=Entry(width=6)
        self.ENT_INDEXXX_022_01.insert(0, r_082)
        self.ENT_INDEXXX_022_01.place(x=700, y=600)
        self.ENT_INDEXXX_022_02=Entry(width=6)
        self.ENT_INDEXXX_022_02.insert(0, g_082)
        self.ENT_INDEXXX_022_02.place(x=750, y=600)
        self.ENT_INDEXXX_022_03=Entry(width=6)
        self.ENT_INDEXXX_022_03.insert(0, b_082)
        self.ENT_INDEXXX_022_03.place(x=800, y=600)
        self.IXXX1=Button(win, text='IX_22', command=self.IXXX22)
        self.IXXX1.place(x=850, y=600)
        #######################
        self.LAB_INDEXXX_023_00=Label(win, text='023')
        self.LAB_INDEXXX_023_00.place(x=600, y=625)
        self.ENT_INDEXXX_023_01=Entry(width=6)
        self.ENT_INDEXXX_023_01.insert(0, r_083)
        self.ENT_INDEXXX_023_01.place(x=700, y=625)
        self.ENT_INDEXXX_023_02=Entry(width=6)
        self.ENT_INDEXXX_023_02.insert(0, g_083)
        self.ENT_INDEXXX_023_02.place(x=750, y=625)
        self.ENT_INDEXXX_023_03=Entry(width=6)
        self.ENT_INDEXXX_023_03.insert(0, b_083)
        self.ENT_INDEXXX_023_03.place(x=800, y=625)
        self.IXXX1=Button(win, text='IX_23', command=self.IXXX23)
        self.IXXX1.place(x=850, y=625)
        #######################
        self.LAB_INDEXXX_024_00=Label(win, text='024')
        self.LAB_INDEXXX_024_00.place(x=600, y=650)
        self.ENT_INDEXXX_024_01=Entry(width=6)
        self.ENT_INDEXXX_024_01.insert(0, r_084)
        self.ENT_INDEXXX_024_01.place(x=700, y=650)
        self.ENT_INDEXXX_024_02=Entry(width=6)
        self.ENT_INDEXXX_024_02.insert(0, g_084)
        self.ENT_INDEXXX_024_02.place(x=750, y=650)
        self.ENT_INDEXXX_024_03=Entry(width=6)
        self.ENT_INDEXXX_024_03.insert(0, b_084)
        self.ENT_INDEXXX_024_03.place(x=800, y=650)
        self.IXX4=Button(win, text='IX_24', command=self.IXXX24)
        self.IXX4.place(x=850, y=650)
        #######################
        self.LAB_INDEXXX_025_00=Label(win, text='025')
        self.LAB_INDEXXX_025_00.place(x=600, y=675)
        self.ENT_INDEXXX_025_01=Entry(width=6)
        self.ENT_INDEXXX_025_01.insert(0, r_085)
        self.ENT_INDEXXX_025_01.place(x=700, y=675)
        self.ENT_INDEXXX_025_02=Entry(width=6)
        self.ENT_INDEXXX_025_02.insert(0, g_085)
        self.ENT_INDEXXX_025_02.place(x=750, y=675)
        self.ENT_INDEXXX_025_03=Entry(width=6)
        self.ENT_INDEXXX_025_03.insert(0, b_085)
        self.ENT_INDEXXX_025_03.place(x=800, y=675)
        self.IXXX1=Button(win, text='IX_25', command=self.IXXX25)
        self.IXXX1.place(x=850, y=675)
        #######################
        self.LAB_INDEXXX_026_00=Label(win, text='026')
        self.LAB_INDEXXX_026_00.place(x=600, y=700)
        self.ENT_INDEXXX_026_01=Entry(width=6)
        self.ENT_INDEXXX_026_01.insert(0, r_086)
        self.ENT_INDEXXX_026_01.place(x=700, y=700)
        self.ENT_INDEXXX_026_02=Entry(width=6)
        self.ENT_INDEXXX_026_02.insert(0, g_086)
        self.ENT_INDEXXX_026_02.place(x=750, y=700)
        self.ENT_INDEXXX_026_03=Entry(width=6)
        self.ENT_INDEXXX_026_03.insert(0, b_086)
        self.ENT_INDEXXX_026_03.place(x=800, y=700)
        self.IXXX1=Button(win, text='IX_26', command=self.IXXX26)
        self.IXXX1.place(x=850, y=700)
        #######################
        self.LAB_INDEXXX_027_00=Label(win, text='027')
        self.LAB_INDEXXX_027_00.place(x=600, y=725)
        self.ENT_INDEXXX_027_01=Entry(width=6)
        self.ENT_INDEXXX_027_01.insert(0, r_087)
        self.ENT_INDEXXX_027_01.place(x=700, y=725)
        self.ENT_INDEXXX_027_02=Entry(width=6)
        self.ENT_INDEXXX_027_02.insert(0, g_087)
        self.ENT_INDEXXX_027_02.place(x=750, y=725)
        self.ENT_INDEXXX_027_03=Entry(width=6)
        self.ENT_INDEXXX_027_03.insert(0, b_087)
        self.ENT_INDEXXX_027_03.place(x=800, y=725)
        self.IXXX1=Button(win, text='IX_27', command=self.IXXX27)
        self.IXXX1.place(x=850, y=725)
        #######################
        self.LAB_INDEXXX_028_00=Label(win, text='028')
        self.LAB_INDEXXX_028_00.place(x=600, y=750)
        self.ENT_INDEXXX_028_01=Entry(width=6)
        self.ENT_INDEXXX_028_01.insert(0, r_088)
        self.ENT_INDEXXX_028_01.place(x=700, y=750)
        self.ENT_INDEXXX_028_02=Entry(width=6)
        self.ENT_INDEXXX_028_02.insert(0, g_088)
        self.ENT_INDEXXX_028_02.place(x=750, y=750)
        self.ENT_INDEXXX_028_03=Entry(width=6)
        self.ENT_INDEXXX_028_03.insert(0, b_088)
        self.ENT_INDEXXX_028_03.place(x=800, y=750)
        self.IXXX1=Button(win, text='IX_28', command=self.IXXX28)
        self.IXXX1.place(x=850, y=750)
        #######################
        self.LAB_INDEXXX_029_00=Label(win, text='029')
        self.LAB_INDEXXX_029_00.place(x=600, y=775)
        self.ENT_INDEXXX_029_01=Entry(width=6)
        self.ENT_INDEXXX_029_01.insert(0, r_089)
        self.ENT_INDEXXX_029_01.place(x=700, y=775)
        self.ENT_INDEXXX_029_02=Entry(width=6)
        self.ENT_INDEXXX_029_02.insert(0, g_089)
        self.ENT_INDEXXX_029_02.place(x=750, y=775)
        self.ENT_INDEXXX_029_03=Entry(width=6)
        self.ENT_INDEXXX_029_03.insert(0, b_089)
        self.ENT_INDEXXX_029_03.place(x=800, y=775)
        self.IXXX1=Button(win, text='IX_29', command=self.IXXX29)
        self.IXXX1.place(x=850, y=775)
        #######################
        self.LAB_INDEXXX_030_00=Label(win, text='030')
        self.LAB_INDEXXX_030_00.place(x=600, y=800)
        self.ENT_INDEXXX_030_01=Entry(width=6)
        self.ENT_INDEXXX_030_01.insert(0, r_090)
        self.ENT_INDEXXX_030_01.place(x=700, y=800)
        self.ENT_INDEXXX_030_02=Entry(width=6)
        self.ENT_INDEXXX_030_02.insert(0, g_090)
        self.ENT_INDEXXX_030_02.place(x=750, y=800)
        self.ENT_INDEXXX_030_03=Entry(width=6)
        self.ENT_INDEXXX_030_03.insert(0, b_090)
        self.ENT_INDEXXX_030_03.place(x=800, y=800)
        self.IXXX1=Button(win, text='IX_30', command=self.IXXX30)
        self.IXXX1.place(x=850, y=800)
        #######################
        self.IXXX1=Button(win, text='SAVE', command=self.IXXXSAVE)
        self.IXXX1.place(x=900, y=850)
        #######################
    def IX1(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(1).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_001_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_001_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_001_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX2(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(2).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_002_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_002_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_002_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX3(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(3).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_003_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_003_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_003_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX4(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(4).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_004_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_004_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_004_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX5(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(5).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_005_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_005_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_005_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX6(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(6).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_006_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_006_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_006_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX7(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(7).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_007_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_007_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_007_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX8(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(8).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_008_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_008_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_008_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX9(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(9).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_009_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_009_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_009_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX10(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(10).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_010_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_010_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_010_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX11(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(11).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_011_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_011_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_011_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX12(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(12).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_012_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_012_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_012_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX13(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(13).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_013_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_013_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_013_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX14(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(14).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_014_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_014_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_014_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX15(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(15).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_015_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_015_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_015_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX16(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(16).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_016_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_016_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_016_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX17(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(17).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_017_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_017_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_017_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX18(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(18).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_018_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_018_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_018_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX19(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(19).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_019_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_019_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_019_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX20(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(20).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_020_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_020_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_020_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX21(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(21).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_021_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_021_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_021_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX22(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(22).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_022_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_022_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_022_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX23(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(23).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_023_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_023_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_023_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX24(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(24).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_024_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_024_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_024_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX25(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(25).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_025_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_025_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_025_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX26(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(26).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_026_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_026_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_026_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX27(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(27).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_027_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_027_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_027_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX28(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(28).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_028_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_028_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_028_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX29(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(29).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_029_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_029_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_029_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IX30(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(30).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEX_030_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEX_030_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEX_030_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX1(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(31).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_001_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_001_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_001_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX2(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(32).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_002_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_002_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_002_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX3(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(33).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_003_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_003_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_003_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX4(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(34).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_004_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_004_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_004_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX5(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(35).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_005_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_005_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_005_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX6(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(36).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_006_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_006_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_006_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX7(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(37).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_007_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_007_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_007_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX8(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(38).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_008_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_008_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_008_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX9(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(39).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_009_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_009_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_009_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX10(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(40).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_010_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_010_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_010_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX11(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(41).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_011_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_011_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_011_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX12(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(42).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_012_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_012_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_012_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX13(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(43).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_013_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_013_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_013_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX14(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(44).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_014_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_014_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_014_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX15(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(45).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_015_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_015_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_015_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX16(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(46).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_016_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_016_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_016_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX17(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(47).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_017_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_017_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_017_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX18(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(48).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_018_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_018_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_018_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX19(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(49).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_019_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_019_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_019_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX20(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(50).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_020_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_020_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_020_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX21(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(51).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_021_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_021_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_021_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX22(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(52).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_022_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_022_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_022_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX23(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(53).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_023_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_023_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_023_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX24(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(54).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_024_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_024_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_024_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX25(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(55).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_025_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_025_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_025_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX26(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(56).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_026_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_026_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_026_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX27(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(57).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_027_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_027_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_027_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX28(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(58).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_028_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_028_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_028_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX29(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(59).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_029_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_029_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_029_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXX30(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(60).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXX_030_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXX_030_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXX_030_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX1(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(61).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_001_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_001_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_001_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX2(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(62).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_002_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_002_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_002_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX3(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(63).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_003_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_003_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_003_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX4(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(64).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_004_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_004_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_004_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX5(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(65).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_005_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_005_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_005_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX6(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(66).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_006_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_006_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_006_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX7(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(67).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_007_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_007_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_007_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX8(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(68).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_008_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_008_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_008_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX9(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(69).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_009_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_009_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_009_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX10(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(70).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_010_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_010_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_010_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX11(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(71).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_011_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_011_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_011_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX12(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(72).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_012_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_012_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_012_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX13(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(73).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_013_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_013_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_013_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX14(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(74).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_014_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_014_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_014_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX15(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(75).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_015_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_015_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_015_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX16(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(76).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_016_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_016_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_016_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX17(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(77).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_017_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_017_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_017_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX18(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(78).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_018_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_018_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_018_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX19(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(79).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_019_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_019_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_019_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX20(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(80).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_020_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_020_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_020_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX21(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(81).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_021_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_021_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_021_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX22(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(82).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_022_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_022_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_022_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX23(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(83).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_023_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_023_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_023_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX24(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(84).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_024_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_024_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_024_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX25(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(85).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_025_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_025_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_025_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX26(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(86).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_026_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_026_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_026_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX27(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(87).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_027_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_027_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_027_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX28(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(88).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_028_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_028_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_028_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX29(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(89).to_bytes(2, 'little')
        IX1_01         =int(self.ENT_INDEXXX_029_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_029_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_029_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,IX1_01,IX2_02,IX3_03]), UDP)
    def IXXX30(self):
        CTR            =int(10).to_bytes(2, 'little')
        IX             =int(90).to_bytes(2, 'little')
        ix1_01         =int(self.ENT_INDEXXX_030_01.get()).to_bytes(2, 'little')
        IX2_02         =int(self.ENT_INDEXXX_030_02.get()).to_bytes(2, 'little')
        IX3_03         =int(self.ENT_INDEXXX_030_03.get()).to_bytes(2, 'little')
        s.sendto(b"".join([CTR,IX,ix1_01,IX2_02,IX3_03]), UDP)
    def IXXXSAVE(self):
        file = open("beta.txt", "w")
        file.write(self.ENT_INDEXXX_030_01.get()+"\n")
        file.write(self.ENT_INDEXXX_030_02.get()+"\n")
        file.close
        

        
        
window=Tk()
mywin=MyWindow(window)
window.title('Config Camera')
window.geometry("1000x1000+10+10")
window.mainloop()
