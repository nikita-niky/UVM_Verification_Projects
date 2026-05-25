// ==========================================================================
// Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
// Copyright:   (c) 2026 Nikita Agrawal
// License:     MIT License (see LICENSE file in root)
// ==========================================================================

class alu_driver extends uvm_driver #(alu_item);
  `uvm_component_utils(alu_driver)
  alu_item tr;

 
  virtual alu_if vif;

  function new(string name = "alu_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  
  virtual task run_phase(uvm_phase phase);
    
    vif.drv_cb.rst <= 1'b1;
    vif.drv_cb.a   <=4'b0;
    vif.drv_cb.b   <=4'b0;
    vif.drv_cb.op  <=3'b0;
    
    repeat(2)@ (vif.drv_cb);
    vif.drv_cb.rst  <=1'b0;
    
    forever begin
      tr= alu_item::type_id::create("tr");
      seq_item_port.get_next_item(tr);
      drive_item(tr);
      seq_item_port.item_done();
    end
  endtask

  
  virtual task drive_item(alu_item tr);
    `uvm_info(get_type_name(), "Driving transaction to pins...", UVM_HIGH)
   
    
    @(vif.drv_cb);
    
    vif.drv_cb.a  <= tr.a;
    vif.drv_cb.b  <= tr.b;
    vif.drv_cb.op <= tr.op;
    
    @(vif.drv_cb);
    
     `uvm_info("DRV", $sformatf("A=%0d B=%0d OP=%s", tr.a, tr.b, tr.op.name()), UVM_LOW)
    
  endtask
endclass

// ==========================================================================
// Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
// Copyright:   (c) 2026 Nikita Agrawal
// License:     MIT License (see LICENSE file in root)
// ==========================================================================