/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class p_enc_driver extends uvm_driver #(enc_item);
  `uvm_component_utils(p_enc_driver)
  enc_item tr;

 
  virtual enc_if vif;

  function new(string name = "p_enc_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual enc_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  
  virtual task run_phase(uvm_phase phase);
    forever begin
      tr= enc_item::type_id::create("tr");
      seq_item_port.get_next_item(tr);
      drive_item(tr);
      seq_item_port.item_done();
    end
  endtask

  
  virtual task drive_item(enc_item tr);
    `uvm_info(get_type_name(), "Driving transaction to pins...", UVM_HIGH)
    
    vif.req = tr.req;
    #10;
    
  endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
