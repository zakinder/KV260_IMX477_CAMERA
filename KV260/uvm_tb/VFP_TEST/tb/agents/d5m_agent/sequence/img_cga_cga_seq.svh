// Class: img_cga_cga_seq
class img_cga_cga_seq extends img_base_seq;

   `uvm_object_utils(img_cga_cga_seq);

   img_read_seq            img_seq_h;
   protected img_seqr      d5m_sqr_h;
   uvm_component           uvm_component_h;
   config_axi4_seq         axi_cnf_seq_h;
   
    // Function: new
    function new(string name = "img_cga_cga_seq");
        super.new(name);
        uvm_component_h   =  uvm_top.find("*d5m_sqr_h");
        if (uvm_component_h == null)
            `uvm_fatal("RUNALL SEQUENCE", "Failed to get the img_seqr")
        if (!$cast(d5m_sqr_h, uvm_component_h))
            `uvm_fatal("RUNALL SEQUENCE", "Failed to cast from uvm_component_h.")
        img_seq_h 	    = img_read_seq::type_id::create("img_seq_h");
        axi_cnf_seq_h 	= config_axi4_seq::type_id::create("axi_cnf_seq_h");
    endfunction : new
 

    // Method:  body
    task body();
        super.body();
        //start axi configuration
        axi_cnf_seq_h.start(d5m_sqr_h);
        //start image transections
        img_seq_h.start(d5m_sqr_h);
    endtask : body
 
 
endclass : img_cga_cga_seq