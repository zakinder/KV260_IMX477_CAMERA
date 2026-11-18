// (c) Copyright(C) 2013 - 2019 by Xilinx, Inc. All rights reserved.
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

#include "bd_04f9_vfb_0_0_axisswitch_core.h"
#include <numeric>

bd_04f9_vfb_0_0_axisswitch_core::bd_04f9_vfb_0_0_axisswitch_core(sc_module_name nm, xsc::common_cpp::properties props):
  sc_module(nm)
  ,numSlv(props.getLongLong("C_NUM_SI_SLOTS"))
  ,numMst(props.getLongLong("C_NUM_MI_SLOTS"))
  ,s_decode_err("Output_decodeError")
  ,sig_sDecodeError("decode_signal")
{
  m_impl = new xsc_axis_switch("axiss", props);
  if(numSlv > 0)   S00_AXIS_TARGET_SOCKET = &(m_impl->target_socket[0]);
  if(numSlv > 1)   S01_AXIS_TARGET_SOCKET = &(m_impl->target_socket[1]);
  if(numSlv > 2)   S02_AXIS_TARGET_SOCKET = &(m_impl->target_socket[2]);
  if(numSlv > 3)   S03_AXIS_TARGET_SOCKET = &(m_impl->target_socket[3]);
  if(numSlv > 4)   S04_AXIS_TARGET_SOCKET = &(m_impl->target_socket[4]);
  if(numSlv > 5)   S05_AXIS_TARGET_SOCKET = &(m_impl->target_socket[5]);
  if(numSlv > 6)   S06_AXIS_TARGET_SOCKET = &(m_impl->target_socket[6]);
  if(numSlv > 7)   S07_AXIS_TARGET_SOCKET = &(m_impl->target_socket[7]);
  if(numSlv > 8)   S08_AXIS_TARGET_SOCKET = &(m_impl->target_socket[8]);
  if(numSlv > 9)   S09_AXIS_TARGET_SOCKET = &(m_impl->target_socket[9]);
  if(numSlv > 10)  S10_AXIS_TARGET_SOCKET = &(m_impl->target_socket[10]);
  if(numSlv > 11)  S11_AXIS_TARGET_SOCKET = &(m_impl->target_socket[11]);
  if(numSlv > 12)  S12_AXIS_TARGET_SOCKET = &(m_impl->target_socket[12]);
  if(numSlv > 13)  S13_AXIS_TARGET_SOCKET = &(m_impl->target_socket[13]);
  if(numSlv > 14)  S14_AXIS_TARGET_SOCKET = &(m_impl->target_socket[14]);
  if(numSlv > 15)  S15_AXIS_TARGET_SOCKET = &(m_impl->target_socket[15]);

  if(numMst > 0)   M00_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[0]);
  if(numMst > 1)   M01_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[1]);
  if(numMst > 2)   M02_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[2]);
  if(numMst > 3)   M03_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[3]);
  if(numMst > 4)   M04_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[4]);
  if(numMst > 5)   M05_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[5]);
  if(numMst > 6)   M06_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[6]);
  if(numMst > 7)   M07_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[7]);
  if(numMst > 8)   M08_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[8]);
  if(numMst > 9)   M09_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[9]);
  if(numMst > 10)  M10_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[10]);
  if(numMst > 11)  M11_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[11]);
  if(numMst > 12)  M12_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[12]);
  if(numMst > 13)  M13_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[13]);
  if(numMst > 14)  M14_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[14]);
  if(numMst > 15)  M15_AXIS_INITIATOR_SOCKET = &(m_impl->initiator_socket[15]);

  sig_sDecodeError.init(numSlv);
  m_impl->dec_err(sig_sDecodeError);
  
  SC_METHOD(decodeVectorToBVConverter);
  for(uint32_t it = 0; it < sig_sDecodeError.size(); it++){
    sensitive << sig_sDecodeError[it].value_changed_event();
  }
  dont_initialize();
}

void bd_04f9_vfb_0_0_axisswitch_core::decodeVectorToBVConverter(){
  uint32_t value = std::accumulate(sig_sDecodeError.begin(), sig_sDecodeError.end(), 0, [](int x, bool y){return (x<<1) | y;});
  s_decode_err.write(value);
}

bd_04f9_vfb_0_0_axisswitch_core::~bd_04f9_vfb_0_0_axisswitch_core(){
  delete m_impl;
}
