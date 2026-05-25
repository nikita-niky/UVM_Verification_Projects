/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */
class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)

  virtual alu_if vif;
  alu_item tr;

  uvm_analysis_port #(alu_item) send;

  function new(string name = "alu_monitor", uvm_component parent);
    super.new(name, parent);
    send = new("send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    
    forever begin
      tr = alu_item::type_id::create("tr");
      tr.rst = vif.mon_cb.rst;
      @(vif.mon_cb);

      if(!vif.mon_cb.rst) begin

        
        tr.a = vif.mon_cb.a;
        tr.b = vif.mon_cb.b;
        tr.op = alu_op_e'(vif.mon_cb.op);
        
        @(vif.mon_cb);
        
        tr.res = vif.mon_cb.res;
        tr.carry= vif.mon_cb.carry;
        tr.zero = vif.mon_cb.zero;
        tr.neg = vif.mon_cb.neg;
        tr.ovfl = vif.mon_cb.ovfl;
        
        `uvm_info("MON",$sformatf("A=%0d B=%0d OP=%s res=%d C=%b Z=%b N=%b O=%b", tr.a, tr.b, tr.op.name(), tr.res, tr.carry, tr.zero, tr.neg, tr.ovfl ), UVM_LOW)
        send.write(tr);
        
      end
      else begin
        `uvm_info("MON", "Reset Active - Sampling for Coverage", UVM_HIGH)
      send.write(tr); 
    end
        
    end
  endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
