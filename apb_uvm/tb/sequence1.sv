class apb_write_read_seq extends uvm_sequence #(apb_item);
  `uvm_object_utils(apb_write_read_seq)
  apb_item w_tr;
  apb_item r_tr;
  
  function new(string name = "apb_write_read_seq");
    super.new(name);
  endfunction

  
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence body", UVM_LOW)
    
    ///PERFORMING WRITE
    repeat(20) begin
      w_tr = apb_item::type_id::create("w_tr");
      start_item(w_tr);
      if(!w_tr.randomize() with {write_en == 1'b1;}) begin
        `uvm_error("SEQ","Randomization failed for w_tr")
      end
      finish_item(w_tr);

//     //PERFORMING READ
      r_tr = apb_item::type_id::create("r_tr");
      start_item(r_tr);
      if(!r_tr.randomize() with {write_en == 1'b0; addr == w_tr.addr;}) begin
        `uvm_error("SEQ","RAndomization failed for r_tr")
      end
      finish_item(r_tr);  
    end

    `uvm_info(get_type_name(), "Sequence body finished", UVM_LOW)
  endtask

endclass