class p_enc_all_zeros_seq extends uvm_sequence#(enc_item);
  `uvm_object_utils(p_enc_all_zeros_seq)

    enc_item tr;

    function new(string name = "p_enc_all_zeros_seq");
        super.new(name);
    endfunction

    task body();
      `uvm_info(get_type_name(), "Starting ALL ZEROS Stimulus for all ports...", UVM_LOW)


      // --- CASE 3: All Zeros (Checking the 'valid' bit) ---
      tr=enc_item::type_id::create("tr");
      start_item(tr);
      tr.req=4'b0000;
      finish_item(tr);
         
    endtask

endclass