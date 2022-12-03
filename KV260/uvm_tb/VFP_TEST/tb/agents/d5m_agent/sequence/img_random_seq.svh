// Class: img_random_seq
class img_random_seq extends uvm_sequence #(d5m_trans);
   `uvm_object_utils(img_random_seq);
   d5m_trans item,s2;

   function new(string name = "img_random_seq");
      super.new(name);
   endfunction : new

   virtual  task body();
      repeat (1) begin : random_loop

         item = d5m_trans::type_id::create("item");
         s2 = d5m_trans::type_id::create("s2");
         start_item(item);

         assert(item.randomize());
        //`uvm_info(get_type_name(),$psprintf("convert_A %0x",item.convert_A), UVM_LOW)
        `uvm_info("convert_A", item.convert2string(), UVM_LOW);
        `uvm_info(get_type_name(),$psprintf("convert_axi4_lite %0d",item.axi4_lite.addr), UVM_LOW)
         finish_item(item);
         start_item(s2);
         assert(s2.randomize());
         s2.copy(item);
       // `uvm_info(get_type_name(),$psprintf("convert_B %0x",s2.convert_B), UVM_LOW)
        `uvm_info("convert_B", s2.convert2string(), UVM_LOW);
        `uvm_info(get_type_name(),$psprintf("s1==s2: ",item.compare(s2)), UVM_LOW)
        `uvm_info(get_type_name(),$psprintf("convert_axi4_lite %0d",s2.axi4_lite.addr), UVM_LOW)
         finish_item(s2);
      end : random_loop
    endtask: body
endclass : img_random_seq