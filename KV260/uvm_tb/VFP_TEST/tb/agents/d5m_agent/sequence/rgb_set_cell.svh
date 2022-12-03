// Class: rgb_set_cell
class rgb_set_cell extends rgb_cell_unit;
    `uvm_object_utils(rgb_set_cell)
    
    // Function: new
    function new(string name = "rgb_set_cell");
        super.new(name);
        selected_box = gre_rand_select;
    endfunction: new
    
    // Function: pre_call_set
    function void pre_call_set(int set_increment,set_cell_red,set_cell_gre,set_cell_blu);
        pre_call(selected_box,set_increment,set_cell_red,set_cell_gre,set_cell_blu);
    endfunction: pre_call_set
    
endclass: rgb_set_cell