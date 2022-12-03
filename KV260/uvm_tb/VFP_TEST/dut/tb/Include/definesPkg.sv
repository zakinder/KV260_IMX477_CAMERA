package definesPkg;

  timeunit 1ns;
  timeprecision 1ns;

  parameter WIDTH = 8;
  parameter DEPTH = 16;		// must be 2^DEPTHLOG2
  parameter DEPTHLOG2 = 4;
  // parameter CLOCK_CYCLE = 2ms;
  // parameter CLOCK_WIDTH = CLOCK_CYCLE/2;
  parameter PUSH = 0;
  parameter POP = 1;
  
typedef struct packed {
logic valid;
logic [7:0] red;
logic [7:0] green;
logic [7:0] blue;
} channels;
endpackage

