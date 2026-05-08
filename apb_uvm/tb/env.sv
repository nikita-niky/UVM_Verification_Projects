class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)

  apb_agent      agent;
  apb_scoreboard scb;
  apb_coverage cov;

  function new(string name = "apb_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = apb_agent::type_id::create("agent", this);
    scb   = apb_scoreboard::type_id::create("scb", this);
    cov   = apb_coverage::type_id::create("cov",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    // Connect Agent's Monitor to the Scoreboard
    agent.mon.send.connect(scb.recv);
    agent.mon.send.connect(cov.analysis_export);
  endfunction

endclass