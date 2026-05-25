/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)

  virtual apb_if vif;
  apb_env env;
  apb_master_seq seq;
  apb_reset_chk_seq rst_seq;

  function new(string name = "apb_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
    env = apb_env::type_id::create("env", this);
  endfunction

  virtual task run_phase(uvm_phase phase);

    seq = apb_master_seq::type_id::create("seq");
    rst_seq = apb_reset_chk_seq::type_id::create("rst_seq");

    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting test...", UVM_LOW)
    begin
      vif.preset_n = 0;
      #20ns;
      vif.preset_n = 1;
      #20ns;
      seq.start(env.agent.sqr);
      #100;
      rst_seq.start(env.agent.sqr);
    end
    
    `uvm_info(get_type_name(), "Starting RESET test...", UVM_LOW)
    begin
        
        `uvm_info("TEST", "!!! TRIGGERING RESET DURING TRANSFERS !!!", UVM_LOW)
        vif.preset_n = 0;
        #50ns;
        vif.preset_n = 1;
        `uvm_info("TEST", "Reset Released", UVM_LOW)
      end
    
    
    
    begin
      `uvm_info("TEST", "Starting Recovery Sequence", UVM_LOW)
      seq.s1.start(env.agent.sqr);
    end

    
    #100ns; // Small delay before finishing
    `uvm_info(get_type_name(), "Test finished!", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
