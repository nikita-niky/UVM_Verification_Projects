class fsm_env extends uvm_env;
  `uvm_component_utils(fsm_env)

  fsm_agent      agent;
  fsm_scoreboard scb;
  fsm_coverage cov;

  function new(string name = "fsm_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = fsm_agent::type_id::create("agent", this);
    scb   = fsm_scoreboard::type_id::create("scb", this);
    cov   = fsm_coverage::type_id::create("cov",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
  
    agent.mon.send.connect(scb.recv);
    agent.mon.send.connect(cov.analysis_export);
  endfunction

endclass