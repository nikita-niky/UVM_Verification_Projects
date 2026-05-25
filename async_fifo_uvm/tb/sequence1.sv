/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_directed_sequence extends uvm_sequence #(fifo_item);
  `uvm_object_utils(fifo_directed_sequence)
  fifo_item tr;
  bit is_write_mode;

  function new(string name = "fifo_directed_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting fifo_directed_sequence sequence body", UVM_LOW)

    tr = fifo_item::type_id::create("tr");

    repeat(2) begin
      `uvm_do_with(tr,{tr.wrst_n==1'b0; tr.rrst_n==1'b0; tr.winc==1'b0; tr.rinc==1'b0;})
    end

    #30;

    if(is_write_mode) begin
      `uvm_info("SEQ", "Starting 50 Writes", UVM_LOW)
      repeat(50) begin 
        `uvm_do_with(tr, {tr.wrst_n==1; tr.winc==1;})
      end

    end 
    else begin
      `uvm_info("SEQ", "Starting 50 Reads", UVM_LOW)
      repeat(50) begin 
        `uvm_do_with(tr, {tr.rrst_n==1; tr.rinc==1;})
      end

    end

    `uvm_info(get_type_name(), "Sequence body finished", UVM_LOW)
  endtask

endclass





/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
