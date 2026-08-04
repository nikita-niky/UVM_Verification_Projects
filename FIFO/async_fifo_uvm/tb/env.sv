/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)

  fifo_wr_agent      wr_agent;
  fifo_rd_agent      rd_agent;
  fifo_scoreboard scb;
  fifo_coverage cov;

  function new(string name = "fifo_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_agent = fifo_wr_agent::type_id::create("wr_agent", this);
    rd_agent = fifo_rd_agent::type_id::create("rd_agent", this);
    scb   = fifo_scoreboard::type_id::create("scb", this);
    cov   = fifo_coverage::type_id::create("cov",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    // Connect Agent's Monitor to the Scoreboard
    wr_agent.mon.wr_send.connect(scb.wr_recv);
    rd_agent.mon.rd_send.connect(scb.rd_recv);
    
    wr_agent.mon.wr_send.connect(cov.analysis_export);
    rd_agent.mon.rd_send.connect(cov.analysis_export);
  endfunction

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
