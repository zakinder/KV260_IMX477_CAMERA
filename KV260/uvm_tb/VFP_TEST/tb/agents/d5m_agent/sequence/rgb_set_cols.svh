// Class: rgb_set_cols
class rgb_set_cols extends uvm_object;
    `uvm_object_utils(rgb_set_cols)
    string  obj_name;
    rgb_set_rows c_rows[];
    int c_rows_size;
    int per_set_cols_r_red;
    
    // Function: new
    function new(string name = "rgb_set_cols");
        super.new(name);
        obj_name = name;
        c_rows = new[1];
        c_rows_size = c_rows.size;
    endfunction: new
    
    // Function: create_arrays
    virtual function create_arrays(int c_size = 5);
        c_rows    = new[c_size];
        foreach(c_rows[i])
        begin
            c_rows[i] = rgb_set_rows::type_id::create($sformatf("c_rows_%0d",i));
        end   
        c_rows_size = c_rows.size;
    endfunction: create_arrays
    
    // Function: per_cols_call
    function void per_cols_call(input cell_set choices,int set_increment,set_cell_per_r_red,set_cell_per_r_gre,set_cell_per_r_blu,ar_size);
        $display("set choices:%s\n ", choices);
        for(int i = 0; i < c_rows_size; i++) begin

            c_rows[i].per_rows_call(choices,set_increment,set_cell_per_r_red,set_cell_per_r_gre,set_cell_per_r_blu,ar_size);
            
            set_cell_per_r_red = c_rows[i].set_r_red;
            set_cell_per_r_gre = c_rows[i].set_r_gre;
            set_cell_per_r_blu = c_rows[i].set_r_blu;
        end
    endfunction: per_cols_call

    // Function: convert2string
    virtual function string convert2string();
        string contents = "";
        $sformat(contents, "%s obj_name=%s", contents, obj_name);
        foreach(c_rows[i]) begin
        `uvm_info("", c_rows[i].convert2string(), UVM_NONE)
        end
        return contents;
    endfunction: convert2string

    
endclass: rgb_set_cols
