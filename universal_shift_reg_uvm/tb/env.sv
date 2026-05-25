/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class univ_sr_env extends uvm_env;
  `uvm_component_utils(univ_sr_env)

  univ_sr_agent      agent;
  univ_sr_scoreboard scb;
  univ_sr_coverage cov;

  function new(string name = "univ_sr_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = univ_sr_agent::type_id::create("agent", this);
    scb   = univ_sr_scoreboard::type_id::create("scb", this);
    cov   = univ_sr_coverage::type_id::create("cov",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);

    agent.mon.send.connect(scb.recv);
    agent.mon.send.connect(cov.analysis_export);
  endfunction

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
