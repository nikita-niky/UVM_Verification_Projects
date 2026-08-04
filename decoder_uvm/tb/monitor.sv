/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class dec_monitor extends uvm_monitor;
  `uvm_component_utils(dec_monitor)

  virtual dec_if vif;
  dec_item tr;

 
  uvm_analysis_port #(dec_item) send;

  function new(string name = "dec_monitor", uvm_component parent);
    super.new(name, parent);
    send = new("send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dec_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    
    forever begin
      tr = dec_item::type_id::create("tr");
      @(vif.sel or vif.en);
      #2; 
      tr.sel = vif.sel;
      tr.en = vif.en;
      tr.y = vif.y;
      
      `uvm_info("MON", $sformatf("Sampled: %s", tr.convert2string()), UVM_LOW)
      
       send.write(tr);
    
    end
  endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
