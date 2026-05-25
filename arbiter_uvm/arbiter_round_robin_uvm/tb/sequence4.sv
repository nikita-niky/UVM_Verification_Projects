/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class arb_directed_sequence extends uvm_sequence #(arb_item);
  `uvm_object_utils(arb_directed_sequence)
  arb_item tr;


  function new(string name = "arb_directed_sequence");
    super.new(name);
  endfunction

  
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence 4 body", UVM_LOW)

    `uvm_do_with(tr,{tr.rst_n == 1'b1; tr.req == 4'b0001 ;})
    `uvm_do_with(tr,{tr.rst_n == 1'b1; tr.req == 4'b0100 ;})
    `uvm_do_with(tr,{tr.rst_n == 1'b1; tr.req == 4'b0010 ;})
    `uvm_do_with(tr,{tr.rst_n == 1'b1; tr.req == 4'b1000 ;})
    `uvm_do_with(tr,{tr.rst_n == 1'b0; tr.req == 4'b1111 ;})///rst active
    
    
    `uvm_info(get_type_name(), "Sequence 4 body finished", UVM_LOW)
  endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
