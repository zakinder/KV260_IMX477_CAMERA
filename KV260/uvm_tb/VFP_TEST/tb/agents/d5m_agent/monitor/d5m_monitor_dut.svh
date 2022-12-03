// Class: d5m_mon_dut
class d5m_mon_dut extends uvm_monitor;


    // Interafce instance
    protected virtual   d5m_camera_if d5m_camera_vif;
    
    // Id Number
    protected int       id;

    // Create an analysis port by the name "mon_d5m_dut" that can broadcast packets of type "d5m_trans".
    uvm_analysis_port #(d5m_trans) mon_d5m_dut;

    protected d5m_trans rx_fdut;
    
    `uvm_component_utils_begin(d5m_mon_dut)
        `uvm_field_int(id, UVM_DEFAULT)
    `uvm_component_utils_end
    

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new
    

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual d5m_camera_if)::get(this, "", "d5m_camera_vif", d5m_camera_vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(), ".d5m_camera_vif"});
        mon_d5m_dut = new("mon_d5m_dut", this);
    endfunction: build_phase
    
    
    virtual task run_phase (uvm_phase phase);
            collect_transactions();
    endtask: run_phase

    virtual protected task collect_transactions();
        d5m_trans rx_fdut;
        rx_fdut            = d5m_trans::type_id::create("rx_fdut"); 
        forever begin
        @(posedge d5m_camera_vif.clkmm)
            rx_fdut.d5m.valid  = d5m_camera_vif.d5m.valid;
            rx_fdut.d5m.red    = d5m_camera_vif.d5m.red;
            rx_fdut.d5m.green  = d5m_camera_vif.d5m.green;
            rx_fdut.d5m.blue   = d5m_camera_vif.d5m.blue;
            rx_fdut.d5m.rgb    = d5m_camera_vif.d5m.rgb;
            rx_fdut.d5m.lvalid = d5m_camera_vif.d5m.lvalid;
            rx_fdut.d5m.fvalid = d5m_camera_vif.d5m.fvalid;
            rx_fdut.d5m.x      = d5m_camera_vif.d5m.x;
            rx_fdut.d5m.y      = d5m_camera_vif.d5m.y;
            rx_fdut.d5m.eof    = d5m_camera_vif.d5m.eof;
            //Send the transaction to the analysis port
            mon_d5m_dut.write(rx_fdut);
            
        end
    endtask: collect_transactions
    
endclass: d5m_mon_dut