class arbiter_reset_sequence extends uvm_sequence #(arbiter_item);
  `uvm_object_utils(arbiter_reset_sequence)
  
  arbiter_item tr;


  function new(string name = "arbiter_reset_sequence");
    super.new(name);
  endfunction

 
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence 3 body", UVM_LOW)
    
    repeat(5) begin
    
      `uvm_do_with(tr,{tr.rst_n==1; tr.req != 4'b0000;})
    end
    
    repeat(2) begin
      `uvm_do_with(tr,{tr.rst_n == 0;})
    end
    
     repeat(5) begin
    
      `uvm_do_with(tr,{tr.rst_n==1; tr.req != 4'b0000;})
    end
    
    `uvm_info(get_type_name(), "Sequence 3 body finished", UVM_LOW)
  endtask

endclass