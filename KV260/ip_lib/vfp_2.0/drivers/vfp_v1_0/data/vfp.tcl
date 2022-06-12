

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "vfp" "NUM_INSTANCES" "DEVICE_ID"  "C_vfpconfig_BASEADDR" "C_vfpconfig_HIGHADDR"
}
