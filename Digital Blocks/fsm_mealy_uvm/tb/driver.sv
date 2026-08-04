/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fsm_driver extends uvm_driver #(fsm_item);
  `uvm_component_utils(fsm_driver)
  fsm_item tr;

  
  virtual fsm_if vif;

  function new(string name = "fsm_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fsm_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

 
  virtual task run_phase(uvm_phase phase);
    //Initial Reset - Simple implementation for standalone verification
    //Note: In SOC-level DV, this would be handled via a Reset Sequence.
    vif.drv_cb.rst_n <=1'b0;
    vif.drv_cb.bit_in <=1'b0;
    
    
    repeat(2)@(vif.drv_cb);
    
    vif.drv_cb.rst_n <=1'b1;
    
    forever begin
      tr= fsm_item::type_id::create("tr");
      seq_item_port.get_next_item(tr);
      drive_item(tr);
      seq_item_port.item_done();
    end
  endtask

 
  virtual task drive_item(fsm_item tr);
    `uvm_info(get_type_name(), "Driving transaction to pins...", UVM_HIGH)
    
    @(vif.drv_cb);
    vif.drv_cb.rst_n <= tr.rst_n;
    vif.drv_cb.bit_in <= tr.bit_in;
    
    `uvm_info("DRV", $sformatf("Driving rst_n = %0b | bit_in = %b", tr.rst_n, tr.bit_in), UVM_LOW)
  endtask
endclass

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
