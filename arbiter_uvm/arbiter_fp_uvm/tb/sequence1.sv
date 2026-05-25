/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class arbiter_directed_sequence extends uvm_sequence #(arbiter_item);
  `uvm_object_utils(arbiter_directed_sequence)
  
  arbiter_item tr;


  function new(string name = "arbiter_directed_sequence");
    super.new(name);
  endfunction

 
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence body", UVM_LOW)

    `uvm_do_with(tr,{tr.rst_n==1; tr.req == 4'b0000;})
    `uvm_do_with(tr,{tr.rst_n==1; tr.req == 4'b0001;})
    `uvm_do_with(tr,{tr.rst_n==1; tr.req == 4'b0010;})
    `uvm_do_with(tr,{tr.rst_n==1; tr.req == 4'b0100;})
    `uvm_do_with(tr,{tr.rst_n==1; tr.req == 4'b1000;})
    

    `uvm_info(get_type_name(), "Sequence body finished", UVM_LOW)
  endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
