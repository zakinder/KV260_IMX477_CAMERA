// Class: rgb_cell_unit
class rgb_cell_unit extends uvm_object;
  `uvm_object_utils(rgb_cell_unit)
  
    cell_set selected_box;

    rand int red;
    rand int gre;
    rand int blu;
    
    bit[7:0] rgb_red_data;
    bit[7:0] rgb_gre_data;
    bit[7:0] rgb_blu_data;
    
    int red_test = 0;
    int gre_test = 0;
    int blu_test = 0;
    
    bit[7:0] set_cell_red;
    bit[7:0] set_cell_gre;
    bit[7:0] set_cell_blu;

    // Constraint rgb values to reach coverage goal by shaping the random stimulus for interesting corner cases.
    // constraint rgb data item red
    constraint c_red_stim {
    if (red_test==0) {
        red == 100;
    } else
        if (red_test==1) {
            red == 255;
        }else
            if (red_test==2) {
                red inside {[1:50]};
            }else
                if (red_test==3) {
                    red inside {[51:100]};
                }else
                    if (red_test==4) {
                        red inside {[101:150]};
                    }else
                        if (red_test==5) {
                            red inside {[151:200]};
                        }else
                            if (red_test==6) {
                                red inside {[201:255]};
                            }else
                                red == set_cell_red;
    }
    // constraint rgb data item green
    constraint c_gre_stim {
    if (gre_test==0) {
        gre == 100;
    } else
        if (gre_test==1) {
            gre == 255;
        }else
            if (gre_test==2) {
                gre inside {[1:50]};
            }else
                if (gre_test==3) {
                    gre inside {[51:100]};
                }else
                    if (gre_test==4) {
                        gre inside {[101:150]};
                    }else
                        if (gre_test==5) {
                            gre inside {[151:200]};
                        }else
                            if (gre_test==6) {
                                gre inside {[201:255]};
                            }else
                                gre == set_cell_gre;
    }
    // constraint rgb data item blue
    constraint c_blu_stim {
    if (blu_test==0) {
        blu == 100;
    } else
        if (blu_test==1) {
            blu == 255;
        }else
            if (blu_test==2) {
                blu inside {[1:50]};
            }else
                if (blu_test==3) {
                    blu inside {[51:100]};
                }else
                    if (blu_test==4) {
                        blu inside {[101:150]};
                    }else
                        if (blu_test==5) {
                            blu inside {[151:200]};
                        }else
                            if (blu_test==6) {
                                blu inside {[201:255]};
                            }else
                                blu == set_cell_blu;
    }

    // Function: new
    function new(string name = "rgb_cell_unit");
        super.new(name);
    endfunction: new
    
    // Function: pre_call
    function void pre_call(input cell_set selected_box,int incre,set_cell_r,set_cell_g,set_cell_b);

    set_cell_red = (set_cell_r + incre + offset_r);
    set_cell_gre = (incre + offset_g);
    set_cell_blu = (incre + offset_b);
    
    if(selected_box == gre_rand_select) begin
        red_test = 0;
        gre_test = $urandom_range(0,6);
        blu_test = 0;
    end else if (selected_box == gre_per_select) begin
        red_test = 0;
        gre_test = 7;
        blu_test = 0;
    end else if (selected_box == rgb_incrementer) begin
        red_test = 7;
        gre_test = 7;
        blu_test = 7;
    end else if (selected_box == all_select) begin
        red_test = 0;
        gre_test = 0;
        blu_test = 0;
    end else if (selected_box == red_per_select) begin
        red_test = 4;
        gre_test = 0;
        blu_test = 0;
    end else if (selected_box == red_rand_select) begin
        red_test = 0;
        gre_test = $urandom_range(0,6);
        blu_test = 0;
    end else if (selected_box == rgb_000_000_black) begin
        red_test = 1;
        gre_test = 3;
        blu_test = 0;
    end else if (selected_box == rgb_001_050_dark) begin
        red_test = 2;
        gre_test = 2;
        blu_test = 2;
    end else if (selected_box == rgb_051_100_med_dark) begin
        red_test = 3;
        gre_test = 3;
        blu_test = 3;
    end else if (selected_box == rgb_101_150_medium) begin
        red_test = 4;
        gre_test = 4;
        blu_test = 4;
    end else if (selected_box == rgb_151_200_med_light) begin
        red_test = 5;
        gre_test = 5;
        blu_test = 5;
    end else if (selected_box == rgb_201_255_light) begin
        red_test = 6;
        gre_test = 6;
        blu_test = 6;
    end else if (selected_box == rgb_255_255_white) begin
        red_test = 1;
        gre_test = 1;
        blu_test = 1;
    end else begin
        red_test = 0;
        gre_test = 1;
        blu_test = 0;
    end
    

    endfunction: pre_call
endclass: rgb_cell_unit