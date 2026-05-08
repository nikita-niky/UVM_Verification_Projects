class apb_error_injection_seq extends  uvm_sequence #(apb_item);
  `uvm_object_utils(apb_error_injection_seq)
  apb_item tr;
  
   function new(string name = "apb_error_injection_seq");
    super.new(name);
  endfunction

  virtual task body();
    tr = apb_item::type_id::create("tr");
    tr.addr_range.constraint_mode(0);
    
    `uvm_info("SEQ", "Injecting Out-of-Bounds Address to trigger PSLVERR", UVM_LOW) 
    start_item(tr);
    tr.write_en = 1'b0; 
    tr.addr = 32'h0000_0100;
    finish_item(tr);  
    
  endtask
endclass