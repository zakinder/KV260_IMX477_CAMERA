onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib kv260_video_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {kv260_video.udo}

run -all

quit -force
