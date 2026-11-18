

################################################################################
## (c) Copyright 2014 - 2015 Xilinx, Inc. All rights reserved.	 
##   	                                						 
## This file contains confidential and proprietary information	 
## of Xilinx, Inc. and is protected under U.S. and	        	 
## international copyright and other intellectual property    	 
## laws.							                             
##   							                                 
## DISCLAIMER							                         
## This disclaimer is not a license and does not grant any	     
## rights to the materials distributed herewith. Except as	     
## otherwise provided in a valid license issued to you by	     
## Xilinx, and to the maximum extent permitted by applicable	
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND	     
## WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES	 
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING	 
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-	     
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and	     
## (2) Xilinx shall not be liable (whether in contract or tort,	 
## including negligence, or under any other theory of		     
## liability) for any loss or damage of any kind or nature	     
## related to, arising under or in connection with these	     
## materials, including for any direct, or any indirect,	    
## special, incidental, or consequential loss or damage		     
## (including loss of data, profits, goodwill, or any type of	 
## loss or damage suffered as a result of any action brought	 
## by a third party) even if such damage or loss was		     
## reasonably foreseeable or Xilinx had been advised of the	     
## possibility of the same.					                     
##   							                                 
## CRITICAL APPLICATIONS					                     
## Xilinx products are not designed or intended to be fail-	     
## safe, or for use in any application requiring fail-safe	     
## performance, such as life-support or safety devices or	     
## systems, Class III medical devices, nuclear facilities,	     
## applications related to the deployment of airbags, or any	  
## other applications that could lead to death, personal	      
## injury, or severe property or environmental damage		     
## (individually and collectively, "Critical			          
## Applications"). Customer assumes the sole risk and		     
## liability of any use of Xilinx products in Critical		     
## Applications, subject only to applicable laws and	  	     
## regulations governing limitations on product liability.	     
##   							                                 
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS	     
## PART OF THIS FILE AT ALL TIMES. 				                 
################################################################################
## XDC generated for zynquplus-xck26-sfvc784-2LV device

## False path constraint for synchronizer
#set_false_path -to [get_pins -hier *cdc_to*/D]


#set_property IS_ENABLED FALSE [get_drc_checks CLKC-4]

#################################################
## Rx DE-Skew Related constraints 
#################################################






set_max_delay -from [get_pins -hier *rxskewcalhs_reg/C] -to [get_pins -hier *deskew_start_r_reg/D ] -datapath_only 20.0


set_max_delay -from [get_pins -hier *.dl*_skewcalhs_r3_reg/C ] -to [get_pins -hier *deskew_start_r_reg/D]  -datapath_only 20.0

set_max_delay -from [get_pins -hier *iodelay_align_reg[*][*]/C ] -to [get_pins -hier *iodelay_align_fifo_reg[*][*]/D] -datapath_only 20.0

set_max_delay -from [get_pins -hier *dqsm_halft_reg[*]/C ] -to [get_pins -hier *dqsm_halft_fifo_reg[*]/D] -datapath_only 20.0

set_max_delay -reset_path 20 -to [get_pins -hier *rst_done_f_reg/D]

set_max_delay -reset_path -to [get_pins -hier *rst_done_fifo_reg/D ] 20.0



############### Waiver Start ##############################
create_waiver -internal -scope -type CDC -id {CDC-1} -user "mipi_dphy" -tag "1040228" -description "Waiving the CDC-1 for Single Bit as this signal is a stable signal & there is already a proper xdc constraint available " \
   -from [get_pins -hier *.rst_seq_done_reg/C] \
   -to [get_pins -hier *rst_done_f_reg/D]


create_waiver -internal -scope -type CDC -id {CDC-1} -user "mipi_dphy" -tag "1040228" -description "Waiving the CDC-1 for Single Bit as this signal is a stable signal & there is already a proper xdc constraint available " \
   -from [get_pins -hier *.rst_seq_done_reg/C] \
   -to [get_pins -hier *rst_done_fifo_reg/D]



create_waiver -internal -scope -type CDC -id {CDC-4} -user "mipi_dphy" -tag "1040228" -description "Waiving the CDC-4 for Multi Bit as this signal is a stable signal & there is already a proper xdc constraint available " \
   -from [get_pins -hier *dqsm_halft_reg[*]/C] \
   -to [get_pins -hier *dqsm_halft_fifo_reg[*]/D]


create_waiver -internal -scope -type CDC -id {CDC-4} -user "mipi_dphy" -tag "1040228" -description "Waiving the CDC-4 for Multi Bit as this signal is a stable signal & there is already a proper xdc constraint available " \
   -from [get_pins -hier *iodelay_align_reg[*][*]/C] \
   -to [get_pins -hier *iodelay_align_fifo_reg[*][*]/D]


create_waiver -internal -scope -type CDC -id {CDC-10} -user "mipi_dphy" -tag "1040228" -description "Waiving the CDC-10 as it will not cause any issue as there is already a proper xdc constraint available " \
   -from [get_pins -hier *.dl*_skewcalhs_r3_reg/C] \
   -to [get_pins -hier *deskew_start_r_reg/D]

create_waiver -internal -scope -type CDC -id {CDC-2} -user "mipi_dphy" -tag "1040228" -description "Waiving the CDC-2 as it will not cause any issue as there is already a proper xdc constraint available " \
   -from [get_pins -hier *.dl*_skewcalhs_r3_reg/C] \
   -to [get_pins -hier *deskew_start_r_reg/D]

create_waiver -internal -scope -type CDC -id {CDC-10} -user "mipi_dphy" -tag "1040228" -description "Waiving the CDC-10 as it will not cause any issue as there is already a custom Synchronizer available " \
   -from [get_pins -hier *align_done_deskew_reg/C] \
   -to [get_pins -hier *s_level_out_d1_cdc_to_reg/D]

############### Waiver End ##############################


create_waiver -internal -scope -type CDC -id {CDC-10} -user "mipi_dphy" -tag "1047195" -description "Waiving the CDC-10 as it will not cause any issue as the IBUFDS LPRX port driven by a constant" \
   -to [get_pins -hier *s_level_out_d1_cdc_to_reg/D]





create_waiver -internal -scope -type CDC -id {CDC-11} -user "mipi_dphy" -tag "1088530" -description "Waiving the CDC-11 , its a condition where same flop output is going to multiple synchrzrs . As the instances are created based on conditions we cannot use same synchrizr & fan-out is bound to happen & it will not cause any functional issue as its taken care in design" -from [get_pins -hier *en_hs_datapath_reg/C]
create_waiver -internal -scope -type CDC -id {CDC-11} -user "mipi_dphy" -tag "1090987" -description "Waiving the CDC-11 , as there are two different cores i.e. CSI2tx/ DSI2 controller ,  DPHY and the fanout to two different synchrzers is inevitable" -from [get_pins -hier *init_done_reg/C] 




#################################################
