`uvm_analysis_imp_decl(_d5m_dut)
`uvm_analysis_imp_decl(_d5m_prd)
// Class: d5m_scoreboard
// d5m_scoreboard - This class compare the dut output values with prediction or golden ref values.
// Using uvm fifo sychronize write transaction from dut and predict monitor.
// Get method access data from fifo which are connected to write method input.
// The uvm_tlm_analysis_fifo requires the declaration and construction of 
// separate uvm_analysis_export and the uvm_tlm_analysis_fifo. 
// The uvm_analysis_export port is then connected to the uvm_tlm_analysis_fifo.
// The uvm_tlm_analysis_fifo extends the uvm_tlm_fifo.
class rgb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(rgb_scoreboard)
    
    // handle:
    // TLM ports connect the predictor and evaluator.
    // handle: export_d5m_dut
    uvm_analysis_export   #(d5m_trans)     export_d5m_dut;
    // handle: export_d5m_prd
    uvm_analysis_export   #(d5m_trans)     export_d5m_prd;
    // handle: d5m_dut_fifo
    uvm_tlm_analysis_fifo #(d5m_trans)     d5m_dut_fifo;
    // handle: d5m_prd_fifo
    uvm_tlm_analysis_fifo #(d5m_trans)     d5m_prd_fifo;
    // handle: trans_d5m_dut
    d5m_trans                              trans_d5m_dut;
    // handle: trans_d5m_prd
    d5m_trans                              trans_d5m_prd;
    

    // Function: new
    // Construct d5m trans
    function new(string name, uvm_component parent);
        super.new(name, parent);
        trans_d5m_dut    = new("trans_d5m_dut");
        trans_d5m_prd    = new("trans_d5m_prd");
    endfunction: new
    
    
    // Function: build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        export_d5m_dut      = new("export_d5m_dut", this);
        export_d5m_prd      = new("export_d5m_prd", this);
        d5m_dut_fifo        = new("d5m_dut_fifo",   this);
        d5m_prd_fifo        = new("d5m_prd_fifo",   this);
    endfunction: build_phase
    
    
    // Function: connect_phase
    // Connect up the predictor and evaluato 
   function void connect_phase(uvm_phase phase);
       export_d5m_dut.connect(d5m_dut_fifo.analysis_export);
       export_d5m_prd.connect(d5m_prd_fifo.analysis_export);
   endfunction: connect_phase
   
    // Function: report_phase
   function void report_phase( uvm_phase phase );
      super.report_phase( phase );
   endfunction: report_phase
    // Function: run
    task run();
        forever begin
            d5m_dut_fifo.get(trans_d5m_dut);
            d5m_prd_fifo.get(trans_d5m_prd);
            if(selected_video_channel==select_rgb)begin
                compare(trans_d5m_dut);
            end    
        end
    endtask: run
    // Function: compare
    virtual function void compare(d5m_trans trans_d5m_dut);
        if(trans_d5m_dut.d5m.valid==1'b1) begin
            if(trans_d5m_dut.d5m.red == trans_d5m_prd.vfp.red) begin
                `uvm_info("Test: OK",$sformatf("DUT = %d PRED = %d",trans_d5m_dut.d5m.red,trans_d5m_prd.vfp.red), UVM_LOW)
            end else begin
                `uvm_info("Test: Fail",$sformatf("DUT = %d PRED = %d",trans_d5m_dut.d5m.red,trans_d5m_prd.vfp.red), UVM_LOW)
            end
        end   
    endfunction: compare
endclass: rgb_scoreboard