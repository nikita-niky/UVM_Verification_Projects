class univ_sr_test extends uvm_test;
  `uvm_component_utils(univ_sr_test)

  univ_sr_env env;
  univ_sr_master_seq seq;

  function new(string name = "univ_sr_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = univ_sr_env::type_id::create("env", this);
  endfunction

  virtual task run_phase(uvm_phase phase);

    seq = univ_sr_master_seq::type_id::create("seq");

    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting test...", UVM_LOW)

    seq.start(env.agent.sqr);

    #50ns; // Small delay before finishing
    `uvm_info(get_type_name(), "Test finished!", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass