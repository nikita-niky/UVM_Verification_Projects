/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_ovfl_unfl_seq extends uvm_sequence#(fifo_item);
    `uvm_object_utils(fifo_ovfl_unfl_seq)

    fifo_item tr;

    function new(string name = "fifo_ovfl_unfl_seq");
        super.new(name);
    endfunction

    task body();
      `uvm_info(get_type_name(), "Starting OVERFLOW and UNDERFLOW Stimulus for all ports...", UVM_LOW)
      

      repeat(30) begin
        `uvm_do_with(tr,{tr.rst_n==1'b1; tr.wr_en==1'b1; tr.rd_en == 1'b0;})
      end

      repeat(30) begin
        `uvm_do_with(tr,{tr.rst_n==1'b1; tr.rd_en == 1'b1; tr.wr_en==1'b0;})
      end

    endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
