/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class p_enc_env extends uvm_env;
  `uvm_component_utils(p_enc_env)

  p_enc_agent      agent;
  p_enc_scoreboard scb;
  p_enc_coverage cov;

  function new(string name = "p_enc_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = p_enc_agent::type_id::create("agent", this);
    scb   = p_enc_scoreboard::type_id::create("scb", this);
    cov   = p_enc_coverage::type_id::create("cov",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    // Connect Agent's Monitor to the Scoreboard
    agent.mon.send.connect(scb.recv);
    agent.mon.send.connect(cov.analysis_export);
  endfunction

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
