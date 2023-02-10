vlib work
vlib msim


vlib msim/unisim
vlib msim/xbip_utils_v3_0_10
vlib msim/axi_utils_v2_0_6
vlib msim/xbip_pipe_v3_0_6
vlib msim/xbip_dsp48_wrapper_v3_0_4
vlib msim/xbip_dsp48_addsub_v3_0_6
vlib msim/xbip_dsp48_multadd_v3_0_6
vlib msim/xbip_bram18k_v3_0_6
vlib msim/mult_gen_v12_0_18
vlib msim/floating_point_v7_0_20
vlib msim/xbip_dsp48_mult_v3_0_6
vlib msim/div_gen_v5_1_19
vlib msim/xil_defaultlib

vmap unisim msim/unisim
vmap xbip_utils_v3_0_10 msim/xbip_utils_v3_0_10
vmap axi_utils_v2_0_6 msim/axi_utils_v2_0_6
vmap xbip_pipe_v3_0_6 msim/xbip_pipe_v3_0_6
vmap xbip_dsp48_wrapper_v3_0_4 msim/xbip_dsp48_wrapper_v3_0_4
vmap xbip_dsp48_addsub_v3_0_6 msim/xbip_dsp48_addsub_v3_0_6
vmap xbip_dsp48_multadd_v3_0_6 msim/xbip_dsp48_multadd_v3_0_6
vmap xbip_bram18k_v3_0_6 msim/xbip_bram18k_v3_0_6
vmap mult_gen_v12_0_18 msim/mult_gen_v12_0_18
vmap floating_point_v7_0_20 msim/floating_point_v7_0_20
vmap xbip_dsp48_mult_v3_0_6 msim/xbip_dsp48_mult_v3_0_6
vmap div_gen_v5_1_19 msim/div_gen_v5_1_19
vmap xil_defaultlib msim/xil_defaultlib 

vcom  -64 -93 -work unisim                      -f C:/compile_simlib/unisim/.cxl.vhdl.unisim.unisim.nt64.cmf -f C:/compile_simlib/unisim/.cxl.vhdl.secureip_vhdl_unisim.unisim.nt64.cmf
vcom  -64 -93 -work xbip_utils_v3_0_10           -f C:/compile_simlib/xbip_utils_v3_0_10/.cxl.vhdl.xbip_utils_v3_0_10.xbip_utils_v3_0_10.nt64.cmf
vcom  -64 -93 -work axi_utils_v2_0_6            -f C:/compile_simlib/axi_utils_v2_0_6/.cxl.vhdl.axi_utils_v2_0_6.axi_utils_v2_0_6.nt64.cmf
vcom  -64 -93 -work xbip_pipe_v3_0_6            -f C:/compile_simlib/xbip_pipe_v3_0_6/.cxl.vhdl.xbip_pipe_v3_0_6.xbip_pipe_v3_0_6.nt64.cmf
vcom  -64 -93 -work xbip_dsp48_wrapper_v3_0_4   -f C:/compile_simlib/xbip_dsp48_wrapper_v3_0_4/.cxl.vhdl.xbip_dsp48_wrapper_v3_0_4.xbip_dsp48_wrapper_v3_0_4.nt64.cmf
vcom  -64 -93 -work xbip_dsp48_addsub_v3_0_6    -f C:/compile_simlib/xbip_dsp48_addsub_v3_0_6/.cxl.vhdl.xbip_dsp48_addsub_v3_0_6.xbip_dsp48_addsub_v3_0_6.nt64.cmf
vcom  -64 -93 -work xbip_dsp48_multadd_v3_0_6   -f C:/compile_simlib/xbip_dsp48_multadd_v3_0_6/.cxl.vhdl.xbip_dsp48_multadd_v3_0_6.xbip_dsp48_multadd_v3_0_6.nt64.cmf
vcom  -64 -93 -work xbip_bram18k_v3_0_6         -f C:/compile_simlib/xbip_bram18k_v3_0_6/.cxl.vhdl.xbip_bram18k_v3_0_6.xbip_bram18k_v3_0_6.nt64.cmf
vcom  -64 -93 -work mult_gen_v12_0_18           -f C:/compile_simlib/mult_gen_v12_0_18/.cxl.vhdl.mult_gen_v12_0_18.mult_gen_v12_0_18.nt64.cmf
vcom  -64 -93 -work floating_point_v7_0_20      -f C:/compile_simlib/floating_point_v7_0_20/.cxl.vhdl.floating_point_v7_0_20.floating_point_v7_0_20.nt64.cmf
vcom  -64 -93 -work xbip_dsp48_mult_v3_0_6      -f C:/compile_simlib/xbip_dsp48_mult_v3_0_6/.cxl.vhdl.xbip_dsp48_mult_v3_0_6.xbip_dsp48_mult_v3_0_6.nt64.cmf
vcom  -64 -93 -work div_gen_v5_1_19             -f C:/compile_simlib/div_gen_v5_1_19/.cxl.vhdl.div_gen_v5_1_19.div_gen_v5_1_19.nt64.cmf

set INCLUDE_FILES_SRC_DIR "../../includes"
vlog -f ${INCLUDE_FILES_SRC_DIR}/dut_sv.f
vcom -f ${INCLUDE_FILES_SRC_DIR}/dut_vhd.f

quit





