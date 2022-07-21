set_property PACKAGE_PIN F10 [get_ports IIC_0_0_sda_io]
#set_property PACKAGE_PIN H12 [get_ports IIC_0_0_sda_io]

set_property PACKAGE_PIN G11 [get_ports IIC_0_0_scl_io]
#set_property PACKAGE_PIN E10 [get_ports IIC_0_0_scl_io]

set_property PACKAGE_PIN F11 [get_ports {rpi_enb[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_enb[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports IIC_0_0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports IIC_0_0_sda_io]


#ISP AP1302_RST_B HDA02
set_property PACKAGE_PIN J11 [get_ports {ap1302_rst_b}]
set_property IOSTANDARD LVCMOS33 [get_ports {ap1302_rst_b}]
set_property SLEW SLOW [get_ports {ap1302_rst_b}]
set_property DRIVE 4 [get_ports {ap1302_rst_b}]

#ISP AP1302_STANDBY HDA03
set_property PACKAGE_PIN J10 [get_ports {ap1302_standby}]
set_property IOSTANDARD LVCMOS33 [get_ports {ap1302_standby}]
set_property SLEW SLOW [get_ports {ap1302_standby}]
set_property DRIVE 4 [get_ports {ap1302_standby}]


set_property PULLUP true [get_ports IIC_0_0_scl_io]
set_property PULLUP true [get_ports IIC_0_0_sda_io]

set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]