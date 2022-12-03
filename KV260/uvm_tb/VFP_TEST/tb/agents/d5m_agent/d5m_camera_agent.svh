// Class: d5m_camera_agent
// This agent encapusalte the d5m driver, monitor and sequencer into single entity
// by intencitaing and conneting the the component together via TLM interface.
class d5m_camera_agent extends uvm_agent;
    `uvm_component_utils(d5m_camera_agent)
    uvm_analysis_port#(d5m_trans) item_collected_port;
    uvm_analysis_port#(d5m_trans) agnt_mon_dut;
    uvm_analysis_port#(d5m_trans) agnt_mon_prd;
    // handle: agent components handles
    // handle: d5m_sqr_h
    // 
    img_seqr            d5m_sqr_h;
    // handle: d5m_drv_h
    // 
    d5m_drv             d5m_drv_h;
    // handle: d5m_mon_h
    // 
    d5m_mon             d5m_mon_h;
    // handle: d5m_mon_dut_h
    // 
    d5m_mon_dut         d5m_mon_dut_h;
    // handle: d5m_mon_prd_h
    // 
    d5m_mon_pred        d5m_mon_prd_h;
    /* Function: new
     * Parameters:
     *
     *    name - name
     *    parent - uvm_component
     */
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new 
    // Function: build_phase
    // Use build() method to create agents's subcomponents.
    // If agent is active create then driver, and sequencer
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agnt_mon_dut         = new(.name("agnt_mon_dut"), .parent(this));
        agnt_mon_prd         = new(.name("agnt_mon_prd"), .parent(this));
        item_collected_port  = new(.name("item_collected_port"),.parent(this));
        //Both active and passive agents need a monitor
        d5m_mon_h                   = d5m_mon::type_id::create("d5m_mon_h", this);
        d5m_mon_dut_h           = d5m_mon_dut::type_id::create("d5m_mon_dut_h", this);
        d5m_mon_prd_h           = d5m_mon_pred::type_id::create("d5m_mon_prd_h", this);
        // If this UVM agent is active, then build driver, and sequencer.
        // active agent generate stimulus and drive to dut whereas passive agent do not drive signals to dut but sample.
        // Create object instance
        if (get_is_active() == UVM_ACTIVE) begin
            d5m_sqr_h = img_seqr::type_id::create("d5m_sqr_h", this);
            d5m_drv_h = d5m_drv::type_id::create("d5m_drv_h", this);
        end
    endfunction: build_phase
    // Function: connect_phase
    // Called by uvm flow and connect monitor to agent ana
    // If this agent is active then Connect 
    // the driver to the sequencer 
    // the monitor to the item_collected_port 
    // the monitor to the agnt_mon_dut 
    // the monitor to the agnt_mon_prd 
    // get_is_active() method return the state of an agent.
    function void connect_phase(uvm_phase phase);
        if (get_is_active() == UVM_ACTIVE) begin
            // connect driver and sequencer
            d5m_drv_h.seq_item_port.connect(d5m_sqr_h.seq_item_export);
            // connect monitor and analysis port
            d5m_mon_h.item_collected_port.connect(item_collected_port);
            // connect monitor and analysis port
            d5m_mon_dut_h.mon_d5m_dut.connect(agnt_mon_dut);
            // connect monitor and analysis port
            d5m_mon_prd_h.d5m_mon_prd.connect(agnt_mon_prd);
        end
    endfunction: connect_phase
endclass: d5m_camera_agent