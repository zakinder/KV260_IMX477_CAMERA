// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __kv260_video_v_demosaic_1_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R_H__
#define __kv260_video_v_demosaic_1_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct kv260_video_v_demosaic_1_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R_ram : public sc_core::sc_module {

  static const unsigned DataWidth = 10;
  static const unsigned AddressRange = 1024;
  static const unsigned AddressWidth = 10;

//latency = 1
//input_reg = 1
//output_reg = 0
sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in <sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in <sc_lv<AddressWidth> > address1;
sc_core::sc_in <sc_logic> ce1;
sc_core::sc_out <sc_lv<DataWidth> > q1;
sc_core::sc_in <sc_lv<AddressWidth> > address2;
sc_core::sc_in <sc_logic> ce2;
sc_core::sc_out <sc_lv<DataWidth> > q2;
sc_core::sc_in <sc_lv<AddressWidth> > address3;
sc_core::sc_in <sc_logic> ce3;
sc_core::sc_out <sc_lv<DataWidth> > q3;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


sc_lv<DataWidth> ram[AddressRange];


   SC_CTOR(kv260_video_v_demosaic_1_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R_ram) {
        ram[0] = "0b1111111111";
        ram[1] = "0b1111111111";
        ram[2] = "0b0111111111";
        ram[3] = "0b0101010101";
        ram[4] = "0b0011111111";
        ram[5] = "0b0011001100";
        ram[6] = "0b0010101010";
        ram[7] = "0b0010010010";
        ram[8] = "0b0001111111";
        ram[9] = "0b0001110001";
        ram[10] = "0b0001100110";
        ram[11] = "0b0001011101";
        ram[12] = "0b0001010101";
        ram[13] = "0b0001001110";
        ram[14] = "0b0001001001";
        ram[15] = "0b0001000100";
        ram[16] = "0b0000111111";
        ram[17] = "0b0000111100";
        ram[18] = "0b0000111000";
        ram[19] = "0b0000110101";
        ram[20] = "0b0000110011";
        ram[21] = "0b0000110000";
        ram[22] = "0b0000101110";
        ram[23] = "0b0000101100";
        ram[24] = "0b0000101010";
        ram[25] = "0b0000101000";
        ram[26] = "0b0000100111";
        ram[27] = "0b0000100101";
        ram[28] = "0b0000100100";
        ram[29] = "0b0000100011";
        ram[30] = "0b0000100010";
        ram[31] = "0b0000100001";
        ram[32] = "0b0000011111";
        ram[33] = "0b0000011111";
        ram[34] = "0b0000011110";
        ram[35] = "0b0000011101";
        ram[36] = "0b0000011100";
        ram[37] = "0b0000011011";
        ram[38] = "0b0000011010";
        ram[39] = "0b0000011010";
        ram[40] = "0b0000011001";
        ram[41] = "0b0000011000";
        ram[42] = "0b0000011000";
        ram[43] = "0b0000010111";
        ram[44] = "0b0000010111";
        ram[45] = "0b0000010110";
        ram[46] = "0b0000010110";
        ram[47] = "0b0000010101";
        ram[48] = "0b0000010101";
        ram[49] = "0b0000010100";
        ram[50] = "0b0000010100";
        ram[51] = "0b0000010100";
        ram[52] = "0b0000010011";
        ram[53] = "0b0000010011";
        ram[54] = "0b0000010010";
        ram[55] = "0b0000010010";
        ram[56] = "0b0000010010";
        ram[57] = "0b0000010001";
        ram[58] = "0b0000010001";
        ram[59] = "0b0000010001";
        ram[60] = "0b0000010001";
        ram[61] = "0b0000010000";
        ram[62] = "0b0000010000";
        ram[63] = "0b0000010000";
        for (unsigned i = 64; i < 69 ; i = i + 1) {
            ram[i] = "0b0000001111";
        }
        for (unsigned i = 69; i < 74 ; i = i + 1) {
            ram[i] = "0b0000001110";
        }
        for (unsigned i = 74; i < 79 ; i = i + 1) {
            ram[i] = "0b0000001101";
        }
        for (unsigned i = 79; i < 86 ; i = i + 1) {
            ram[i] = "0b0000001100";
        }
        for (unsigned i = 86; i < 94 ; i = i + 1) {
            ram[i] = "0b0000001011";
        }
        for (unsigned i = 94; i < 103 ; i = i + 1) {
            ram[i] = "0b0000001010";
        }
        for (unsigned i = 103; i < 114 ; i = i + 1) {
            ram[i] = "0b0000001001";
        }
        for (unsigned i = 114; i < 128 ; i = i + 1) {
            ram[i] = "0b0000001000";
        }
        for (unsigned i = 128; i < 147 ; i = i + 1) {
            ram[i] = "0b0000000111";
        }
        for (unsigned i = 147; i < 171 ; i = i + 1) {
            ram[i] = "0b0000000110";
        }
        for (unsigned i = 171; i < 205 ; i = i + 1) {
            ram[i] = "0b0000000101";
        }
        for (unsigned i = 205; i < 256 ; i = i + 1) {
            ram[i] = "0b0000000100";
        }
        for (unsigned i = 256; i < 342 ; i = i + 1) {
            ram[i] = "0b0000000011";
        }
        for (unsigned i = 342; i < 512 ; i = i + 1) {
            ram[i] = "0b0000000010";
        }
        for (unsigned i = 512; i < 1024 ; i = i + 1) {
            ram[i] = "0b0000000001";
        }


SC_METHOD(prc_write_0);
  sensitive<<clk.pos();


SC_METHOD(prc_write_1);
  sensitive<<clk.pos();


SC_METHOD(prc_write_2);
  sensitive<<clk.pos();


SC_METHOD(prc_write_3);
  sensitive<<clk.pos();
   }


void prc_write_0()
{
    if (ce0.read() == sc_dt::Log_1) 
    {
            if(address0.read().is_01() && address0.read().to_uint()<AddressRange)
              q0 = ram[address0.read().to_uint()];
            else
              q0 = sc_lv<DataWidth>();
    }
}


void prc_write_1()
{
    if (ce1.read() == sc_dt::Log_1) 
    {
            if(address1.read().is_01() && address1.read().to_uint()<AddressRange)
              q1 = ram[address1.read().to_uint()];
            else
              q1 = sc_lv<DataWidth>();
    }
}


void prc_write_2()
{
    if (ce2.read() == sc_dt::Log_1) 
    {
            if(address2.read().is_01() && address2.read().to_uint()<AddressRange)
              q2 = ram[address2.read().to_uint()];
            else
              q2 = sc_lv<DataWidth>();
    }
}


void prc_write_3()
{
    if (ce3.read() == sc_dt::Log_1) 
    {
            if(address3.read().is_01() && address3.read().to_uint()<AddressRange)
              q3 = ram[address3.read().to_uint()];
            else
              q3 = sc_lv<DataWidth>();
    }
}


}; //endmodule


SC_MODULE(kv260_video_v_demosaic_1_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R) {


static const unsigned DataWidth = 10;
static const unsigned AddressRange = 1024;
static const unsigned AddressWidth = 10;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in <sc_lv<AddressWidth> > address1;
sc_core::sc_in<sc_logic> ce1;
sc_core::sc_out <sc_lv<DataWidth> > q1;
sc_core::sc_in <sc_lv<AddressWidth> > address2;
sc_core::sc_in<sc_logic> ce2;
sc_core::sc_out <sc_lv<DataWidth> > q2;
sc_core::sc_in <sc_lv<AddressWidth> > address3;
sc_core::sc_in<sc_logic> ce3;
sc_core::sc_out <sc_lv<DataWidth> > q3;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


kv260_video_v_demosaic_1_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R_ram* meminst;


SC_CTOR(kv260_video_v_demosaic_1_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R) {
meminst = new kv260_video_v_demosaic_1_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R_ram("kv260_video_v_demosaic_1_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->address1(address1);
meminst->ce1(ce1);
meminst->q1(q1);

meminst->address2(address2);
meminst->ce2(ce2);
meminst->q2(q2);

meminst->address3(address3);
meminst->ce3(ce3);
meminst->q3(q3);

meminst->reset(reset);
meminst->clk(clk);
}
~kv260_video_v_demosaic_1_0_DebayerG_Pipeline_VITIS_LOOP_273_4_DIV1_TABLE_ROM_AUTO_1R() {
    delete meminst;
}


};//endmodule
#endif
