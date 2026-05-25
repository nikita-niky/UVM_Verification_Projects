/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_rd_driver extends uvm_driver #(fifo_item);
  `uvm_component_utils(fifo_rd_driver)
  fifo_item tr;


  virtual fifo_if vif;

  function new(string name = "fifo_rd_driver", uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction


  virtual task run_phase(uvm_phase phase);

    forever begin
      tr= fifo_item::type_id::create("tr");
      seq_item_port.get_next_item(tr);
      drive_item(tr);
      seq_item_port.item_done();
    end
  endtask


  virtual task drive_item(fifo_item tr);
    `uvm_info(get_type_name(), "Driving transaction to pins...", UVM_HIGH)
    `uvm_info("RD_DRV",$sformatf("rrst_n = %0b, rinc= %0d",tr.rrst_n,tr.rinc),UVM_HIGH)

    @(vif.r_cb);

    vif.r_cb.rrst_n <= tr.rrst_n;
    vif.r_cb.rinc   <= tr.rinc;

    // Clear rinc after the read is successful
    @(vif.r_cb);
    vif.r_cb.rinc <= 1'b0;


  endtask
endclass

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
