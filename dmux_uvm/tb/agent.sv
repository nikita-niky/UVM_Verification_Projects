/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class demux_agent extends uvm_agent;
  `uvm_component_utils(demux_agent)
  
  demux_driver drv;
  demux_monitor mon;
  uvm_sequencer #(demux_item) sqr;
  
  function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  
  virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = demux_driver::type_id::create("drv", this);
        mon = demux_monitor::type_id::create("mon", this);
    sqr = uvm_sequencer#(demux_item)::type_id::create("sqr", this);
    endfunction
  
  virtual function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
  
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
