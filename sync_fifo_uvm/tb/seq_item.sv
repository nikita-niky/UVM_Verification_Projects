/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_item extends uvm_sequence_item;
  `uvm_object_utils(fifo_item)
  
  rand logic wr_en;
  rand fifo_data wdata;
  rand  logic rd_en;
  rand logic rst_n;
  
  fifo_data rdata;
  logic full;
  logic empty;


  function new(string name = "fifo_item");
    super.new(name);
  endfunction
  
  constraint con_en {(wr_en | rd_en) == 1; }
  constraint con_data {wdata inside {[0 : (1 << DATA_WIDTH) - 1]};}



endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
