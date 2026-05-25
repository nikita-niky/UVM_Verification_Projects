/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class counter_monitor extends uvm_monitor;
  `uvm_component_utils(counter_monitor)

  virtual counter_if vif;
  counter_item tr;


  uvm_analysis_port #(counter_item) send;

  function new(string name = "counter_monitor", uvm_component parent);
    super.new(name, parent);
    send = new("send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual counter_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    
    forever begin
      tr = counter_item::type_id::create("tr");   
      @(vif.mon_cb);

      if(vif.mon_cb.rst) begin
        `uvm_info("MON", "Reset Active", UVM_LOW)
        tr.rst      = vif.mon_cb.rst;
        tr.load     = vif.mon_cb.load;
        tr.up_down  = vif.mon_cb.up_down;
        tr.count_in = vif.mon_cb.count_in;
        tr.count    = vif.mon_cb.count;
        tr.max_tick = vif.mon_cb.max_tick;
        tr.min_tick = vif.mon_cb.min_tick;
        
        
        send.write(tr); 
        
        `uvm_info("MON",$sformatf("rst=%0b | load =%0b | up_down=%0b | count_in=%0d | count=%0d | max_tick=%0d | min_tick=%0d",tr.rst,tr.load,tr.up_down, tr.count_in, tr.count, tr.max_tick,tr.min_tick),UVM_LOW)

      end

      else begin      

        tr.rst      = vif.mon_cb.rst;
        tr.load     = vif.mon_cb.load;
        tr.up_down  = vif.mon_cb.up_down;
        tr.count_in = vif.mon_cb.count_in;
        tr.count    = vif.mon_cb.count;
        tr.max_tick = vif.mon_cb.max_tick;
        tr.min_tick = vif.mon_cb.min_tick;


        send.write(tr);

        `uvm_info("MON",$sformatf("rst=%0b | load =%0b | up_down=%0b | count_in=%0d | count=%0d | max_tick=%0d | min_tick=%0d",tr.rst,tr.load,tr.up_down, tr.count_in, tr.count, tr.max_tick,tr.min_tick),UVM_LOW)


      end
        
    end
  endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
