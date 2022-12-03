import generic_pack::*;
import vfp_structs_pack::*;
module rgbAssertion(pixclk,mmclk,reset,valid,iRed,iGreen,iBlue,m_axis_mm2s_tvalid,m_axis_mm2s_tdata);
  input logic        pixclk;
  input logic        reset;
  input logic        valid;
  input logic [7:0]  iRed,iGreen,iBlue;
  input logic        mmclk;
  input logic        m_axis_mm2s_tvalid;
  input logic [23:0] m_axis_mm2s_tdata;
  int                fd_d5m_w;
  int                fd_vfp_w;
  int                fd_w;
  vfp_channels       vfp;
  vfp_channels       d5m;
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  assign vfp.completed_resolution_line_128  = (vfp.x_coord == 127);
  assign vfp.completed_resolution_line_64   = (vfp.x_coord == 63);
  assign vfp.completed_resolution_line_400  = (vfp.x_coord == 399);
  assign vfp.completed_resolution_line_1920 = (vfp.x_coord == 1919);
  assign vfp.completed_resolution64_64      = (vfp.x_coord == 63)   && (vfp.y_coord == 63);
  assign vfp.completed_resolution128_128    = (vfp.x_coord == 127)  && (vfp.y_coord == 127);
  assign vfp.completed_resolution_400_300   = (vfp.x_coord == 399)  && (vfp.y_coord == 299);
  assign vfp.completed_resolution_1920_1080 = (vfp.x_coord == 1919) && (vfp.y_coord == 1079);
  
  assign vfp.completed_resolution_line      = (vfp.x_coord == img_width_bmp-1);
  assign vfp.completed_resolution           = (vfp.x_coord == img_width_bmp-1) && (vfp.y_coord == img_height_bmp-1);
  
  
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  assign d5m.completed_resolution_line_128  = (d5m.x_coord == 127);
  assign d5m.completed_resolution_line_64   = (d5m.x_coord == 63);
  assign d5m.completed_resolution_line_400  = (d5m.x_coord == 399);
  assign d5m.completed_resolution_line_1920 = (d5m.x_coord == 1919);
  assign d5m.completed_resolution64_64      = (d5m.x_coord == 63)   && (d5m.y_coord == 63);
  assign d5m.completed_resolution128_128    = (d5m.x_coord == 127)  && (d5m.y_coord == 127);
  assign d5m.completed_resolution_400_300   = (d5m.x_coord == 399)  && (d5m.y_coord == 299);
  assign d5m.completed_resolution_1920_1080 = (d5m.x_coord == 1919) && (d5m.y_coord == 1079);
  assign d5m.completed_resolution_line      = (d5m.x_coord == img_width_bmp-1);
  assign d5m.completed_resolution           = (d5m.x_coord == img_width_bmp-1) && (d5m.y_coord == img_height_bmp-1);
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  always @(posedge pixclk) begin
      d5m.valid <= valid;
      d5m.red   <= iRed;
      d5m.green <= iGreen;
      d5m.blue  <= iBlue;
  end
  //--------------------------------------------------------------------------------------
  //--PIXCLK
  //--------------------------------------------------------------------------------------
  always @(posedge pixclk) begin
    //------------------------------------------------------------------------------------
    if (!reset) begin
      d5m.detect    <= 0;
      d5m.x_coord   <= 0;
      d5m.y_coord   <= 0;
      d5m.sim_done  <= 0;
    end
    //------------------------------------------------------------------------------------
    else if (d5m.valid && ~d5m.completed_resolution_line && ~d5m.sim_done) begin
      d5m.x_coord       <= d5m.x_coord + 1'b1;
      d5m.increment_row <= 0;
       //if ((iRed > iGreen) && (iRed > iBlue)) begin
       //  a1: assert ((iGreen > iBlue))
       //  $display("%dn %dy %dx %d %d %d",d5m.detect,y_coord,x_coord,iRed,iGreen,iBlue);
       //  d5m.detect <= d5m.detect + 1'b1;
       //end
        if (d5m.increment_row) begin
          d5m.y_coord <= d5m.y_coord + 1'b1;
        end
    end
    //------------------------------------------------------------------------------------
    else if (d5m.completed_resolution_line) begin
     d5m.x_coord         <= 0;
     d5m.increment_row   <= 1;
    end
    //------------------------------------------------------------------------------------
    //-- Frame Done
    //------------------------------------------------------------------------------------
    if (d5m.completed_resolution) begin
        d5m.sim_done <= 1;
       // a2: assert (~d5m.valid)
       //---> $display("[d5m] Y-Coord-> %d X-Coord-> %d Frame Done.",d5m.y_coord,d5m.x_coord);
    end
    //------------------------------------------------------------------------------------
    if (d5m.completed_resolution_line) begin
       //---> $display("[d5m] Y-> %d X-> %d",d5m.y_coord,d5m.x_coord);
    end
    //------------------------------------------------------------------------------------
    if (d5m.valid) begin
        $fdisplay (fd_d5m_w, "[d5m] Y = %0d X = %0d Red = %0d Green = %0d Blue = %0d",d5m.y_coord,d5m.x_coord,d5m.red,d5m.green,d5m.blue);
        $fdisplay (fd_w, "[d5m] Y = %0d X = %0d Red = %0d Green = %0d Blue = %0d",d5m.y_coord,d5m.x_coord,d5m.red,d5m.green,d5m.blue);
    end
    //------------------------------------------------------------------------------------
  end
  //--------------------------------------------------------------------------------------
  //--MMCLK
  //--------------------------------------------------------------------------------------
  always @(posedge mmclk) begin
      vfp.valid <= m_axis_mm2s_tvalid;
      vfp.red   <= m_axis_mm2s_tdata[23:16];
      vfp.green <= m_axis_mm2s_tdata[15:8];
      vfp.blue  <= m_axis_mm2s_tdata[7:0];
  end
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  always @(posedge mmclk) begin
    //------------------------------------------------------------------------------------
    if (!reset) begin
      vfp.x_coord  <= 0;
      vfp.y_coord  <= 0;
      vfp.sim_done <= 0;
    end
    //------------------------------------------------------------------------------------
    else if (vfp.valid && ~vfp.completed_resolution_line && ~vfp.sim_done) begin
      vfp.x_coord       <= vfp.x_coord + 1'b1;
      vfp.increment_row <= 0;
        if (vfp.increment_row) begin
          vfp.y_coord   <= vfp.y_coord + 1'b1;
        end
    end
    //------------------------------------------------------------------------------------
    else if (vfp.completed_resolution_line) begin
     vfp.x_coord        <= 0;
     vfp.increment_row  <= 1;
    end
    //------------------------------------------------------------------------------------
    //-- Frame Done
    //------------------------------------------------------------------------------------
    if (vfp.completed_resolution) begin
        vfp.sim_done <= 1;
     //   vfp_a1: assert (~vfp.valid)
       //---> $display("[vfp] Y-Coord-> %d X-Coord-> %d Frame Done.",vfp.y_coord,vfp.x_coord);
    end
    //------------------------------------------------------------------------------------
    if (vfp.completed_resolution_line) begin
       //---> $display("[vfp] Y-> %d X-> %d",vfp.y_coord,vfp.x_coord);
    end
    //------------------------------------------------------------------------------------
    if (vfp.valid) begin
        $fdisplay (fd_vfp_w, "[vfp] Y = %0d X = %0d Red = %0d Green = %0d Blue = %0d",vfp.y_coord,vfp.x_coord,vfp.red,vfp.green,vfp.blue);
        $fdisplay (fd_w, "[vfp] Y = %0d X = %0d Red = %0d Green = %0d Blue = %0d",vfp.y_coord,vfp.x_coord,vfp.red,vfp.green,vfp.blue);
    end
    //------------------------------------------------------------------------------------
  end
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------
  initial begin
   fd_w = $fopen ({"../data/",read_bmp,"_vfp_d5m.txt"}, "w");
  end
  //--------------------------------------------------------------------------------------
  initial begin
    fd_d5m_w = $fopen ({"../data/",read_bmp,"_d5m.txt"}, "w");
  end
  //--------------------------------------------------------------------------------------
  initial begin
    fd_vfp_w = $fopen ({"../data/",read_bmp,"_vfp.txt"}, "w");
  end
  //--------------------------------------------------------------------------------------
endmodule