/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */
class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)

  // Components
  apb_driver     drv;
  apb_monitor    mon;
  apb_sequencer  sqr;


  function new(string name = "apb_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build Phase: Create the components
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      sqr = apb_sequencer::type_id::create("sqr", this);
      drv = apb_driver::type_id::create("drv", this);
      mon = apb_monitor::type_id::create("mon", this);

   
  endfunction

 
  virtual function void connect_phase(uvm_phase phase);
   
    drv.seq_item_port.connect(sqr.seq_item_export);
 
  endfunction

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */