class p_enc_conflict_seq extends uvm_sequence#(enc_item);
  `uvm_object_utils(p_enc_conflict_seq)

    enc_item tr;

    function new(string name = "p_enc_conflict_seq");
        super.new(name);
    endfunction

    task body();
      `uvm_info(get_type_name(), "Starting all Ones Stimulus for all ports...", UVM_LOW)


      // If we send 4'b1111, the output MUST be 3 (2'b11).
      tr=enc_item::type_id::create("tr");
      start_item(tr);
      tr.req=4'b1111;
      finish_item(tr);
         
    endtask

endclass