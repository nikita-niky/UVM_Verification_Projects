class arbiter_agent extends uvm_agent;
  `uvm_component_utils(arbiter_agent)


  arbiter_driver     drv;
  arbiter_monitor    mon;
  uvm_sequencer#(arbiter_item)  sqr;


  function new(string name = "arbiter_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      sqr = uvm_sequencer#(arbiter_item)::type_id::create("sqr", this);
      drv = arbiter_driver::type_id::create("drv", this);
      mon = arbiter_monitor::type_id::create("mon", this);

    
  endfunction

 
  virtual function void connect_phase(uvm_phase phase);
 
    drv.seq_item_port.connect(sqr.seq_item_export);
    
   
  endfunction

endclass