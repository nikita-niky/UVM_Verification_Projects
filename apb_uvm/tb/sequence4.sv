class apb_reset_chk_seq extends apb_base_seq;
  `uvm_object_utils(apb_reset_chk_seq)
  
  function new(string name = "apb_reset_chk_seq");
    super.new(name);
  endfunction

  virtual task body();

    `uvm_info("SEQ", "Starting Reset Check Sequence", UVM_LOW)

    // 1. Perform a normal write to have some data in memory
    do_write(32'h0000_0008, 32'hAAAA_BBBB);

    // 2. Start a transaction but intentionally don't finish it 
    // or simulate a reset happening right after start.
    // In a real test, the 'Test' class usually handles the reset toggle.
    
    `uvm_info("SEQ", "Ready for Reset trigger...", UVM_LOW)
    
    // We wait for the reset to go low (via the interface)
    // We access the vif through the sequencer or a config handle
    
  endtask
endclass