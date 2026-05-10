class fifo_threshold_seq extends uvm_sequence#(fifo_item);
  `uvm_object_utils(fifo_threshold_seq)

  fifo_item tr;

  function new(string name = "fifo_threshold_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Starting Threshold Stimulus for all ports...", UVM_LOW)

    `uvm_info("SEQ_5","ALMOST FULL TEST",UVM_LOW)
    repeat(DEPTH-1) begin  //Fill to 15.
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.wr_en==1'b1; tr.rd_en==1'b0;})
    end
    //Simultaneous R/W (Stay at 15).
    `uvm_do_with(tr,{tr.rst_n==1'b1; tr.wr_en==1'b1; tr.rd_en==1'b1;})
    //Write one (Hit 16/Full).
    `uvm_do_with(tr,{tr.rst_n==1'b1; tr.wr_en==1'b1; tr.rd_en==1'b0;})
    //Read one (Back to 15).
    `uvm_do_with(tr,{tr.rst_n==1'b1; tr.wr_en==1'b0; tr.rd_en==1'b1;})
    //Simultaneous R/W again.
    `uvm_do_with(tr,{tr.rst_n==1'b1; tr.wr_en==1'b1; tr.rd_en==1'b1;})



    `uvm_info("SEQ_5","ALMOST EMPTY TEST",UVM_LOW)

    `uvm_do_with(tr,{tr.rst_n == 1'b0;})

    repeat(DEPTH) begin  //Fill to 16.
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.wr_en==1'b1; tr.rd_en==1'b0;})
    end

    repeat(DEPTH-1) begin  //empty till 15.
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.wr_en==1'b0; tr.rd_en==1'b1;})
    end
    //Simultaneous R/W again.
    `uvm_do_with(tr,{tr.rst_n==1'b1; tr.wr_en==1'b1; tr.rd_en==1'b1;})


  endtask

endclass