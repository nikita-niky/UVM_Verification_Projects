/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_random_test extends uvm_test;
  `uvm_component_utils(fifo_random_test)
  virtual fifo_if vif;

  fifo_env env;
  fifo_random_seq wr_seq;
  fifo_random_seq rd_seq;


  function new(string name = "fifo_random_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
    env = fifo_env::type_id::create("env", this);
  endfunction

  virtual task run_phase(uvm_phase phase);

    wr_seq = fifo_random_seq::type_id::create("wr_seq");
    rd_seq = fifo_random_seq::type_id::create("rd_seq");

    wr_seq.is_write_mode = 1;
    rd_seq.is_write_mode = 0;

    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting test...", UVM_LOW)

    fork
      wr_seq.start(env.wr_agent.sqr);
      rd_seq.start(env.rd_agent.sqr);
    join

    while (vif.rempty === 1'b0) begin
      @(vif.r_cb);
      vif.r_cb.rinc <= 1'b1;
    end

    vif.r_cb.rinc <= 1'b0;
    
    repeat(5) @(vif.r_cb);
    `uvm_info(get_type_name(), "Test finished!", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
