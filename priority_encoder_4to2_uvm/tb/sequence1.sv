class p_enc_base_sequence extends uvm_sequence #(enc_item);
  `uvm_object_utils(p_enc_base_sequence)
  enc_item tr;


  
  function new(string name = "p_enc_base_sequence");
    super.new(name);
  endfunction

 
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence body", UVM_LOW)

    for(int i=0;i<4;i++) begin
      
      tr = enc_item::type_id::create("tr");
      start_item(tr);
      tr.req = (1<<i);// 4'b0001, 4'b0010, 4'b0100, 4'b1000
      
      finish_item(tr);
    end

    `uvm_info(get_type_name(), "Sequence body finished", UVM_LOW)
  endtask

endclass