/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_udfl_seq extends uvm_sequence#(fifo_item);
    `uvm_object_utils(fifo_udfl_seq)
 

  fifo_item tr;
  bit is_write_mode;
 


  function new(string name = "fifo_udfl_seq");
    super.new(name);
  endfunction

  
  virtual task body();
    tr = fifo_item::type_id::create("tr");
     `uvm_info(get_type_name(), "Starting fifo_udfl_seq Stimulus for all ports...", UVM_LOW)
    
    repeat(2) begin
      `uvm_do_with(tr,{tr.wrst_n==1'b0; tr.rrst_n==1'b0; tr.winc==1'b0; tr.rinc==1'b0;})
    end
    #30;
   
    if(is_write_mode) begin
        `uvm_info("SEQ", "Starting Writes", UVM_LOW)
        repeat(20) begin
          `uvm_do_with(tr,{tr.wrst_n==1'b1;tr.winc==1'b0;})
        end

      end
      else begin
        `uvm_info("SEQ", "Starting Randomized Reads", UVM_LOW)
        repeat(20) begin
          `uvm_do_with(tr,{tr.rrst_n==1'b1;tr.rinc==1'b1;})
        end   
      end
    

  endtask

endclass



/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
