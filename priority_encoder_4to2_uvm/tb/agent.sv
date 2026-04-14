class p_enc_agent extends uvm_agent;
  `uvm_component_utils(p_enc_agent)

 
  p_enc_driver     drv;
  p_enc_monitor    mon;
  uvm_sequencer#(enc_item)  sqr;


  function new(string name = "p_enc_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      sqr = uvm_sequencer#(enc_item)::type_id::create("sqr", this);
      drv = p_enc_driver::type_id::create("drv", this);
      mon = p_enc_monitor::type_id::create("mon", this);

   endfunction

  
  virtual function void connect_phase(uvm_phase phase);
  
    drv.seq_item_port.connect(sqr.seq_item_export);

  endfunction

endclass