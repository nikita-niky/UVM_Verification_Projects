class demux_test extends uvm_test;
  `uvm_component_utils(demux_test)
    demux_env env;

      demux_master_seq seq;
    
  function new(string name, uvm_component parent);
      super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
        env = demux_env::type_id::create("env", this);
    endfunction
  
  virtual task run_phase(uvm_phase phase);
    
    seq= demux_master_seq::type_id::create("seq");

    
        phase.raise_objection(this);
    
        seq.start(env.agent.sqr);

        #10;
        phase.drop_objection(this);
    
    endtask
endclass