// Class: rgb_set_rows
class rgb_set_rows extends uvm_object;
    `uvm_object_utils(rgb_set_rows)
    string  obj_name;
    rgb_per_cell c_block[];
    
    int c_block_size;
    int set_cell_per_r_red;
    int set_cell_per_r_gre;
    int set_cell_per_r_blu;
    int set_r_red;
    int set_r_gre;
    int set_r_blu;
    
    // Function: new
    function new(string name = "rgb_set_rows");
        super.new(name);
        obj_name     = name;
        c_block      = new[1];
        c_block_size = c_block.size;
    endfunction: new
    
    // Function: create_c_block_arrays
    virtual function create_c_block_arrays(int c_size = 5);
        c_block    = new[c_size];
        foreach(c_block[i])
        begin
            c_block[i] = rgb_per_cell::type_id::create($sformatf("c_block_%0d",i));
        end   
        c_block_size = c_block.size;
    endfunction: create_c_block_arrays
    
    // Function: per_rows_call
    function void per_rows_call(input cell_set choices,int set_increment,set_cell_per_r_red,set_cell_per_r_gre,set_cell_per_r_blu,ar_size);
    create_c_block_arrays(ar_size);

        for(int i = 0; i < c_block_size; i++) begin
            c_block[i].pre_randomize_call(choices,set_increment,set_cell_per_r_red,set_cell_per_r_gre,set_cell_per_r_blu);
            c_block[i].randomize();
            set_cell_per_r_red = c_block[i].set_cell_red;
            set_cell_per_r_gre = c_block[i].set_cell_red;
            set_cell_per_r_blu = c_block[i].set_cell_red;
        end
        
        set_r_red = set_cell_per_r_red;
        set_r_gre = set_cell_per_r_gre;
        set_r_blu = set_cell_per_r_blu;
    endfunction: per_rows_call

    // Function: convert2string
    virtual function string convert2string();
        string contents = "";
        $sformat(contents, "%s obj_name=%s\n", contents, obj_name);
        foreach(c_block[i]) begin
        $sformat(contents, "%s c_block[%0d].set_cell_red=%0d\n", contents, i, c_block[i].red);
        end
        return contents;
    endfunction: convert2string

    
endclass: rgb_set_rows