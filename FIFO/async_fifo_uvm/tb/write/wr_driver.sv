/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_wr_driver extends uvm_driver #(fifo_item);
  `uvm_component_utils(fifo_wr_driver)
  fifo_item tr;

 
  virtual fifo_if vif;

  function new(string name = "fifo_wr_driver", uvm_component parent);
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
    `uvm_info("WR_DRV",$sformatf("wrst_n = %0b, wdata =%0h, winc= %0d, ",tr.wrst_n,tr.wdata,tr.winc),UVM_HIGH)

    @(vif.w_cb); 

    vif.w_cb.wrst_n <= tr.wrst_n;
    vif.w_cb.winc   <= tr.winc;
    vif.w_cb.wdata  <= tr.wdata;
      
    // --- THE CRITICAL ADDITION ---
    //  Clear the increment signal so it doesn't "leak" into the next cycle
    @(vif.w_cb);
    vif.w_cb.winc <= 1'b0;
    

  endtask
endclass

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
