// Class: rgb_set_frame
class rgb_set_frame extends uvm_object;
    `uvm_object_utils(rgb_set_frame)
    
    string  obj_name;
    int set_cell_red;
    rand rgb_set_cols c_blocker;
    rand cell_set my_choices;
    
    // Function: new
    function new(string name = "rgb_set_frame");
        super.new(name);
        obj_name = name;
        c_blocker  = rgb_set_cols::type_id::create("c_blocker");
    endfunction: new

    
    function void pre_randomize();
    endfunction: pre_randomize

    // Function: re_gen_cell_box
    function void re_gen_cell_box(input int outter_size,inner_size,set_cell_red,set_cell_gre,set_cell_blu,set_incr,cell_set choices);
        c_blocker.create_arrays(outter_size);
        c_blocker.per_cols_call(choices,set_incr,set_cell_red,set_cell_gre,set_cell_blu,inner_size);
    endfunction: re_gen_cell_box


endclass : rgb_set_frame