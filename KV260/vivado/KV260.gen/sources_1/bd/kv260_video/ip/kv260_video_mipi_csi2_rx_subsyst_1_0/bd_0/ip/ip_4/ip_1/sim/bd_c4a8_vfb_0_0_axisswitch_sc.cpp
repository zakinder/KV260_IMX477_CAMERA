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


#include "bd_c4a8_vfb_0_0_axisswitch_sc.h"

#include "bd_c4a8_vfb_0_0_axisswitch_core.h"

#include <map>
#include <string>

bd_c4a8_vfb_0_0_axisswitch_sc::bd_c4a8_vfb_0_0_axisswitch_sc(const sc_core::sc_module_name& nm) : sc_core::sc_module(nm), mp_impl(NULL)
{
  // configure connectivity manager
  xsc::utils::xsc_sim_manager::addInstance("bd_c4a8_vfb_0_0_axisswitch", this);

  // initialize module
    xsc::common_cpp::properties model_param_props;
    model_param_props.addLong("C_NUM_SI_SLOTS", "1");
    model_param_props.addLong("C_LOG_SI_SLOTS", "1");
    model_param_props.addLong("C_NUM_MI_SLOTS", "4");
    model_param_props.addLong("C_AXIS_TDATA_WIDTH", "64");
    model_param_props.addLong("C_AXIS_TID_WIDTH", "1");
    model_param_props.addLong("C_AXIS_TDEST_WIDTH", "4");
    model_param_props.addLong("C_AXIS_TUSER_WIDTH", "96");
    model_param_props.addLong("C_ARB_ON_MAX_XFERS", "1");
    model_param_props.addLong("C_ARB_ON_NUM_CYCLES", "0");
    model_param_props.addLong("C_ARB_ON_TLAST", "0");
    model_param_props.addLong("C_INCLUDE_ARBITER", "1");
    model_param_props.addLong("C_ARB_ALGORITHM", "0");
    model_param_props.addLong("C_OUTPUT_REG", "0");
    model_param_props.addLong("C_DECODER_REG", "1");
    model_param_props.addLong("C_ROUTING_MODE", "0");
    model_param_props.addLong("C_S_AXI_CTRL_ADDR_WIDTH", "7");
    model_param_props.addLong("C_S_AXI_CTRL_DATA_WIDTH", "32");
    model_param_props.addLong("C_COMMON_CLOCK", "0");
    model_param_props.addString("C_FAMILY", "zynquplus");
    model_param_props.addBitString("C_AXIS_SIGNAL_SET", "00000000000000000000000011011011", 32);
    model_param_props.addBitString("C_M_AXIS_CONNECTIVITY_ARRAY", "1111", 4);
    model_param_props.addBitString("C_M_AXIS_BASETDEST_ARRAY", "0011001000010000", 16);
    model_param_props.addBitString("C_M_AXIS_HIGHTDEST_ARRAY", "0011001000010000", 16);
    model_param_props.addString("COMPONENT_NAME", "bd_c4a8_vfb_0_0_axisswitch");

  mp_impl = new bd_c4a8_vfb_0_0_axisswitch_core("inst", model_param_props);

  // initialize AXI sockets
  S00_AXIS_TARGET_SOCKET = mp_impl->S00_AXIS_TARGET_SOCKET;
  M00_AXIS_INITIATOR_SOCKET = mp_impl->M00_AXIS_INITIATOR_SOCKET;
  M01_AXIS_INITIATOR_SOCKET = mp_impl->M01_AXIS_INITIATOR_SOCKET;
  M02_AXIS_INITIATOR_SOCKET = mp_impl->M02_AXIS_INITIATOR_SOCKET;
  M03_AXIS_INITIATOR_SOCKET = mp_impl->M03_AXIS_INITIATOR_SOCKET;
}

bd_c4a8_vfb_0_0_axisswitch_sc::~bd_c4a8_vfb_0_0_axisswitch_sc()
{
  xsc::utils::xsc_sim_manager::clean();

  delete mp_impl;
}

