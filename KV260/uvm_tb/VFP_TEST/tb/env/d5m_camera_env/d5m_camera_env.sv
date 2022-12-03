// Class: d5m_camera_env
// This Class instantiates and configures the d5m agent and its scoreboard.

class d5m_camera_env extends uvm_env;
    `uvm_component_utils(d5m_camera_env)
    
    protected virtual interface d5m_camera_if d5m_camera_vif;
    d5m_camera_agent               d5m_agt_h;
    d5m_camera_fc_subscriber       aL_fc_sub;
    rgb_scoreboard                 aL_rgb_sb_sub;


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

  function void end_of_elaboration_phase(uvm_phase phase);
    //int parameter1;
    
    if (uvm_config_db#(int)::get(this,"","img_width_bmp", img_width_bmp))
      `uvm_info(get_type_name(), $sformatf("img_width_bmp=%0d", img_width_bmp), UVM_MEDIUM)
  endfunction : end_of_elaboration_phase


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        d5m_agt_h       = d5m_camera_agent::type_id::create("d5m_agt_h", this);
        aL_fc_sub       = d5m_camera_fc_subscriber::type_id::create("aL_fc_sub", this);
        aL_rgb_sb_sub   = rgb_scoreboard::type_id::create("aL_rgb_sb_sub", this);
        uvm_config_db#(int)::set(this,"","img_width_bmp", 11);
    endfunction: build_phase
    

    // Connect analysis ports from agent to the scoreboard.
    // Connect the analysis port of the scoreboard with the monitor so that 
    // the scoreboard gets data whenever monitor broadcasts the data.
    // Dut monitor : agnt_mon_dut is analysis port in agent connected to handle d5m_mon_dut_h of dut monitor.
    // Prd monitor : agnt_mon_prd is analysis port in agent connected to handle d5m_mon_dut_h of dut monitor.
    // Scoreboard uvm_analysis_export port export_d5m_dut connected to agnt_mon_dut.
    // Scoreboard uvm_analysis_export port export_d5m_prd connected to export_d5m_prd.
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        d5m_agt_h.item_collected_port.connect(aL_fc_sub.analysis_export);
        d5m_agt_h.agnt_mon_dut.connect(aL_rgb_sb_sub.export_d5m_dut);
        d5m_agt_h.agnt_mon_prd.connect(aL_rgb_sb_sub.export_d5m_prd);
    endfunction: connect_phase
    
endclass: d5m_camera_env