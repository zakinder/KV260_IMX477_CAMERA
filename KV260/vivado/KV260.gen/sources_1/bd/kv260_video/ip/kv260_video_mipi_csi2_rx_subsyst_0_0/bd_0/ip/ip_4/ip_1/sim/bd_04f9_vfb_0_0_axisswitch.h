#ifndef IP_BD_04F9_VFB_0_0_AXISSWITCH_H_
#define IP_BD_04F9_VFB_0_0_AXISSWITCH_H_

// (c) Copyright 1995-2026 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


#ifndef XTLM
#include "xtlm.h"
#endif
#ifndef SYSTEMC_INCLUDED
#include <systemc>
#endif

#if defined(_MSC_VER)
#define DllExport __declspec(dllexport)
#elif defined(__GNUC__)
#define DllExport __attribute__ ((visibility("default")))
#else
#define DllExport
#endif

#include "bd_04f9_vfb_0_0_axisswitch_sc.h"




#ifdef XILINX_SIMULATOR
class DllExport bd_04f9_vfb_0_0_axisswitch : public bd_04f9_vfb_0_0_axisswitch_sc
{
public:

  bd_04f9_vfb_0_0_axisswitch(const sc_core::sc_module_name& nm);
  virtual ~bd_04f9_vfb_0_0_axisswitch();

  // module pin-to-pin RTL interface

  sc_core::sc_in< bool > aclk;
  sc_core::sc_in< bool > aresetn;
  sc_core::sc_in< sc_dt::sc_bv<1> > s_axis_tvalid;
  sc_core::sc_out< sc_dt::sc_bv<1> > s_axis_tready;
  sc_core::sc_in< sc_dt::sc_bv<64> > s_axis_tdata;
  sc_core::sc_in< sc_dt::sc_bv<8> > s_axis_tkeep;
  sc_core::sc_in< sc_dt::sc_bv<1> > s_axis_tlast;
  sc_core::sc_in< sc_dt::sc_bv<4> > s_axis_tdest;
  sc_core::sc_in< sc_dt::sc_bv<96> > s_axis_tuser;
  sc_core::sc_out< sc_dt::sc_bv<4> > m_axis_tvalid;
  sc_core::sc_in< sc_dt::sc_bv<4> > m_axis_tready;
  sc_core::sc_out< sc_dt::sc_bv<256> > m_axis_tdata;
  sc_core::sc_out< sc_dt::sc_bv<32> > m_axis_tkeep;
  sc_core::sc_out< sc_dt::sc_bv<4> > m_axis_tlast;
  sc_core::sc_out< sc_dt::sc_bv<16> > m_axis_tdest;
  sc_core::sc_out< sc_dt::sc_bv<384> > m_axis_tuser;
  sc_core::sc_out< sc_dt::sc_bv<1> > s_decode_err;

  // Dummy Signals for IP Ports


protected:

  virtual void before_end_of_elaboration();

private:

  xtlm::xaxis_pin2xtlm_t<8,96,1,4,1,1>* mp_S00_AXIS_transactor;
  xsc::common::vectorN2scalar_converter<1>* mp_s_axis_tvalid_converter;
  sc_signal< bool > m_s_axis_tvalid_converter_signal;
  xsc::common::scalar2vectorN_converter<1>* mp_s_axis_tready_converter;
  sc_signal< bool > m_s_axis_tready_converter_signal;
  xsc::common::vectorN2scalar_converter<1>* mp_s_axis_tlast_converter;
  sc_signal< bool > m_s_axis_tlast_converter_signal;
  sc_signal< bool > m_S00_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M00_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_0;
  sc_signal< bool > m_m_axis_tvalid_converter_0_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_0;
  sc_signal< bool > m_m_axis_tready_converter_0_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_0;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_0_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_0;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_0_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_0;
  sc_signal< bool > m_m_axis_tlast_converter_0_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_0;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_0_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_0;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_0_signal;
  sc_signal< bool > m_M00_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M01_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_1;
  sc_signal< bool > m_m_axis_tvalid_converter_1_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_1;
  sc_signal< bool > m_m_axis_tready_converter_1_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_1;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_1_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_1;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_1_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_1;
  sc_signal< bool > m_m_axis_tlast_converter_1_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_1;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_1_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_1;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_1_signal;
  sc_signal< bool > m_M01_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M02_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_2;
  sc_signal< bool > m_m_axis_tvalid_converter_2_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_2;
  sc_signal< bool > m_m_axis_tready_converter_2_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_2;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_2_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_2;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_2_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_2;
  sc_signal< bool > m_m_axis_tlast_converter_2_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_2;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_2_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_2;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_2_signal;
  sc_signal< bool > m_M02_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M03_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_3;
  sc_signal< bool > m_m_axis_tvalid_converter_3_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_3;
  sc_signal< bool > m_m_axis_tready_converter_3_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_3;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_3_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_3;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_3_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_3;
  sc_signal< bool > m_m_axis_tlast_converter_3_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_3;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_3_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_3;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_3_signal;
  sc_signal< bool > m_M03_AXIS_transactor_rst_signal;

  xsc::xsc_concatenator<256, 4> * mp_m_axis_concat_tdata;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_0;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_1;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_2;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_3;

  xsc::xsc_concatenator<16, 4> * mp_m_axis_concat_tdest;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_0;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_1;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_2;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_3;


  xsc::xsc_concatenator<32, 4> * mp_m_axis_concat_tkeep;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_0;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_1;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_2;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_3;

  xsc::xsc_concatenator<4, 4> * mp_m_axis_concat_tlast;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_3;

  xsc::xsc_split<4, 4> * mp_m_axis_split_tready;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_3;


  xsc::xsc_concatenator<384, 4> * mp_m_axis_concat_tuser;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_0;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_1;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_2;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_3;

  xsc::xsc_concatenator<4, 4> * mp_m_axis_concat_tvalid;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_3;

};
#endif // XILINX_SIMULATOR




#ifdef XM_SYSTEMC
class DllExport bd_04f9_vfb_0_0_axisswitch : public bd_04f9_vfb_0_0_axisswitch_sc
{
public:

  bd_04f9_vfb_0_0_axisswitch(const sc_core::sc_module_name& nm);
  virtual ~bd_04f9_vfb_0_0_axisswitch();

  // module pin-to-pin RTL interface

  sc_core::sc_in< bool > aclk;
  sc_core::sc_in< bool > aresetn;
  sc_core::sc_in< sc_dt::sc_bv<1> > s_axis_tvalid;
  sc_core::sc_out< sc_dt::sc_bv<1> > s_axis_tready;
  sc_core::sc_in< sc_dt::sc_bv<64> > s_axis_tdata;
  sc_core::sc_in< sc_dt::sc_bv<8> > s_axis_tkeep;
  sc_core::sc_in< sc_dt::sc_bv<1> > s_axis_tlast;
  sc_core::sc_in< sc_dt::sc_bv<4> > s_axis_tdest;
  sc_core::sc_in< sc_dt::sc_bv<96> > s_axis_tuser;
  sc_core::sc_out< sc_dt::sc_bv<4> > m_axis_tvalid;
  sc_core::sc_in< sc_dt::sc_bv<4> > m_axis_tready;
  sc_core::sc_out< sc_dt::sc_bv<256> > m_axis_tdata;
  sc_core::sc_out< sc_dt::sc_bv<32> > m_axis_tkeep;
  sc_core::sc_out< sc_dt::sc_bv<4> > m_axis_tlast;
  sc_core::sc_out< sc_dt::sc_bv<16> > m_axis_tdest;
  sc_core::sc_out< sc_dt::sc_bv<384> > m_axis_tuser;
  sc_core::sc_out< sc_dt::sc_bv<1> > s_decode_err;

  // Dummy Signals for IP Ports


protected:

  virtual void before_end_of_elaboration();

private:

  xtlm::xaxis_pin2xtlm_t<8,96,1,4,1,1>* mp_S00_AXIS_transactor;
  xsc::common::vectorN2scalar_converter<1>* mp_s_axis_tvalid_converter;
  sc_signal< bool > m_s_axis_tvalid_converter_signal;
  xsc::common::scalar2vectorN_converter<1>* mp_s_axis_tready_converter;
  sc_signal< bool > m_s_axis_tready_converter_signal;
  xsc::common::vectorN2scalar_converter<1>* mp_s_axis_tlast_converter;
  sc_signal< bool > m_s_axis_tlast_converter_signal;
  sc_signal< bool > m_S00_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M00_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_0;
  sc_signal< bool > m_m_axis_tvalid_converter_0_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_0;
  sc_signal< bool > m_m_axis_tready_converter_0_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_0;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_0_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_0;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_0_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_0;
  sc_signal< bool > m_m_axis_tlast_converter_0_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_0;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_0_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_0;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_0_signal;
  sc_signal< bool > m_M00_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M01_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_1;
  sc_signal< bool > m_m_axis_tvalid_converter_1_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_1;
  sc_signal< bool > m_m_axis_tready_converter_1_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_1;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_1_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_1;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_1_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_1;
  sc_signal< bool > m_m_axis_tlast_converter_1_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_1;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_1_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_1;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_1_signal;
  sc_signal< bool > m_M01_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M02_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_2;
  sc_signal< bool > m_m_axis_tvalid_converter_2_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_2;
  sc_signal< bool > m_m_axis_tready_converter_2_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_2;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_2_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_2;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_2_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_2;
  sc_signal< bool > m_m_axis_tlast_converter_2_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_2;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_2_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_2;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_2_signal;
  sc_signal< bool > m_M02_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M03_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_3;
  sc_signal< bool > m_m_axis_tvalid_converter_3_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_3;
  sc_signal< bool > m_m_axis_tready_converter_3_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_3;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_3_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_3;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_3_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_3;
  sc_signal< bool > m_m_axis_tlast_converter_3_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_3;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_3_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_3;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_3_signal;
  sc_signal< bool > m_M03_AXIS_transactor_rst_signal;

  xsc::xsc_concatenator<256, 4> * mp_m_axis_concat_tdata;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_0;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_1;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_2;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_3;

  xsc::xsc_concatenator<16, 4> * mp_m_axis_concat_tdest;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_0;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_1;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_2;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_3;


  xsc::xsc_concatenator<32, 4> * mp_m_axis_concat_tkeep;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_0;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_1;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_2;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_3;

  xsc::xsc_concatenator<4, 4> * mp_m_axis_concat_tlast;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_3;

  xsc::xsc_split<4, 4> * mp_m_axis_split_tready;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_3;


  xsc::xsc_concatenator<384, 4> * mp_m_axis_concat_tuser;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_0;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_1;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_2;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_3;

  xsc::xsc_concatenator<4, 4> * mp_m_axis_concat_tvalid;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_3;

};
#endif // XM_SYSTEMC




#ifdef RIVIERA
class DllExport bd_04f9_vfb_0_0_axisswitch : public bd_04f9_vfb_0_0_axisswitch_sc
{
public:

  bd_04f9_vfb_0_0_axisswitch(const sc_core::sc_module_name& nm);
  virtual ~bd_04f9_vfb_0_0_axisswitch();

  // module pin-to-pin RTL interface

  sc_core::sc_in< bool > aclk;
  sc_core::sc_in< bool > aresetn;
  sc_core::sc_in< sc_dt::sc_bv<1> > s_axis_tvalid;
  sc_core::sc_out< sc_dt::sc_bv<1> > s_axis_tready;
  sc_core::sc_in< sc_dt::sc_bv<64> > s_axis_tdata;
  sc_core::sc_in< sc_dt::sc_bv<8> > s_axis_tkeep;
  sc_core::sc_in< sc_dt::sc_bv<1> > s_axis_tlast;
  sc_core::sc_in< sc_dt::sc_bv<4> > s_axis_tdest;
  sc_core::sc_in< sc_dt::sc_bv<96> > s_axis_tuser;
  sc_core::sc_out< sc_dt::sc_bv<4> > m_axis_tvalid;
  sc_core::sc_in< sc_dt::sc_bv<4> > m_axis_tready;
  sc_core::sc_out< sc_dt::sc_bv<256> > m_axis_tdata;
  sc_core::sc_out< sc_dt::sc_bv<32> > m_axis_tkeep;
  sc_core::sc_out< sc_dt::sc_bv<4> > m_axis_tlast;
  sc_core::sc_out< sc_dt::sc_bv<16> > m_axis_tdest;
  sc_core::sc_out< sc_dt::sc_bv<384> > m_axis_tuser;
  sc_core::sc_out< sc_dt::sc_bv<1> > s_decode_err;

  // Dummy Signals for IP Ports


protected:

  virtual void before_end_of_elaboration();

private:

  xtlm::xaxis_pin2xtlm_t<8,96,1,4,1,1>* mp_S00_AXIS_transactor;
  xsc::common::vectorN2scalar_converter<1>* mp_s_axis_tvalid_converter;
  sc_signal< bool > m_s_axis_tvalid_converter_signal;
  xsc::common::scalar2vectorN_converter<1>* mp_s_axis_tready_converter;
  sc_signal< bool > m_s_axis_tready_converter_signal;
  xsc::common::vectorN2scalar_converter<1>* mp_s_axis_tlast_converter;
  sc_signal< bool > m_s_axis_tlast_converter_signal;
  sc_signal< bool > m_S00_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M00_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_0;
  sc_signal< bool > m_m_axis_tvalid_converter_0_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_0;
  sc_signal< bool > m_m_axis_tready_converter_0_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_0;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_0_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_0;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_0_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_0;
  sc_signal< bool > m_m_axis_tlast_converter_0_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_0;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_0_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_0;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_0_signal;
  sc_signal< bool > m_M00_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M01_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_1;
  sc_signal< bool > m_m_axis_tvalid_converter_1_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_1;
  sc_signal< bool > m_m_axis_tready_converter_1_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_1;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_1_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_1;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_1_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_1;
  sc_signal< bool > m_m_axis_tlast_converter_1_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_1;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_1_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_1;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_1_signal;
  sc_signal< bool > m_M01_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M02_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_2;
  sc_signal< bool > m_m_axis_tvalid_converter_2_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_2;
  sc_signal< bool > m_m_axis_tready_converter_2_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_2;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_2_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_2;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_2_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_2;
  sc_signal< bool > m_m_axis_tlast_converter_2_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_2;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_2_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_2;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_2_signal;
  sc_signal< bool > m_M02_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M03_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_3;
  sc_signal< bool > m_m_axis_tvalid_converter_3_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_3;
  sc_signal< bool > m_m_axis_tready_converter_3_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_3;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_3_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_3;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_3_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_3;
  sc_signal< bool > m_m_axis_tlast_converter_3_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_3;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_3_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_3;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_3_signal;
  sc_signal< bool > m_M03_AXIS_transactor_rst_signal;

  xsc::xsc_concatenator<256, 4> * mp_m_axis_concat_tdata;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_0;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_1;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_2;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_3;

  xsc::xsc_concatenator<16, 4> * mp_m_axis_concat_tdest;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_0;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_1;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_2;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_3;


  xsc::xsc_concatenator<32, 4> * mp_m_axis_concat_tkeep;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_0;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_1;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_2;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_3;

  xsc::xsc_concatenator<4, 4> * mp_m_axis_concat_tlast;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_3;

  xsc::xsc_split<4, 4> * mp_m_axis_split_tready;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_3;


  xsc::xsc_concatenator<384, 4> * mp_m_axis_concat_tuser;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_0;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_1;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_2;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_3;

  xsc::xsc_concatenator<4, 4> * mp_m_axis_concat_tvalid;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_3;

};
#endif // RIVIERA




#ifdef VCSSYSTEMC
#include "utils/xtlm_axis_initiator_stub.h"

#include "utils/xtlm_axis_target_stub.h"

class DllExport bd_04f9_vfb_0_0_axisswitch : public bd_04f9_vfb_0_0_axisswitch_sc
{
public:

  bd_04f9_vfb_0_0_axisswitch(const sc_core::sc_module_name& nm);
  virtual ~bd_04f9_vfb_0_0_axisswitch();

  // module pin-to-pin RTL interface

  sc_core::sc_in< bool > aclk;
  sc_core::sc_in< bool > aresetn;
  sc_core::sc_in< sc_dt::sc_bv<1> > s_axis_tvalid;
  sc_core::sc_out< sc_dt::sc_bv<1> > s_axis_tready;
  sc_core::sc_in< sc_dt::sc_bv<64> > s_axis_tdata;
  sc_core::sc_in< sc_dt::sc_bv<8> > s_axis_tkeep;
  sc_core::sc_in< sc_dt::sc_bv<1> > s_axis_tlast;
  sc_core::sc_in< sc_dt::sc_bv<4> > s_axis_tdest;
  sc_core::sc_in< sc_dt::sc_bv<96> > s_axis_tuser;
  sc_core::sc_out< sc_dt::sc_bv<4> > m_axis_tvalid;
  sc_core::sc_in< sc_dt::sc_bv<4> > m_axis_tready;
  sc_core::sc_out< sc_dt::sc_bv<256> > m_axis_tdata;
  sc_core::sc_out< sc_dt::sc_bv<32> > m_axis_tkeep;
  sc_core::sc_out< sc_dt::sc_bv<4> > m_axis_tlast;
  sc_core::sc_out< sc_dt::sc_bv<16> > m_axis_tdest;
  sc_core::sc_out< sc_dt::sc_bv<384> > m_axis_tuser;
  sc_core::sc_out< sc_dt::sc_bv<1> > s_decode_err;

  // Dummy Signals for IP Ports


protected:

  virtual void before_end_of_elaboration();

private:

  xtlm::xaxis_pin2xtlm_t<8,96,1,4,1,1>* mp_S00_AXIS_transactor;
  xsc::common::vectorN2scalar_converter<1>* mp_s_axis_tvalid_converter;
  sc_signal< bool > m_s_axis_tvalid_converter_signal;
  xsc::common::scalar2vectorN_converter<1>* mp_s_axis_tready_converter;
  sc_signal< bool > m_s_axis_tready_converter_signal;
  xsc::common::vectorN2scalar_converter<1>* mp_s_axis_tlast_converter;
  sc_signal< bool > m_s_axis_tlast_converter_signal;
  sc_signal< bool > m_S00_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M00_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_0;
  sc_signal< bool > m_m_axis_tvalid_converter_0_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_0;
  sc_signal< bool > m_m_axis_tready_converter_0_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_0;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_0_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_0;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_0_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_0;
  sc_signal< bool > m_m_axis_tlast_converter_0_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_0;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_0_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_0;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_0_signal;
  sc_signal< bool > m_M00_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M01_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_1;
  sc_signal< bool > m_m_axis_tvalid_converter_1_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_1;
  sc_signal< bool > m_m_axis_tready_converter_1_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_1;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_1_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_1;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_1_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_1;
  sc_signal< bool > m_m_axis_tlast_converter_1_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_1;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_1_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_1;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_1_signal;
  sc_signal< bool > m_M01_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M02_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_2;
  sc_signal< bool > m_m_axis_tvalid_converter_2_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_2;
  sc_signal< bool > m_m_axis_tready_converter_2_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_2;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_2_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_2;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_2_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_2;
  sc_signal< bool > m_m_axis_tlast_converter_2_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_2;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_2_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_2;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_2_signal;
  sc_signal< bool > m_M02_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M03_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_3;
  sc_signal< bool > m_m_axis_tvalid_converter_3_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_3;
  sc_signal< bool > m_m_axis_tready_converter_3_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_3;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_3_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_3;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_3_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_3;
  sc_signal< bool > m_m_axis_tlast_converter_3_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_3;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_3_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_3;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_3_signal;
  sc_signal< bool > m_M03_AXIS_transactor_rst_signal;

  xsc::xsc_concatenator<256, 4> * mp_m_axis_concat_tdata;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_0;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_1;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_2;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_3;

  xsc::xsc_concatenator<16, 4> * mp_m_axis_concat_tdest;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_0;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_1;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_2;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_3;


  xsc::xsc_concatenator<32, 4> * mp_m_axis_concat_tkeep;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_0;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_1;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_2;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_3;

  xsc::xsc_concatenator<4, 4> * mp_m_axis_concat_tlast;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_3;

  xsc::xsc_split<4, 4> * mp_m_axis_split_tready;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_3;


  xsc::xsc_concatenator<384, 4> * mp_m_axis_concat_tuser;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_0;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_1;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_2;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_3;

  xsc::xsc_concatenator<4, 4> * mp_m_axis_concat_tvalid;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_3;

  // Transactor stubs
  xtlm::xtlm_axis_initiator_stub * M00_AXIS_transactor_initiator_socket_stub;
  xtlm::xtlm_axis_initiator_stub * M01_AXIS_transactor_initiator_socket_stub;
  xtlm::xtlm_axis_initiator_stub * M02_AXIS_transactor_initiator_socket_stub;
  xtlm::xtlm_axis_initiator_stub * M03_AXIS_transactor_initiator_socket_stub;
  xtlm::xtlm_axis_target_stub * S00_AXIS_transactor_target_socket_stub;

  // Socket stubs

};
#endif // VCSSYSTEMC




#ifdef MTI_SYSTEMC
#include "utils/xtlm_axis_initiator_stub.h"

#include "utils/xtlm_axis_target_stub.h"

class DllExport bd_04f9_vfb_0_0_axisswitch : public bd_04f9_vfb_0_0_axisswitch_sc
{
public:

  bd_04f9_vfb_0_0_axisswitch(const sc_core::sc_module_name& nm);
  virtual ~bd_04f9_vfb_0_0_axisswitch();

  // module pin-to-pin RTL interface

  sc_core::sc_in< bool > aclk;
  sc_core::sc_in< bool > aresetn;
  sc_core::sc_in< sc_dt::sc_bv<1> > s_axis_tvalid;
  sc_core::sc_out< sc_dt::sc_bv<1> > s_axis_tready;
  sc_core::sc_in< sc_dt::sc_bv<64> > s_axis_tdata;
  sc_core::sc_in< sc_dt::sc_bv<8> > s_axis_tkeep;
  sc_core::sc_in< sc_dt::sc_bv<1> > s_axis_tlast;
  sc_core::sc_in< sc_dt::sc_bv<4> > s_axis_tdest;
  sc_core::sc_in< sc_dt::sc_bv<96> > s_axis_tuser;
  sc_core::sc_out< sc_dt::sc_bv<4> > m_axis_tvalid;
  sc_core::sc_in< sc_dt::sc_bv<4> > m_axis_tready;
  sc_core::sc_out< sc_dt::sc_bv<256> > m_axis_tdata;
  sc_core::sc_out< sc_dt::sc_bv<32> > m_axis_tkeep;
  sc_core::sc_out< sc_dt::sc_bv<4> > m_axis_tlast;
  sc_core::sc_out< sc_dt::sc_bv<16> > m_axis_tdest;
  sc_core::sc_out< sc_dt::sc_bv<384> > m_axis_tuser;
  sc_core::sc_out< sc_dt::sc_bv<1> > s_decode_err;

  // Dummy Signals for IP Ports


protected:

  virtual void before_end_of_elaboration();

private:

  xtlm::xaxis_pin2xtlm_t<8,96,1,4,1,1>* mp_S00_AXIS_transactor;
  xsc::common::vectorN2scalar_converter<1>* mp_s_axis_tvalid_converter;
  sc_signal< bool > m_s_axis_tvalid_converter_signal;
  xsc::common::scalar2vectorN_converter<1>* mp_s_axis_tready_converter;
  sc_signal< bool > m_s_axis_tready_converter_signal;
  xsc::common::vectorN2scalar_converter<1>* mp_s_axis_tlast_converter;
  sc_signal< bool > m_s_axis_tlast_converter_signal;
  sc_signal< bool > m_S00_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M00_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_0;
  sc_signal< bool > m_m_axis_tvalid_converter_0_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_0;
  sc_signal< bool > m_m_axis_tready_converter_0_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_0;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_0_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_0;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_0_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_0;
  sc_signal< bool > m_m_axis_tlast_converter_0_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_0;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_0_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_0;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_0_signal;
  sc_signal< bool > m_M00_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M01_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_1;
  sc_signal< bool > m_m_axis_tvalid_converter_1_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_1;
  sc_signal< bool > m_m_axis_tready_converter_1_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_1;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_1_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_1;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_1_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_1;
  sc_signal< bool > m_m_axis_tlast_converter_1_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_1;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_1_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_1;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_1_signal;
  sc_signal< bool > m_M01_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M02_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_2;
  sc_signal< bool > m_m_axis_tvalid_converter_2_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_2;
  sc_signal< bool > m_m_axis_tready_converter_2_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_2;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_2_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_2;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_2_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_2;
  sc_signal< bool > m_m_axis_tlast_converter_2_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_2;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_2_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_2;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_2_signal;
  sc_signal< bool > m_M02_AXIS_transactor_rst_signal;
  xtlm::xaxis_xtlm2pin_t<32,384,4,16,1,1>* mp_M03_AXIS_transactor;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tvalid_converter_3;
  sc_signal< bool > m_m_axis_tvalid_converter_3_signal;
  xsc::common::vectorN2scalar_converter<4>* mp_m_axis_tready_converter_3;
  sc_signal< bool > m_m_axis_tready_converter_3_signal;
  xsc::common::vector2vector_converter<256,256>* mp_m_axis_tdata_converter_3;
  sc_signal< sc_bv<256> > m_m_axis_tdata_converter_3_signal;
  xsc::common::vector2vector_converter<32,32>* mp_m_axis_tkeep_converter_3;
  sc_signal< sc_bv<32> > m_m_axis_tkeep_converter_3_signal;
  xsc::common::scalar2vectorN_converter<4>* mp_m_axis_tlast_converter_3;
  sc_signal< bool > m_m_axis_tlast_converter_3_signal;
  xsc::common::vector2vector_converter<16,16>* mp_m_axis_tdest_converter_3;
  sc_signal< sc_bv<16> > m_m_axis_tdest_converter_3_signal;
  xsc::common::vector2vector_converter<384,384>* mp_m_axis_tuser_converter_3;
  sc_signal< sc_bv<384> > m_m_axis_tuser_converter_3_signal;
  sc_signal< bool > m_M03_AXIS_transactor_rst_signal;

  xsc::xsc_concatenator<256, 4> * mp_m_axis_concat_tdata;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_0;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_1;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_2;
  sc_signal<sc_dt::sc_bv<256> > m_axis_concat_tdata_out_3;

  xsc::xsc_concatenator<16, 4> * mp_m_axis_concat_tdest;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_0;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_1;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_2;
  sc_signal<sc_dt::sc_bv<16> > m_axis_concat_tdest_out_3;


  xsc::xsc_concatenator<32, 4> * mp_m_axis_concat_tkeep;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_0;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_1;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_2;
  sc_signal<sc_dt::sc_bv<32> > m_axis_concat_tkeep_out_3;

  xsc::xsc_concatenator<4, 4> * mp_m_axis_concat_tlast;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tlast_out_3;

  xsc::xsc_split<4, 4> * mp_m_axis_split_tready;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_split_tready_out_3;


  xsc::xsc_concatenator<384, 4> * mp_m_axis_concat_tuser;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_0;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_1;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_2;
  sc_signal<sc_dt::sc_bv<384> > m_axis_concat_tuser_out_3;

  xsc::xsc_concatenator<4, 4> * mp_m_axis_concat_tvalid;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_0;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_1;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_2;
  sc_signal<sc_dt::sc_bv<4> > m_axis_concat_tvalid_out_3;

  // Transactor stubs
  xtlm::xtlm_axis_initiator_stub * M00_AXIS_transactor_initiator_socket_stub;
  xtlm::xtlm_axis_initiator_stub * M01_AXIS_transactor_initiator_socket_stub;
  xtlm::xtlm_axis_initiator_stub * M02_AXIS_transactor_initiator_socket_stub;
  xtlm::xtlm_axis_initiator_stub * M03_AXIS_transactor_initiator_socket_stub;
  xtlm::xtlm_axis_target_stub * S00_AXIS_transactor_target_socket_stub;

  // Socket stubs

};
#endif // MTI_SYSTEMC
#endif // IP_BD_04F9_VFB_0_0_AXISSWITCH_H_
