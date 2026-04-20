class fifo_directed_sequence extends uvm_sequence #(fifo_item);
  `uvm_object_utils(fifo_directed_sequence)
  fifo_item tr;


  // Constructor
  function new(string name = "fifo_directed_sequence");
    super.new(name);
  endfunction

  // The body task: This is where the stimulus is generated
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence 1 body", UVM_LOW)
    
    repeat(17) begin
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.wr_en==1'b1; tr.rd_en==1'b0;})
    end
    
    repeat(18) begin
      `uvm_do_with(tr, {tr.rst_n==1'b1; tr.rd_en == 1'b1; tr.wr_en == 1'b0; tr.wdata=='0;})
    end
    
    
    repeat(5) begin
      `uvm_do_with(tr, {tr.wdata == 8'h00; tr.wr_en == 1; tr.rd_en == 0;})
      `uvm_do_with(tr, {tr.rd_en == 1; tr.wr_en == 0;})
    end
    
     /// reset while full seq
    `uvm_info("SEQ_1","RESET while full seq",UVM_LOW)
    repeat(17) begin
        `uvm_do_with(tr,{tr.rst_n == 1'b1; tr.wr_en == 1'b1; tr.rd_en == 1'b0;})
      end
    `uvm_do_with(tr, {tr.rst_n == 1'b1; tr.rd_en == 1'b0;})
    `uvm_do_with(tr,{tr.rst_n==1'b0;tr.rd_en == 1'b0;})

    `uvm_info(get_type_name(), "Sequence 1 body finished", UVM_LOW)
  endtask

endclass