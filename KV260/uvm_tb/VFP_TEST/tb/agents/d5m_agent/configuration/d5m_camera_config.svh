// Class: d5m_camera_configuration
class d5m_camera_configuration extends uvm_object;
    `uvm_object_utils(d5m_camera_configuration)
    
    protected virtual d5m_camera_if d5m_camera_vif;
    rand bit [2:0] mode;
    
    uvm_active_passive_enum active = UVM_ACTIVE;
    bit has_jb_fc_sub = 1; // switch to instantiate a functional coverage subscriber
    
    bit coverage_enable = 1;
    bit enable_scoreboard = 1;
    
    
    // Function: new
    function new(string name = "d5m_camera_configuration");
        super.new(name);
    endfunction: new
    
    // Function: do_print
    function void do_print (uvm_printer printer);
        printer.knobs.depth=0;
        printer.print_int ("mode", mode, $bits(mode));
        `uvm_info ("DVR", "do_print called", UVM_MEDIUM)
    endfunction : do_print

endclass: d5m_camera_configuration