// Class: rgb_per_cell
class rgb_per_cell extends rgb_set_cell;
    `uvm_object_utils(rgb_per_cell)
    
    // Function: new
    function new(string name = "rgb_per_cell");
        super.new(name);
        selected_box = gre_rand_select;
    endfunction: new
    
    // Function: pre_randomize_call
    function void pre_randomize_call(input cell_set choices,int set_increment,set_cell_red,set_cell_gre,set_cell_blu);
        selected_box = choices;
        pre_call_set(set_increment,set_cell_red,set_cell_gre,set_cell_blu);
    endfunction: pre_randomize_call
    
endclass: rgb_per_cell