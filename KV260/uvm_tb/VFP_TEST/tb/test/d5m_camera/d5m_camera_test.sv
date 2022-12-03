// Class: d5m_camera_test
class d5m_camera_test extends uvm_test;
    `uvm_component_utils(d5m_camera_test)
    

    d5m_camera_env              d5m_env_h;
    d5m_camera_configuration    d5m_camera_cfg;
    uvm_table_printer           tprinter;


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        begin
        d5m_env_h       = d5m_camera_env::type_id::create(.name("d5m_env_h"),.parent(this));
        d5m_camera_cfg  = d5m_camera_configuration::type_id::create(.name("d5m_camera_cfg"),.parent(this));
        uvm_config_db #(d5m_camera_configuration)::set (this, "d5m_env_h.d5m_agt_h", "d5m_camera_cfg", d5m_camera_cfg);
        tprinter = new();     
        end
    endfunction: build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        this.print();
        factory.print();
    endfunction: end_of_elaboration_phase

    task run_phase(uvm_phase phase);
        camera_seq    seq_h;
        phase.raise_objection(.obj(this));
        seq_h = camera_seq::type_id::create(.name("seq_h"));
        assert(seq_h.randomize());
        seq_h.print (tprinter);
        seq_h.print (uvm_default_table_printer);
        d5m_camera_cfg.print (tprinter);
        d5m_camera_cfg.print (uvm_default_table_printer);
        `uvm_info("d5m_env_h", { "\n", seq_h.sprint() }, UVM_LOW)
        seq_h.start(d5m_env_h.d5m_agt_h.d5m_sqr_h);
        phase.drop_objection(.obj(this));
    endtask: run_phase

endclass: d5m_camera_test