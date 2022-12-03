// Class: d5m_mon
class d5m_mon extends uvm_monitor;
    // handle: d5m_camera_vif
    // Interafce of dut and interconnector
    protected virtual   d5m_camera_if d5m_camera_vif;
    // Id Number
    protected int       id;
    // handle: item_collected_port
    //Declare analysis port
    uvm_analysis_port #(d5m_trans) item_collected_port;
    `uvm_component_utils_begin(d5m_mon)
        `uvm_field_int(id, UVM_DEFAULT)
    `uvm_component_utils_end
    // Function: new
    // Create an item_collected_port instance of the analysis port
    function new (string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction: new
    // Function: build_phase
    // Get virtual interface handle from the configuration DB
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual d5m_camera_if)::get(this, "", "d5m_camera_vif", d5m_camera_vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(), ".d5m_camera_vif"});
    endfunction: build_phase
    // Function: run_phase
    virtual task run_phase (uvm_phase phase);
        fork
            collect_transactions();
        join
    endtask: run_phase
    // Function: collect_transactions
    // Data items from interface is captured into local d5m_trans class object.
    // handle: d5m_tx
    // This handle is placeholder to capture data items from interface.
    virtual protected task collect_transactions();
        d5m_trans d5m_tx;
        forever begin
        @(posedge d5m_camera_vif.clkmm)
            d5m_tx = new();
            // d5m input data-> from driver to interface to dut
            d5m_tx.d5m.lvalid = d5m_camera_vif.d5m.lvalid;
            d5m_tx.d5m.fvalid = d5m_camera_vif.d5m.fvalid;
            d5m_tx.d5m.rgb    = d5m_camera_vif.d5m.rgb;
            //From dut: image filtered data
            d5m_tx.d5m.valid  = d5m_camera_vif.d5m.valid;
            d5m_tx.d5m.red    = d5m_camera_vif.d5m.red;
            d5m_tx.d5m.green  = d5m_camera_vif.d5m.green;
            d5m_tx.d5m.blue   = d5m_camera_vif.d5m.blue;
            d5m_tx.d5m.x      = d5m_camera_vif.d5m.x;
            d5m_tx.d5m.y      = d5m_camera_vif.d5m.y;
            d5m_tx.d5m.eof    = d5m_camera_vif.d5m.eof;
            //From dut: video configuration
            d5m_tx.axi4       = d5m_camera_vif.axi4;
            //Send the transaction to the analysis port
            item_collected_port.write(d5m_tx);
        end
    endtask: collect_transactions
endclass: d5m_mon