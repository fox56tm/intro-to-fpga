set_option -use_cpu_as_gpio 1 ;
set_option -synthesis_tool gowinsynthesis
set_option -top_module huffman_top ;
set_option -verilog_std sysv2017 ;

add_file -type verilog ../debouncer.sv ;
add_file -type verilog ../re_detector.sv
add_file -type verilog ../huffman_led.sv
add_file -type verilog ../demux8.sv
add_file -type verilog ../huffman_top.sv
add_file -type sdc ../timing_constraints.sdc