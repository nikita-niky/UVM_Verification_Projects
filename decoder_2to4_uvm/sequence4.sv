class dec_walking_ones_seq extends uvm_sequence#(dec_item);
  `uvm_object_utils(dec_walking_ones_seq)

    dec_item tr;

  function new(string name = "dec_walking_ones_seq");
        super.new(name);
    endfunction

    task body();
        `uvm_info(get_type_name(), "Starting walking_ones Stimulus for all ports...", UVM_LOW)


         
        for(int i=0; i<4;i++) begin
          tr=dec_item::type_id::create("tr");
          start_item(tr);
          tr.en=1;
          tr.sel=i; // 0,1,2,3
 		  finish_item(tr);
         end
    endtask

endclass