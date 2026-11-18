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

#pragma once

#include <systemc>
#include "xtlm.h"
#include "report_handler.h"
#include "utils/xsc_stub_port.h"
#include "xsc_axis_switch.h"

class bd_04f9_vfb_0_0_axisswitch_core : public sc_core::sc_module {

	SC_HAS_PROCESS(bd_04f9_vfb_0_0_axisswitch_core);
public:
  explicit bd_04f9_vfb_0_0_axisswitch_core(sc_core::sc_module_name, xsc::common_cpp::properties);
  virtual ~bd_04f9_vfb_0_0_axisswitch_core();

  //Slave Interface
  xtlm::xtlm_axis_target_socket *S00_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S01_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S02_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S03_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S04_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S05_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S06_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S07_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S08_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S09_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S10_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S11_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S12_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S13_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S14_AXIS_TARGET_SOCKET;
  xtlm::xtlm_axis_target_socket *S15_AXIS_TARGET_SOCKET;

  //Master Interface
  xtlm::xtlm_axis_initiator_socket *M00_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M01_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M02_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M03_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M04_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M05_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M06_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M07_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M08_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M09_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M10_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M11_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M12_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M13_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M14_AXIS_INITIATOR_SOCKET;
  xtlm::xtlm_axis_initiator_socket *M15_AXIS_INITIATOR_SOCKET;

  //Decode Error Output
  sc_core::sc_out<sc_dt::sc_bv<1> > s_decode_err;
  xsc::utils::xsc_stub_port s_req_suppress;

  //main clock and reset
  sc_core::sc_in<bool> aclk;
  sc_core::sc_in<bool> aresetn;

  private:
  xsc_axis_switch *m_impl;
  unsigned int numSlv;   //number of Slave  interfaces
  unsigned int numMst;   //number of Master interfaces
  sc_core::sc_vector<sc_core::sc_signal<bool> > sig_sDecodeError;
  void decodeVectorToBVConverter();
};
