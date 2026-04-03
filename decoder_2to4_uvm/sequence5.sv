class dec_en_toggle_seq extends uvm_sequence#(dec_item);
  `uvm_object_utils(dec_en_toggle_seq)

    dec_item tr;

  function new(string name = "dec_en_toggle_seq");
        super.new(name);
    endfunction

    task body();
        `uvm_info(get_type_name(), "Starting en_toggle Stimulus for all ports...", UVM_LOW)

      
      repeat(10) begin
         tr=dec_item::type_id::create("tr");
         start_item(tr);
        
         if(tr.randomize()) begin 
           tr.en = ~tr.en; 
           finish_item(tr);
         end
         else begin 
           `uvm_fatal(get_type_name(), "Randomization failed!")
         end
       end
           
    endtask

endclass