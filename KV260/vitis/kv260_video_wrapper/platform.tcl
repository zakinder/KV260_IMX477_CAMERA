platform generate -domains 
platform generate
platform generate
platform clean
platform generate
platform clean
platform generate
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform active {kv260_video_wrapper}
platform config -updatehw {R:/KV260/vitis/kv260_video_wrapper.xsa}
platform generate -domains 
platform config -updatehw {R:/KV260/vitis/kv260_video_wrapper.xsa}
platform generate -domains 
platform clean
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {R:/KV260/vitis/kv260_video_wrapper.xsa}
platform generate -domains 
platform clean
platform generate
platform config -updatehw {R:/KV260/vitis/kv260_video_wrapper.xsa}
platform generate -domains 
domain active {zynqmp_fsbl}
domain active {zynqmp_pmufw}
bsp reload
bsp reload
bsp reload
platform generate -domains 
domain active {standalone_domain}
bsp reload
domain create -name {jpeg_worker1} -os {standalone} -proc {psu_cortexa53_0} -arch {64-bit} -display-name {jpeg_worker1} -desc {} -runtime {cpp}
platform generate -domains 
platform write
domain -report -json
domain remove jpeg_worker1
platform generate -domains 
platform write
domain create -name {jpeg_worker1} -os {standalone} -proc {psu_cortexa53_1} -arch {64-bit} -display-name {jpeg_worker1} -desc {} -runtime {cpp}
platform generate -domains 
domain -report -json
platform write
domain create -name {jpeg_worker2} -os {standalone} -proc {psu_cortexa53_2} -arch {64-bit} -display-name {jpeg_worker2} -desc {} -runtime {cpp}
platform generate -domains 
domain -report -json
platform write
platform generate -domains jpeg_worker1,jpeg_worker2 
platform clean
platform generate
platform clean
platform generate
platform generate -domains standalone_domain,jpeg_worker1,jpeg_worker2,zynqmp_fsbl,zynqmp_pmufw 
platform generate -domains standalone_domain 
platform generate -domains standalone_domain 
platform generate -domains standalone_domain 
