// ==========================================================================
// Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
// Copyright:   (c) 2026 Nikita Agrawal
// License:     MIT License (see LICENSE file in root)
// ==========================================================================

class alu_agent extends uvm_agent;
  `uvm_component_utils(alu_agent)

  
  alu_driver     drv;
  alu_monitor    mon;
  uvm_sequencer#(alu_item)  sqr;


  function new(string name = "alu_agent", uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      sqr = uvm_sequencer#(alu_item)::type_id::create("sqr", this);
      drv = alu_driver::type_id::create("drv", this);
      mon = alu_monitor::type_id::create("mon", this);
   
  endfunction

  
  virtual function void connect_phase(uvm_phase phase);
    
    drv.seq_item_port.connect(sqr.seq_item_export);

  endfunction

endclass

// ==========================================================================
// Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
// Copyright:   (c) 2026 Nikita Agrawal
// License:     MIT License (see LICENSE file in root)
// ==========================================================================