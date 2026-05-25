/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_driver extends uvm_driver #(fifo_item);
  `uvm_component_utils(fifo_driver)
  fifo_item tr;

  virtual fifo_if vif;

  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  
  virtual task run_phase(uvm_phase phase);

    vif.drv_cb.wr_en <= 0;
    vif.drv_cb.rd_en <= 0;
    vif.drv_cb.wdata <= 0;
    
    forever begin
      tr= fifo_item::type_id::create("tr");
      seq_item_port.get_next_item(tr);
      drive_item(tr);
      seq_item_port.item_done();
    end
  endtask

  
  virtual task drive_item(fifo_item tr);
    `uvm_info(get_type_name(), "Driving transaction to pins...", UVM_HIGH)
    `uvm_info("DRV", $sformatf("rst_n = %0b, wr_en=%0b, wdata=%0h, rd_en=%0b", tr.rst_n,tr.wr_en, tr.wdata, tr.rd_en), UVM_LOW)
    
    @(vif.drv_cb);
    vif.drv_cb.rst_n <= tr.rst_n;
    vif.drv_cb.wr_en <= tr.wr_en;
    vif.drv_cb.rd_en <= tr.rd_en;

    vif.drv_cb.wdata <= tr.wdata;   
    
  endtask
endclass

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
