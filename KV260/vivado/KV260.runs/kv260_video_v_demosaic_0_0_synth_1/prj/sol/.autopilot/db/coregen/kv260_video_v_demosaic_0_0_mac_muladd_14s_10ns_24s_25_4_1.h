// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1__HH__
#define __kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1__HH__
#include "kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1_DSP48_3.h"
#include <systemc>

template<
    int ID,
    int NUM_STAGE,
    int din0_WIDTH,
    int din1_WIDTH,
    int din2_WIDTH,
    int dout_WIDTH>
SC_MODULE(kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1) {
    sc_core::sc_in_clk clk;
    sc_core::sc_in<sc_dt::sc_logic> reset;
    sc_core::sc_in<sc_dt::sc_logic> ce;
    sc_core::sc_in< sc_dt::sc_lv<din0_WIDTH> >   din0;
    sc_core::sc_in< sc_dt::sc_lv<din1_WIDTH> >   din1;
    sc_core::sc_in< sc_dt::sc_lv<din2_WIDTH> >   din2;
    sc_core::sc_out< sc_dt::sc_lv<dout_WIDTH> >   dout;



    kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1_DSP48_3 kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1_DSP48_3_U;

    SC_CTOR(kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1):  kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1_DSP48_3_U ("kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1_DSP48_3_U") {
        kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1_DSP48_3_U.clk(clk);
        kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1_DSP48_3_U.rst(reset);
        kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1_DSP48_3_U.ce(ce);
        kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1_DSP48_3_U.in0(din0);
        kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1_DSP48_3_U.in1(din1);
        kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1_DSP48_3_U.in2(din2);
        kv260_video_v_demosaic_0_0_mac_muladd_14s_10ns_24s_25_4_1_DSP48_3_U.dout(dout);

    }

};

#endif //
