/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class axi_test extends uvm_test;
  `uvm_component_utils(axi_test)

  axi_env env;
  axi_master_seq seq;

  function new(string name = "axi_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = axi_env::type_id::create("env", this);
  endfunction

  virtual task run_phase(uvm_phase phase);

    seq = axi_master_seq::type_id::create("seq");

    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting test...", UVM_LOW)

    seq.start(env.agent.sqr);

    #100ns; // Small delay before finishing
    `uvm_info(get_type_name(), "Test finished!", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
