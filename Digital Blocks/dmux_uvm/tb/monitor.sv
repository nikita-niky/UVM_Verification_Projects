/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class demux_monitor extends uvm_monitor;
  `uvm_component_utils(demux_monitor)
  
  virtual demux_if.MON vif;
  demux_item tr;
  
  uvm_analysis_port #(demux_item) send;

  function new(string name, uvm_component parent); 
    super.new(name, parent); 
     send = new("send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual demux_if.MON)::get(this, "", "vif", vif))
      `uvm_error("MON", "Virtual Interface (MON modport) not found")
      endfunction

   virtual task run_phase(uvm_phase phase);
    forever begin
		tr = demux_item::type_id::create("tr");
      
      @(posedge vif.clk); 
        tr.d   = vif.d;
        tr.sel = vif.sel;
      
      @(posedge vif.clk);
        foreach(tr.y[i]) begin
          tr.y[i]   = vif.y[i];
        end
        `uvm_info("MON", "Sampled data from Interface", UVM_LOW)
        send.write(tr);
      end
    
   endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
