class fifo_rd_agent extends uvm_agent;
  `uvm_component_utils(fifo_rd_agent)

 
  fifo_rd_driver     drv;
  fifo_rd_monitor    mon;
  uvm_sequencer#(fifo_item)  sqr;


  function new(string name = "fifo_rd_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = uvm_sequencer#(fifo_item)::type_id::create("sqr", this);
    drv = fifo_rd_driver::type_id::create("drv", this);
    mon = fifo_rd_monitor::type_id::create("mon", this);

  endfunction

 
  virtual function void connect_phase(uvm_phase phase);
    
    drv.seq_item_port.connect(sqr.seq_item_export);
  
  endfunction

endclass