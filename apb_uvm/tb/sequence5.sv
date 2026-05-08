class apb_b2b_seq extends apb_base_seq;
  `uvm_object_utils(apb_b2b_seq)
  
  function new(string name = "apb_b2b_seq");
    super.new(name);
  endfunction
  
  int num_transfers = 5;

  virtual task body();
    `uvm_info("SEQ", $sformatf("Starting %0d Back-to-Back transfers", num_transfers), UVM_LOW)

    for (int i = 0; i < num_transfers; i++) begin
      req = apb_item::type_id::create("req");
      
      start_item(req);
      if (!req.randomize() with {
        addr     == i * 4;     // Consecutive addresses
        write_en == 1'b1;      // All writes for this test
        delay    == 0;         // CRITICAL: No delay between items
      }) begin
        `uvm_error("SEQ", "Randomization failed")
      end
      finish_item(req);
    end
  endtask
endclass