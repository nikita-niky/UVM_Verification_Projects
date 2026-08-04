/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class univ_sr_reset_seq extends uvm_sequence#(sr_item);
  `uvm_object_utils(univ_sr_reset_seq)

    sr_item tr;

  function new(string name = "univ_sr_reset_seq");
        super.new(name);
    endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence2 body", UVM_LOW) 
    tr = sr_item::type_id::create("tr");
    
    // reset during operation 
    `uvm_info("RST_SEQ","Checking rst logic",UVM_LOW)
    `uvm_do_with(tr,{tr.rst==0; tr.d_in == 4'b1111;})
    `uvm_do_with(tr, {tr.rst==1;})
  
    `uvm_info(get_type_name(), "Sequence2 body finished", UVM_LOW)    
  endtask
  
  
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
