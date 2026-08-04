/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class mux_test extends uvm_test;
    `uvm_component_utils(mux_test)
    mux_env env;

      mux_master_seq seq;
    
  function new(string name, uvm_component parent);
      super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
        env = mux_env::type_id::create("env", this);
    endfunction
  
  virtual task run_phase(uvm_phase phase);
    
    seq= mux_master_seq::type_id::create("seq");

    
        phase.raise_objection(this);
        seq.start(env.agent.sqr);

    
        #10;
        phase.drop_objection(this);
    
    endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
