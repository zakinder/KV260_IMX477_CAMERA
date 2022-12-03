// Class: vfp_config
class vfp_config extends uvm_object; 
`uvm_object_utils(vfp_config)

  rand e_bool vfp_bool;
  rand byte vfp_mode;
  string vfp_name;
  int valid_status;
  rand vfp_reg vfp_pkt;
  vfp_regs  validate_reg_pkts;
  vfp_regs  reg_vpkts;
  
  constraint my_range {  vfp_mode < 12;
                         vfp_mode > 9;}
						 
    // Function: new              
    function new(string name = "vfp_config");
		super.new(name);
		vfp_name = name;
		vfp_pkt  = vfp_reg::type_id::create("vfp_pkt");
    endfunction: new
	
    // Function: convert2string   
	virtual function string convert2string();
		string contents = "";
		$sformat(contents, "%s vfp_name=%s",    contents, vfp_name);
		$sformat(contents, "%s vfp_bool=%s",    contents, vfp_bool.name());
		$sformat(contents, "%s vfp_mode=0x%0h", contents, vfp_mode);
		$sformat(contents, "%s vfp_pkt.reg_field.REG_00=0x%0h", contents, vfp_pkt.reg_field.REG_00);
		return contents;
    endfunction: convert2string
	
    // Function: unpack_packets  
    function void unpack_packets();
		validate_reg_pkts = {<<{vfp_pkt.regs_packet}};
    endfunction: unpack_packets
	
    // Function: valid
	// This function validate the config register by comparing the values
    virtual function int valid(input int a,b);
        `uvm_info("SEQ", $sformatf("a=%0d b=%0d", a,b), UVM_LOW)
        if(a == b)
            valid = 1;
        else    
            valid = 0;
    endfunction: valid
	
    // Function: check_packets 
    function void check_packets();
      valid_status = valid(validate_reg_pkts.REG_00,vfp_pkt.rgb_sharp);
      `uvm_info("SEQ", $sformatf("REG_00 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_01,vfp_pkt.edge_type);
      `uvm_info("SEQ", $sformatf("REG_01 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_02,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_02 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_03,vfp_pkt.bus_select);
      `uvm_info("SEQ", $sformatf("REG_03 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_04,vfp_pkt.config_threshold);
      `uvm_info("SEQ", $sformatf("REG_04 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_05,vfp_pkt.video_channel);
      `uvm_info("SEQ", $sformatf("REG_05 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_06,vfp_pkt.en_ycbcr_or_rgb);
      `uvm_info("SEQ", $sformatf("REG_06 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_07,vfp_pkt.c_channel);
      `uvm_info("SEQ", $sformatf("REG_07 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_08,vfp_pkt.kls_k1);
      `uvm_info("SEQ", $sformatf("REG_08 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_09,vfp_pkt.kls_k2);
      `uvm_info("SEQ", $sformatf("REG_09 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_10,vfp_pkt.kls_k3);
      `uvm_info("SEQ", $sformatf("REG_10 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_11,vfp_pkt.kls_k4);
      `uvm_info("SEQ", $sformatf("REG_11 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_12,vfp_pkt.kls_k5);
      `uvm_info("SEQ", $sformatf("REG_12 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_13,vfp_pkt.kls_k6);
      `uvm_info("SEQ", $sformatf("REG_13 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_14,vfp_pkt.kls_k7);
      `uvm_info("SEQ", $sformatf("REG_14 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_15,vfp_pkt.kls_k8);
      `uvm_info("SEQ", $sformatf("REG_15 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_16,vfp_pkt.kls_k9);
      `uvm_info("SEQ", $sformatf("REG_16 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_17,vfp_pkt.kls_config);
      `uvm_info("SEQ", $sformatf("REG_17 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_18,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_18 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_19,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_19 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_20,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_20 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_21,vfp_pkt.als_k1);
      `uvm_info("SEQ", $sformatf("REG_21 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_22,vfp_pkt.als_k2);
      `uvm_info("SEQ", $sformatf("REG_22 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_23,vfp_pkt.als_k3);
      `uvm_info("SEQ", $sformatf("REG_23 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_24,vfp_pkt.als_k4);
      `uvm_info("SEQ", $sformatf("REG_24 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_25,vfp_pkt.als_k5);
      `uvm_info("SEQ", $sformatf("REG_25 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_26,vfp_pkt.als_k6);
      `uvm_info("SEQ", $sformatf("REG_26 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_27,vfp_pkt.als_k7);
      `uvm_info("SEQ", $sformatf("REG_27 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_28,vfp_pkt.als_k8);
      `uvm_info("SEQ", $sformatf("REG_28 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_29,vfp_pkt.als_k9);
      `uvm_info("SEQ", $sformatf("REG_29 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_30,vfp_pkt.als_config);
      `uvm_info("SEQ", $sformatf("REG_30 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_31,vfp_pkt.point_interest);
      `uvm_info("SEQ", $sformatf("REG_31 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_32,vfp_pkt.delta_config);
      `uvm_info("SEQ", $sformatf("REG_32 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_33,vfp_pkt.cpu_ack_go_again);
      `uvm_info("SEQ", $sformatf("REG_33 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_34,vfp_pkt.cpu_wgrid_lock);
      `uvm_info("SEQ", $sformatf("REG_34 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_35,vfp_pkt.cpu_ack_off_frame);
      `uvm_info("SEQ", $sformatf("REG_35 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_36,vfp_pkt.fifo_read_address);
      `uvm_info("SEQ", $sformatf("REG_36 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_37,vfp_pkt.clear_fifo_data);
      `uvm_info("SEQ", $sformatf("REG_37 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_38,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_38 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_39,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_39 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_40,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_40 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_41,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_41 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_42,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_42 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_43,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_43 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_44,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_44 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_45,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_45 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_46,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_46 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_47,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_47 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_48,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_48 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_49,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_49 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_50,vfp_pkt.rgb_cord_rl);
      `uvm_info("SEQ", $sformatf("REG_50 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_51,vfp_pkt.rgb_cord_rh);
      `uvm_info("SEQ", $sformatf("REG_51 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_52,vfp_pkt.rgb_cord_gl);
      `uvm_info("SEQ", $sformatf("REG_52 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_53,vfp_pkt.rgb_cord_gh);
      `uvm_info("SEQ", $sformatf("REG_53 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_54,vfp_pkt.rgb_cord_bl);
      `uvm_info("SEQ", $sformatf("REG_54 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_55,vfp_pkt.rgb_cord_bh);
      `uvm_info("SEQ", $sformatf("REG_55 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_56,vfp_pkt.lum_th);
      `uvm_info("SEQ", $sformatf("REG_56 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_57,vfp_pkt.hsv_per_ch);
      `uvm_info("SEQ", $sformatf("REG_57 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_58,vfp_pkt.ycc_per_ch);
      `uvm_info("SEQ", $sformatf("REG_58 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_59,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_59 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_60,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_60 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_61,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_61 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_62,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_62 status=%0d", valid_status), UVM_LOW)
      valid_status = valid(validate_reg_pkts.REG_63,vfp_pkt.write_unused);
      `uvm_info("SEQ", $sformatf("REG_63 status=%0d", valid_status), UVM_LOW)
    endfunction: check_packets
    // Function: pack_packets 
    function void pack_packets();
      { <<  {reg_vpkts}} = validate_reg_pkts;
    endfunction: pack_packets
    // Function: do_copy 
    virtual function void do_copy(uvm_object rhs);
      vfp_config _trans;
      super.do_copy(rhs);
      $cast(_trans, rhs);
      vfp_bool              = _trans.vfp_bool;
      vfp_mode              = _trans.vfp_mode;
      validate_reg_pkts     = _trans.validate_reg_pkts;
      vfp_pkt.reg_field     = _trans.vfp_pkt.reg_field;
      vfp_name              = _trans.vfp_name;
      vfp_pkt.copy(_trans.vfp_pkt);
      `uvm_info(get_name(), "In vfp_config::do_copy()", UVM_LOW)
    endfunction: do_copy

endclass : vfp_config