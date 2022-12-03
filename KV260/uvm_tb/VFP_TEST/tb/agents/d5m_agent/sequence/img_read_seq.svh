// Class: img_read_seq
class img_read_seq extends img_base_seq;
    `uvm_object_utils(img_read_seq) 
    
    function new(string name="img_read_seq");
        super.new(name);
    endfunction: new

    virtual task body();
        super.body();
        d5m_read();
    endtask: body

endclass: img_read_seq