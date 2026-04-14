class arb_env extends uvm_env;
  `uvm_component_utils(arb_env)

  arb_agent      agent;
  arb_scoreboard scb;
  arb_coverage cov;

  function new(string name = "arb_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = arb_agent::type_id::create("agent", this);
    scb   = arb_scoreboard::type_id::create("scb", this);
    cov   = arb_coverage::type_id::create("cov",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
   
    agent.mon.send.connect(scb.recv);
    agent.mon.send.connect(cov.analysis_export);
  endfunction

endclass