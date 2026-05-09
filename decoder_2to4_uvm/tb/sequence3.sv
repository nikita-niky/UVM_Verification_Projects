class dec_en_one_seq extends uvm_sequence#(dec_item);
  `uvm_object_utils(dec_en_one_seq)

    dec_item tr;

  function new(string name = "dec_en_one_seq");
        super.new(name);
    endfunction

    task body();
        `uvm_info(get_type_name(), "Starting en_one Stimulus for all ports...", UVM_LOW)

      repeat(20) begin
         tr=dec_item::type_id::create("tr");
         start_item(tr);
        if(!tr.randomize() with {en == 1; sel inside {[0:3]};}) 
            begin
             `uvm_fatal(get_type_name(), "Randomization failed!")
            end

            finish_item(tr);
         end
    endtask

endclass