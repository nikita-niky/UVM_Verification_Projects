class demux_env extends uvm_env;
    `uvm_component_utils(demux_env)
    demux_agent agent;
    demux_scoreboard sb;
    demux_coverage cov;
  
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = demux_agent::type_id::create("agent", this);
        sb  = demux_scoreboard::type_id::create("sb", this);
        cov = demux_coverage::type_id::create("cov", this);
    endfunction
  
    virtual function void connect_phase(uvm_phase phase);
      agent.mon.send.connect(sb.recv);
      agent.mon.send.connect(cov.analysis_export);
    endfunction
  
endclass