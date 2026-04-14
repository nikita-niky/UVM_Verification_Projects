class univ_sr_agent extends uvm_agent;
  `uvm_component_utils(univ_sr_agent)


  univ_sr_driver     drv;
  univ_sr_monitor    mon;
  uvm_sequencer#(sr_item)  sqr;


  function new(string name = "univ_sr_agent", uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = uvm_sequencer#(sr_item)::type_id::create("sqr", this);
    drv = univ_sr_driver::type_id::create("drv", this);
    mon = univ_sr_monitor::type_id::create("mon", this);

  endfunction


  virtual function void connect_phase(uvm_phase phase);

    drv.seq_item_port.connect(sqr.seq_item_export);

  endfunction

endclass