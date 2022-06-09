# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_vfpconfig_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_vfpconfig_HIGHADDR" -parent ${Page_0}

  ipgui::add_param $IPINST -name "revision_number"
  ipgui::add_param $IPINST -name "FRAME_HEIGHT"
  ipgui::add_param $IPINST -name "FRAME_WIDTH"
  ipgui::add_param $IPINST -name "FRAME_PIXEL_DEPTH"

}

proc update_PARAM_VALUE.C_iVideo_TDATA_WIDTH { PARAM_VALUE.C_iVideo_TDATA_WIDTH } {
	# Procedure called to update C_iVideo_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_iVideo_TDATA_WIDTH { PARAM_VALUE.C_iVideo_TDATA_WIDTH } {
	# Procedure called to validate C_iVideo_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_oVideo_START_COUNT { PARAM_VALUE.C_oVideo_START_COUNT } {
	# Procedure called to update C_oVideo_START_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_oVideo_START_COUNT { PARAM_VALUE.C_oVideo_START_COUNT } {
	# Procedure called to validate C_oVideo_START_COUNT
	return true
}

proc update_PARAM_VALUE.C_oVideo_TDATA_WIDTH { PARAM_VALUE.C_oVideo_TDATA_WIDTH } {
	# Procedure called to update C_oVideo_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_oVideo_TDATA_WIDTH { PARAM_VALUE.C_oVideo_TDATA_WIDTH } {
	# Procedure called to validate C_oVideo_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_vfpConfig_ADDR_WIDTH { PARAM_VALUE.C_vfpConfig_ADDR_WIDTH } {
	# Procedure called to update C_vfpConfig_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_vfpConfig_ADDR_WIDTH { PARAM_VALUE.C_vfpConfig_ADDR_WIDTH } {
	# Procedure called to validate C_vfpConfig_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_vfpConfig_DATA_WIDTH { PARAM_VALUE.C_vfpConfig_DATA_WIDTH } {
	# Procedure called to update C_vfpConfig_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_vfpConfig_DATA_WIDTH { PARAM_VALUE.C_vfpConfig_DATA_WIDTH } {
	# Procedure called to validate C_vfpConfig_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.FRAME_HEIGHT { PARAM_VALUE.FRAME_HEIGHT } {
	# Procedure called to update FRAME_HEIGHT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRAME_HEIGHT { PARAM_VALUE.FRAME_HEIGHT } {
	# Procedure called to validate FRAME_HEIGHT
	return true
}

proc update_PARAM_VALUE.FRAME_PIXEL_DEPTH { PARAM_VALUE.FRAME_PIXEL_DEPTH } {
	# Procedure called to update FRAME_PIXEL_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRAME_PIXEL_DEPTH { PARAM_VALUE.FRAME_PIXEL_DEPTH } {
	# Procedure called to validate FRAME_PIXEL_DEPTH
	return true
}

proc update_PARAM_VALUE.FRAME_WIDTH { PARAM_VALUE.FRAME_WIDTH } {
	# Procedure called to update FRAME_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRAME_WIDTH { PARAM_VALUE.FRAME_WIDTH } {
	# Procedure called to validate FRAME_WIDTH
	return true
}

proc update_PARAM_VALUE.revision_number { PARAM_VALUE.revision_number } {
	# Procedure called to update revision_number when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.revision_number { PARAM_VALUE.revision_number } {
	# Procedure called to validate revision_number
	return true
}

proc update_PARAM_VALUE.C_vfpconfig_BASEADDR { PARAM_VALUE.C_vfpconfig_BASEADDR } {
	# Procedure called to update C_vfpconfig_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_vfpconfig_BASEADDR { PARAM_VALUE.C_vfpconfig_BASEADDR } {
	# Procedure called to validate C_vfpconfig_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_vfpconfig_HIGHADDR { PARAM_VALUE.C_vfpconfig_HIGHADDR } {
	# Procedure called to update C_vfpconfig_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_vfpconfig_HIGHADDR { PARAM_VALUE.C_vfpconfig_HIGHADDR } {
	# Procedure called to validate C_vfpconfig_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.revision_number { MODELPARAM_VALUE.revision_number PARAM_VALUE.revision_number } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.revision_number}] ${MODELPARAM_VALUE.revision_number}
}

proc update_MODELPARAM_VALUE.C_vfpConfig_DATA_WIDTH { MODELPARAM_VALUE.C_vfpConfig_DATA_WIDTH PARAM_VALUE.C_vfpConfig_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_vfpConfig_DATA_WIDTH}] ${MODELPARAM_VALUE.C_vfpConfig_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_vfpConfig_ADDR_WIDTH { MODELPARAM_VALUE.C_vfpConfig_ADDR_WIDTH PARAM_VALUE.C_vfpConfig_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_vfpConfig_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_vfpConfig_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_oVideo_TDATA_WIDTH { MODELPARAM_VALUE.C_oVideo_TDATA_WIDTH PARAM_VALUE.C_oVideo_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_oVideo_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_oVideo_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_oVideo_START_COUNT { MODELPARAM_VALUE.C_oVideo_START_COUNT PARAM_VALUE.C_oVideo_START_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_oVideo_START_COUNT}] ${MODELPARAM_VALUE.C_oVideo_START_COUNT}
}

proc update_MODELPARAM_VALUE.C_iVideo_TDATA_WIDTH { MODELPARAM_VALUE.C_iVideo_TDATA_WIDTH PARAM_VALUE.C_iVideo_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_iVideo_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_iVideo_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.FRAME_WIDTH { MODELPARAM_VALUE.FRAME_WIDTH PARAM_VALUE.FRAME_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRAME_WIDTH}] ${MODELPARAM_VALUE.FRAME_WIDTH}
}

proc update_MODELPARAM_VALUE.FRAME_HEIGHT { MODELPARAM_VALUE.FRAME_HEIGHT PARAM_VALUE.FRAME_HEIGHT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRAME_HEIGHT}] ${MODELPARAM_VALUE.FRAME_HEIGHT}
}

proc update_MODELPARAM_VALUE.FRAME_PIXEL_DEPTH { MODELPARAM_VALUE.FRAME_PIXEL_DEPTH PARAM_VALUE.FRAME_PIXEL_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRAME_PIXEL_DEPTH}] ${MODELPARAM_VALUE.FRAME_PIXEL_DEPTH}
}

