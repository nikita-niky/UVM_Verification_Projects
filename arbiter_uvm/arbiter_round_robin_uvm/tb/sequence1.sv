class arb_all_high_sequence extends uvm_sequence #(arb_item);
  `uvm_object_utils(arb_all_high_sequence)
  arb_item tr;


  function new(string name = "arb_all_high_sequence");
    super.new(name);
  endfunction

  
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence 1 body", UVM_LOW)

    repeat(8) begin
      tr = arb_item::type_id::create("tr");
      start_item(tr);
      tr.rst_n = 1'b1;
      tr.req = 4'b1111;
      finish_item(tr);
    end

    `uvm_info(get_type_name(), "Sequence 1 body finished", UVM_LOW)
  endtask

endclass