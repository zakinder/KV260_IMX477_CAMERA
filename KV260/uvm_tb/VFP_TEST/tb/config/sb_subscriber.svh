typedef class rgb_scoreboard;
class sb_subscriber extends uvm_subscriber#(d5m_trans);
    `uvm_component_utils(sb_subscriber)
    // handle: d5m_txn
    d5m_trans d5m_txn;
    covergroup rgb_cg;
        // rgb red pixel in given range coverpoint
        red_cp : coverpoint d5m_txn.d5m.rgb[7:0] {
        bins red_000_000_black      = {0}       iff(d5m_txn.d5m.lvalid == high);
        bins red_001_025_darker     = {1,25}    iff(d5m_txn.d5m.lvalid == high);
        bins red_026_050_dark       = {26,50}   iff(d5m_txn.d5m.lvalid == high);
        bins red_051_100_med_dark   = {51,100}  iff(d5m_txn.d5m.lvalid == high);
        bins red_101_150_medium     = {101,150} iff(d5m_txn.d5m.lvalid == high);
        bins red_151_200_med_light  = {151,200} iff(d5m_txn.d5m.lvalid == high);
        bins red_201_255_light      = {201,254} iff(d5m_txn.d5m.lvalid == high);
        bins red_255_255_white      = {255}     iff(d5m_txn.d5m.lvalid == high);
        }
        // rgb green pixel in given range coverpoint
        green_cp : coverpoint d5m_txn.d5m.rgb[15:8] {
        bins grn_000_000_black      = {0}       iff(d5m_txn.d5m.lvalid == high);
        bins grn_001_025_darker     = {1,25}    iff(d5m_txn.d5m.lvalid == high);
        bins grn_026_050_dark       = {26,50}   iff(d5m_txn.d5m.lvalid == high);
        bins grn_051_100_med_dark   = {51,100}  iff(d5m_txn.d5m.lvalid == high);
        bins grn_101_150_medium     = {101,150} iff(d5m_txn.d5m.lvalid == high);
        bins grn_151_200_med_light  = {151,200} iff(d5m_txn.d5m.lvalid == high);
        bins grn_201_255_light      = {201,254} iff(d5m_txn.d5m.lvalid == high);
        bins grn_255_255_white      = {255}     iff(d5m_txn.d5m.lvalid == high);
        }
        // rgb blue pixel in given range coverpoint
        blue_cp : coverpoint d5m_txn.d5m.rgb[23:16] {
        bins blu_000_000_black      = {0}       iff(d5m_txn.d5m.lvalid == high);
        bins blu_001_025_darker     = {1,25}    iff(d5m_txn.d5m.lvalid == high);
        bins blu_026_050_dark       = {26,50}   iff(d5m_txn.d5m.lvalid == high);
        bins blu_051_100_med_dark   = {51,100}  iff(d5m_txn.d5m.lvalid == high);
        bins blu_101_150_medium     = {101,150} iff(d5m_txn.d5m.lvalid == high);
        bins blu_151_200_med_light  = {151,200} iff(d5m_txn.d5m.lvalid == high);
        bins blu_201_255_light      = {201,254} iff(d5m_txn.d5m.lvalid == high);
        bins blu_255_255_white      = {255}     iff(d5m_txn.d5m.lvalid == high);
        }
        // rgb frame x coordinates coverpoint
        xCord_cp : coverpoint d5m_txn.d5m.x{
        bins left1_000_025          = {0,25};
        bins left2_026_050          = {26,50};
        bins middle_051_075         = {51,75};
        bins right1_076_100         = {76,100};
        bins right2_101_150         = {101,150};
        bins right3_151_200         = {151,200};
        }
        // rgb frame y coordinates coverpoint
        yCord_cp : coverpoint d5m_txn.d5m.y {
        bins top1_000_025           = {0,25};
        bins top2_026_050           = {26,50};
        bins middle_051_075         = {51,75};
        bins bottom1_076_100        = {76,100};
        bins bottom2_101_150        = {101,150};
        bins bottom3_151_200        = {151,200};
        }
        // rgb frame x coordinates when red pixel above given range coverpoint
        xCord_iff_cp : coverpoint d5m_txn.d5m.x[7:0] iff (d5m_txn.d5m.red > 100){
        option.at_least     = 1;
        option.auto_bin_max = 4;
        }
        // rgb frame y coordinates when red pixel above given range coverpoint
        yCord_iff_cp : coverpoint d5m_txn.d5m.y[7:0] iff (d5m_txn.d5m.red > 100){
        option.at_least     = 1;
        option.auto_bin_max = 4;
        }
        // rgb per pixel auto range coverpoints
        red_auto_pixel_cp   : coverpoint d5m_txn.d5m.red   {option.at_least = 1;option.auto_bin_max = 5;}
        gre_auto_pixel_cp   : coverpoint d5m_txn.d5m.green {option.at_least = 1;option.auto_bin_max = 5;}
        blu_auto_pixel_cp   : coverpoint d5m_txn.d5m.blue  {option.at_least = 1;option.auto_bin_max = 5;}
        // rgb per pixel color crosses for comparison
        cross_rgb           : cross red_cp,green_cp,blue_cp;
        cross_rgb_auto      : cross red_auto_pixel_cp,gre_auto_pixel_cp,blu_auto_pixel_cp;
        cross_max_rgb       : cross red_auto_pixel_cp,gre_auto_pixel_cp,blu_auto_pixel_cp,xCord_iff_cp,yCord_iff_cp;
        cross_iff_rgb       : cross red_cp,green_cp,blue_cp,xCord_iff_cp,yCord_iff_cp;
    endgroup: rgb_cg
    // Function: new
   function new( string name, uvm_component parent );
      super.new( name, parent );
      rgb_cg       = new;
   endfunction: new

    // Function: write
    function void write(d5m_trans t);
        rgb_scoreboard  rgb_sc;
        $cast(rgb_sc,m_parent);
        rgb_sc.compare(t);
        d5m_txn = t;
        rgb_cg.sample();
    endfunction: write
endclass: sb_subscriber