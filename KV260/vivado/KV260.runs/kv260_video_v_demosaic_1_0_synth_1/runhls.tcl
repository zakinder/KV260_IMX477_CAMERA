open_project -reset prj
set_top v_demosaic
open_solution sol
set_part {xck26-sfvc784-2lv-c}
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/v_demosaic_config.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/v_demosaic.cpp
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/v_demosaic.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls_video.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls_opencv.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_axi_io.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_arithm.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_core.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_fast.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_haar.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_harris.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_histogram.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_hough.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_imgbase.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_imgproc.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_io.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_mem.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_stereobm.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_types.h
add_files -cflags " -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls -I r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src " r:/KV260/vivado/KV260.gen/sources_1/bd/kv260_video/ip/kv260_video_v_demosaic_1_0/src/hls/hls_video_undistort.h

create_clock -period 3.333 -name ap_clk


#config_interface -input_reg_mode both -output_reg_mode both


config_rtl -module_prefix kv260_video_v_demosaic_1_0_
config_export -vendor xilinx.com -library ip -version 1.1
csynth_design
export_design -format ip_catalog
exit
