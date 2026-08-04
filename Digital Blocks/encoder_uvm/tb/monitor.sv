/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class p_enc_monitor extends uvm_monitor;
  `uvm_component_utils(p_enc_monitor)

  virtual enc_if vif;
  enc_item tr;

  
  uvm_analysis_port #(enc_item) send;

  function new(string name = "p_enc_monitor", uvm_component parent);
    super.new(name, parent);
    send = new("send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual enc_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    
    forever begin
      tr = enc_item::type_id::create("tr");
      //waitin for req to change
      @(vif.req);
      #1;
      
      tr.req = vif.req;
      tr.code =vif.code;
      tr.valid = vif.valid;
           
       send.write(tr);
     
    end
  endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
