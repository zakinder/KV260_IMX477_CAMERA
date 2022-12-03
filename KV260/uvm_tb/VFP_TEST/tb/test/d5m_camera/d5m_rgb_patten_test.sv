// Class: d5m_rgb_patten_test
class d5m_rgb_patten_test extends uvm_test;
    `uvm_component_utils(d5m_rgb_patten_test)
    
    // handle: d5m_env_h
    d5m_camera_env d5m_env_h;

    // Function: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new
    
    // Function: build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        begin
            d5m_camera_configuration d5m_camera_cfg;
            d5m_camera_cfg = new;
            assert(d5m_camera_cfg.randomize());
            d5m_env_h = d5m_camera_env::type_id::create(.name("d5m_env_h"),.parent(this));
        end
    endfunction: build_phase

    // Function: end_of_elaboration_phase
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        this.print();
        factory.print();
    endfunction: end_of_elaboration_phase

    // Function: run_phase
    task run_phase(uvm_phase phase);
        d5m_rgb_seq    seq_h;
        phase.raise_objection(.obj(this));
        seq_h = d5m_rgb_seq::type_id::create(.name("seq_h"));
        assert(seq_h.randomize());
        `uvm_info("d5m_env_h", { "\n", seq_h.sprint() }, UVM_LOW)
        seq_h.start(d5m_env_h.d5m_agt_h.d5m_sqr_h);
        phase.drop_objection(.obj(this));
    endtask: run_phase
    
endclass: d5m_rgb_patten_test