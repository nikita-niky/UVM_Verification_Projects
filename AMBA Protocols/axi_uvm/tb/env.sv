/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class axi_env extends uvm_env;
  `uvm_component_utils(axi_env)

  axi_agent      agent;
  axi_scoreboard scb;
  axi_coverage cov;

  function new(string name = "axi_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = axi_agent::type_id::create("agent", this);
    scb   = axi_scoreboard::type_id::create("scb", this);
    cov   = axi_coverage::type_id::create("cov",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    // Connect Agent's Monitor to the Scoreboard
    agent.mon.ap.connect(scb.recv);
    agent.mon.ap.connect(cov.analysis_export);
  endfunction

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
