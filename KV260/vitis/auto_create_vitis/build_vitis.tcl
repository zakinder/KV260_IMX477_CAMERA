set tclPath [pwd]
cd $tclPath
cd ..
set projpath [pwd]
puts "Current workspace is $projpath"
setws $projpath
getws
set xsaName kv260_video_wrapper
set appName mipi

#Create a new platform
platform create -name $xsaName -hw $projpath/$xsaName.xsa -proc psu_cortexa53_0 -os standalone -arch 64-bit -out $projpath
importprojects $projpath/$xsaName
platform active $xsaName


domain active
#Create a new application
app create -name $appName -platform $xsaName -domain standalone_domain -template "Empty Application"
importsources -name $appName -path $tclPath/src/$appName

#bsp setting
bsp config zynqmp_fsbl_bsp true
bsp regenerate

bsp setlib -name xilffs -ver 4.7
bsp setlib -name lwip211 -ver 1.7
bsp config pbuf_pool_bufsize "1700"
bsp config pbuf_pool_size "16384"
bsp config memp_n_pbuf "16384"
bsp config memp_num_netbuf "8"
bsp config n_tx_descriptors "2048"
bsp config n_rx_descriptors "2048"
bsp config lwip_tcp "false"
bsp config tcp_queue_ooseq "0"
bsp config use_axieth_on_zynq "0"
bsp config use_emaclite_on_zynq "0"
bsp config dhcp_does_arp_check "true"
bsp config lwip_dhcp "true"
bsp config phy_link_speed "CONFIG_LINKSPEED1000"
bsp config udp_tx_blocking "false"
bsp config temac_use_jumbo_frames "false"
bsp config emac_number "0"

bsp regenerate
#Build platform project
platform generate
app create -name a53_fsbl -platform HW1 -template "Zynq MP FSBL" -domain A53_Standalone -lang c
app build -name a53_fsbl





#Build application project
append appName "_system"
sysproj build -name $appName
