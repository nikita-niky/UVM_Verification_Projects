/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fsm_agent extends uvm_agent;
  `uvm_component_utils(fsm_agent)


  fsm_driver     drv;
  fsm_monitor    mon;
  uvm_sequencer#(fsm_item)  sqr;


  function new(string name = "fsm_agent", uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = uvm_sequencer#(fsm_item)::type_id::create("sqr", this);
    drv = fsm_driver::type_id::create("drv", this);
    mon = fsm_monitor::type_id::create("mon", this);

  endfunction


  virtual function void connect_phase(uvm_phase phase);

    drv.seq_item_port.connect(sqr.seq_item_export);

  endfunction

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
