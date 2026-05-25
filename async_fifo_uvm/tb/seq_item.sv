/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_item extends uvm_sequence_item;
//   `uvm_object_utils(fifo_item)
  
  rand f_data wdata;
  rand logic wrst_n;
  rand logic rrst_n;
  rand logic winc;
  rand logic rinc;
  
  logic wfull;
  logic rempty;
  f_data rdata;
  
    
  `uvm_object_utils_begin(fifo_item)
    `uvm_field_int(wdata,   UVM_ALL_ON)
    `uvm_field_int(wrst_n,  UVM_ALL_ON)
    `uvm_field_int(rrst_n,  UVM_ALL_ON)
    `uvm_field_int(winc,    UVM_ALL_ON)
    `uvm_field_int(rinc,    UVM_ALL_ON)
    `uvm_field_int(rdata,   UVM_ALL_ON)
    `uvm_field_int(wfull,   UVM_ALL_ON)
    `uvm_field_int(rempty,  UVM_ALL_ON)
  `uvm_object_utils_end
  

  function new(string name = "fifo_item");
    super.new(name);
  endfunction
  

  constraint con_data {wdata inside {[0 : (1 << DATA_SIZE) - 1]};}
  constraint wdata_zero_when_idle {
    if (winc == 1'b0) {
      wdata == '0;
    }
  }

  constraint con_winc {winc dist {1:=70, 0:=30};}
  constraint con_rinc {rinc dist {1:=70, 0:=30};}


   
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
