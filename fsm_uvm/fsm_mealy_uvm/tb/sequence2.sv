/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fsm_directed_seq extends uvm_sequence#(fsm_item);
    `uvm_object_utils(fsm_directed_seq)

    fsm_item tr;

    function new(string name = "fsm_directed_seq");
        super.new(name);
    endfunction

    virtual task body();
      `uvm_info(get_type_name(), "Starting directed Stimulus for all ports...", UVM_LOW)
       tr = fsm_item::type_id::create("tr");
      
      `uvm_do_with(tr, {tr.rst_n == 0;})
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.bit_in==1'b1;})
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.bit_in==1'b0;})      
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.bit_in==1'b1;})
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.bit_in==1'b1;})
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.bit_in==1'b1;})
             
      `uvm_info(get_type_name(), "Sequence 2 body finished", UVM_LOW)
      
    endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
