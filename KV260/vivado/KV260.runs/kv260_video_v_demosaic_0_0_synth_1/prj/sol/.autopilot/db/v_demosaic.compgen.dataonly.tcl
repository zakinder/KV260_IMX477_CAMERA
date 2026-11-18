# This script segment is generated automatically by AutoPilot

set axilite_register_dict [dict create]
set port_CTRL {
width { 
	dir I
	width 16
	depth 1
	mode ap_stable
	offset 16
	offset_end 23
}
height { 
	dir I
	width 16
	depth 1
	mode ap_stable
	offset 24
	offset_end 31
}
bayer_phase { 
	dir I
	width 16
	depth 1
	mode ap_none
	offset 40
	offset_end 47
}
ap_start { }
ap_done { }
ap_ready { }
ap_idle { }
interrupt {
}
}
dict set axilite_register_dict CTRL $port_CTRL


