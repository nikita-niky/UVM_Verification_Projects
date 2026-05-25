/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */
class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)

  virtual apb_if vif;
  apb_item tr;

  // This port sends observed items to the Scoreboard
  uvm_analysis_port #(apb_item) send;

  function new(string name = "apb_monitor", uvm_component parent);
    super.new(name, parent);
    send = new("send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);

    forever begin
      
      if(vif.preset_n==1'b0)begin
        tr = apb_item::type_id::create("tr");
        tr.preset_n = vif.preset_n;
        tr.addr = '0;
        `uvm_info("MON_RST","RESET Asserted",UVM_LOW)
        send.write(tr);
        @(vif.mon_cb);
        
        wait(vif.preset_n == 1'b1); 
        `uvm_info("MON_RST", "Reset De-asserted", UVM_LOW)
        
      end
      
      else if(vif.preset_n==1'b1) begin
        wait(vif.mon_cb.psel === 1'b1 && vif.mon_cb.penable ===1'b0);
        tr = apb_item::type_id::create("tr");
        tr.preset_n = vif.preset_n;
        tr.addr = vif.mon_cb.paddr;
        tr.write_en = vif.mon_cb.pwrite;

        if(tr.write_en)
          tr.data = vif.mon_cb.pwdata;

        @(vif.mon_cb);
        wait(vif.mon_cb.pready === 1'b1 && vif.mon_cb.penable===1'b1);
        if(!tr.write_en) 
          tr.data = vif.mon_cb.prdata;

        if(vif.mon_cb.psel===1'b1)
          tr.pslverr = vif.mon_cb.pslverr;

        `uvm_info("MON", $sformatf("Observed: Addr=%h, Data=%h, Write=%b, Err=%b", tr.addr, tr.data, tr.write_en, tr.pslverr), UVM_LOW)


        send.write(tr);
        @(vif.mon_cb);

      end
    end

  endtask
endclass

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */