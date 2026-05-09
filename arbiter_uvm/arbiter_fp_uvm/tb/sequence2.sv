class arbiter_stress_sequence extends uvm_sequence #(arbiter_item);
  `uvm_object_utils(arbiter_stress_sequence)
  
  arbiter_item tr;


  function new(string name = "arbiter_stress_sequence");
    super.new(name);
  endfunction

 
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence 2 body", UVM_LOW)

    repeat(50) begin
    
      `uvm_do_with(tr,{tr.rst_n==1; tr.req != 4'b0000;})
    end
   
    `uvm_info(get_type_name(), "Sequence 2 body finished", UVM_LOW)
  endtask

endclass