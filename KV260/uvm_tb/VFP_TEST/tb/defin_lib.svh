// Function: IMAGE_CONFIG
`define IMAGE_CONFIG(value1,value2) value1 == value2;
// Function: SV_RAND_CHECK
`define SV_RAND_CHECK(value1,value2,value3,value4) \
    if (value1 == value2) begin \
        value3 = value4; \
    end
`define display_parameter_data_s_d(ARG1) \
$display("Paramter name : %0s : %0d",`"ARG1`",ARG1);
`define display_parameter_data_s_s(ARG1) \
$display("Paramter name : %0s : %0s",`"ARG1`",ARG1);
//package frame_en_lib;
//    `define hsl_v0                      1
//endpackage