/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class apb_item extends uvm_sequence_item;
  
  rand logic [ADDR_SIZE-1:0] addr;
  rand logic [DATA_SIZE-1:0] data;
  rand logic                 write_en;
  rand int                   delay;
  
 
  logic [DATA_SIZE-1:0] prdata;  
  logic                 pslverr;
  logic                 preset_n;


  `uvm_object_utils_begin(apb_item)
  `uvm_field_int(addr, UVM_ALL_ON)
  `uvm_field_int(data, UVM_ALL_ON)
  `uvm_field_int(write_en, UVM_ALL_ON)
  `uvm_field_int(delay, UVM_ALL_ON)
  
  `uvm_field_int(prdata, UVM_ALL_ON)
  `uvm_field_int(pslverr, UVM_ALL_ON)
  `uvm_field_int(preset_n, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "apb_item");
    super.new(name);
  endfunction
  
  constraint addr_align{ addr[1:0] == 2'b00;}
  constraint addr_range {addr <= 32'h0000_003C;}
  constraint delay_range {delay inside {[0:10]};}
  


endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
