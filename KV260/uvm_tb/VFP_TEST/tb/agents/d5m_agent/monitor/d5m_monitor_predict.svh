// Class: d5m_mon_pred
class d5m_mon_pred extends uvm_monitor;

    // handle: img_pred_h
    rgb_set_frame  img_pred_h;
    
    // handle: d5m_camera_vif
    // Interafce instance
    protected virtual   d5m_camera_if d5m_camera_vif;
    
    // Id Number
    protected int       id;
    
    cell_set choices;
    
    bit[23:0] rgb;
    bit[7:0] rgb_red_data;
    bit[7:0] rgb_gre_data;
    bit[7:0] rgb_blu_data;
    
    int number_frames  = 1;
    int lval_offset    = 5;
    int lval_lines     = img_height_bmp;
    int image_width    = img_width_bmp;
    bit ImTyTest       = ImTyTest_en_patten;
    bit rImage         = rImage_disable; 
    bit fval           = fval_l;
    bit lval           = lval_l;

    //Declare analysis port
    uvm_analysis_port #(d5m_trans) d5m_mon_prd;

    protected d5m_trans pred_h;
    protected d5m_trans pred_d5m_h;
    
    
    `uvm_component_utils_begin(d5m_mon_pred)
        `uvm_field_int(id, UVM_DEFAULT)
    `uvm_component_utils_end
    
    covergroup d5m_predict_cg;
        red_predict_cp : coverpoint pred_h.vfp.red {
        bins red_000_025_darker     = {0,25};
        bins red_026_050_dark       = {26,50};
        bins red_051_100_med_dark   = {51,100};
        bins red_101_150_medium     = {101,150};
        bins red_151_200_med_light  = {151,200};
        bins red_201_255_light      = {201,255};
        }
        
        green_predict_cp : coverpoint pred_h.vfp.green {
        bins grn_000_025_darker     = {0,25};
        bins grn_026_050_dark       = {26,50};
        bins grn_051_100_med_dark   = {51,100};
        bins grn_101_150_medium     = {101,150};
        bins grn_151_200_med_light  = {151,200};
        bins grn_201_255_light      = {201,255};
        }
        
        blue_predict_cp : coverpoint pred_h.vfp.blue {
        bins blu_000_025_darker     = {0,25};
        bins blu_026_050_dark       = {26,50};
        bins blu_051_100_med_dark   = {51,100};
        bins blu_101_150_medium     = {101,150};
        bins blu_151_200_med_light  = {151,200};
        bins blu_201_255_light      = {201,255};
        }
        
        red_destination_cp : coverpoint d5m_camera_vif.d5m.rgb[7:0] {
        bins red_000_000_black      = {0}       iff(d5m_camera_vif.d5m.lvalid == high);
        bins red_001_025_darker     = {1,25}    iff(d5m_camera_vif.d5m.lvalid == high);
        bins red_026_050_dark       = {26,50}   iff(d5m_camera_vif.d5m.lvalid == high);
        bins red_051_100_med_dark   = {51,100}  iff(d5m_camera_vif.d5m.lvalid == high);
        bins red_101_150_medium     = {101,150} iff(d5m_camera_vif.d5m.lvalid == high);
        bins red_151_200_med_light  = {151,200} iff(d5m_camera_vif.d5m.lvalid == high);
        bins red_201_255_light      = {201,254} iff(d5m_camera_vif.d5m.lvalid == high);
        bins red_255_255_white      = {255}     iff(d5m_camera_vif.d5m.lvalid == high);
        }
        
        green_destination_cp : coverpoint d5m_camera_vif.d5m.rgb[15:8] {
        bins grn_000_000_black      = {0}       iff(d5m_camera_vif.d5m.lvalid == high);
        bins grn_001_025_darker     = {1,25}    iff(d5m_camera_vif.d5m.lvalid == high);
        bins grn_026_050_dark       = {26,50}   iff(d5m_camera_vif.d5m.lvalid == high);
        bins grn_051_100_med_dark   = {51,100}  iff(d5m_camera_vif.d5m.lvalid == high);
        bins grn_101_150_medium     = {101,150} iff(d5m_camera_vif.d5m.lvalid == high);
        bins grn_151_200_med_light  = {151,200} iff(d5m_camera_vif.d5m.lvalid == high);
        bins grn_201_255_light      = {201,254} iff(d5m_camera_vif.d5m.lvalid == high);
        bins grn_255_255_white      = {255}     iff(d5m_camera_vif.d5m.lvalid == high);
        }
        
        blue_destination_cp : coverpoint d5m_camera_vif.d5m.rgb[23:16] {
        bins blu_000_000_black      = {0}       iff(d5m_camera_vif.d5m.lvalid == high);
        bins blu_001_025_darker     = {1,25}    iff(d5m_camera_vif.d5m.lvalid == high);
        bins blu_026_050_dark       = {26,50}   iff(d5m_camera_vif.d5m.lvalid == high);
        bins blu_051_100_med_dark   = {51,100}  iff(d5m_camera_vif.d5m.lvalid == high);
        bins blu_101_150_medium     = {101,150} iff(d5m_camera_vif.d5m.lvalid == high);
        bins blu_151_200_med_light  = {151,200} iff(d5m_camera_vif.d5m.lvalid == high);
        bins blu_201_255_light      = {201,254} iff(d5m_camera_vif.d5m.lvalid == high);
        bins blu_255_255_white      = {255}     iff(d5m_camera_vif.d5m.lvalid == high);
        }
        
        xCord_iff_cp : coverpoint pred_h.vfp.x[5:0] iff (pred_h.vfp.valid ==high){
        option.at_least     = 1;
        option.auto_bin_max = 4;
        }
        
        yCord_iff_cp : coverpoint pred_h.vfp.y[5:0] iff (pred_h.vfp.valid ==high){
        option.at_least     = 1;
        option.auto_bin_max = 4;
        }
        
        cross_iff_rgb  : cross      red_predict_cp,green_predict_cp,blue_predict_cp,xCord_iff_cp, yCord_iff_cp;
    
    endgroup: d5m_predict_cg

    // Function: new
    function new (string name, uvm_component parent);
        super.new(name, parent);
        choices    = rgb_incrementer;
        img_pred_h = rgb_set_frame::type_id::create("img_pred_h");
        d5m_predict_cg = new;
    endfunction: new
    
    // Function: build_phase
    // Get virtual interface handle from the configuration DB
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        d5m_mon_prd = new("d5m_mon_prd", this);
        if(!uvm_config_db#(virtual d5m_camera_if)::get(this, "", "d5m_camera_vif", d5m_camera_vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(), ".d5m_camera_vif"});
    endfunction: build_phase
    

    virtual task run_phase (uvm_phase phase);
        fork
            collect_transactions();
        join
    endtask: run_phase
    

    virtual protected task collect_transactions();
    

        d5m_trans pred_d5m_h;
        pred_d5m_h        = d5m_trans::type_id::create("pred_d5m_h"); 
        img_pred_h.re_gen_cell_box(lval_lines,image_width,set_cell_red_value,set_cell_gre_value,set_cell_blu_value,set_increment_value,choices);

        forever begin
        @(posedge d5m_camera_vif.clkmm)
            pred_d5m_h.vfp.red   = img_pred_h.c_blocker.c_rows[d5m_camera_vif.d5m.y].c_block[d5m_camera_vif.d5m.x].red;
            pred_d5m_h.vfp.green = img_pred_h.c_blocker.c_rows[d5m_camera_vif.d5m.y].c_block[d5m_camera_vif.d5m.x].gre;
            pred_d5m_h.vfp.blue  = img_pred_h.c_blocker.c_rows[d5m_camera_vif.d5m.y].c_block[d5m_camera_vif.d5m.x].blu;
            pred_d5m_h.vfp.x     = d5m_camera_vif.d5m.x;
            pred_d5m_h.vfp.y     = d5m_camera_vif.d5m.y;
            pred_d5m_h.vfp.valid = d5m_camera_vif.d5m.valid;
            pred_h               = pred_d5m_h;
            d5m_predict_cg.sample();
            //Send the transaction to the analysis port
            d5m_mon_prd.write(pred_d5m_h);
        end
        
    endtask: collect_transactions

endclass: d5m_mon_pred