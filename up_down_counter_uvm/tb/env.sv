class counter_env extends uvm_env;
  `uvm_component_utils(counter_env)

  counter_agent      agent;
  counter_scoreboard scb;
  counter_coverage cov;

  function new(string name = "counter_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = counter_agent::type_id::create("agent", this);
    scb   = counter_scoreboard::type_id::create("scb", this);
    cov   = counter_coverage::type_id::create("cov",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    
    agent.mon.send.connect(scb.recv);
    agent.mon.send.connect(cov.analysis_export);
  endfunction

endclass