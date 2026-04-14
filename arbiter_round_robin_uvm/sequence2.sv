class arb_walking_ones_sequence extends uvm_sequence #(arb_item);
  `uvm_object_utils(arb_walking_ones_sequence)
  arb_item tr;


  function new(string name = "arb_walking_ones_sequence");
    super.new(name);
  endfunction

  
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence 2 body", UVM_LOW)

    for(int i=0;i<4;i++) begin
      tr = arb_item::type_id::create("tr");
      start_item(tr);
      tr.rst_n = 1;
      tr.req = (1<<i); // 0001,0010,0100,1000
      finish_item(tr);
          
    end
    
    `uvm_info(get_type_name(), "Sequence 2 body finished", UVM_LOW)
  endtask

endclass