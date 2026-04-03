class p_enc_test extends uvm_test;
  `uvm_component_utils(p_enc_test)

  p_enc_env env;
  p_enc_master_seq seq;

  function new(string name = "p_enc_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = p_enc_env::type_id::create("env", this);
    seq = p_enc_master_seq::type_id::create("seq");
  endfunction

  virtual task run_phase(uvm_phase phase);

    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting test...", UVM_LOW)

    seq.start(env.agent.sqr);
    #50;

    //#100ns; // Small delay before finishing
    `uvm_info(get_type_name(), "Test finished!", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass