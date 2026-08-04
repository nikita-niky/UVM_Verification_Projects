/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_rd_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_rd_monitor)

  virtual fifo_if vif;
  fifo_item tr;

  // This port sends observed items to the Scoreboard
  uvm_analysis_port #(fifo_item) rd_send;

  function new(string name = "fifo_rd_monitor", uvm_component parent);
    super.new(name, parent);
    rd_send = new("rd_send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    bit read_active_last_cycle =0;
    bit read_inactive_last_cycle =0;

    forever begin

      @(vif.mon_rd_cb);

      if (vif.mon_rd_cb.rrst_n == 1'b0) begin
        read_active_last_cycle = 0; // Clear internal state
        read_inactive_last_cycle =0;
        tr = fifo_item::type_id::create("tr");
        tr.rrst_n = 1'b0;
        tr.rinc   = vif.mon_rd_cb.rinc;
        tr.rdata  = vif.mon_rd_cb.rdata;
        tr.rempty = vif.mon_rd_cb.rempty;
        rd_send.write(tr);
        wait(vif.mon_rd_cb.rrst_n == 1'b1);
      end

      if(vif.mon_rd_cb.rrst_n==1'b1) begin
        if(read_active_last_cycle) begin

          tr = fifo_item::type_id::create("tr");
          tr.rinc   = 1'b1;
          tr.rrst_n = vif.mon_rd_cb.rrst_n;  
          tr.rdata  = vif.mon_rd_cb.rdata;
          tr.rempty = 1'b0;

          `uvm_info("RD_MON",$sformatf("rrst_n = %0b, rdata =%0h, rinc= %0d, rempty=%0b",tr.rrst_n,tr.rdata,tr.rinc,tr.rempty),UVM_HIGH)

          rd_send.write(tr);


        end

        read_active_last_cycle = (vif.mon_rd_cb.rinc==1'b1 && vif.mon_rd_cb.rempty==1'b0);
        read_inactive_last_cycle = (vif.mon_rd_cb.rinc==1'b1 && vif.mon_rd_cb.rempty==1'b1);

      end
      else if(read_inactive_last_cycle) begin

        tr = fifo_item::type_id::create("tr");
        tr.rinc   = 1'b1;
        tr.rrst_n = vif.mon_rd_cb.rrst_n;  
        tr.rdata  = vif.mon_rd_cb.rdata;
        tr.rempty = 1'b1;

        `uvm_info("RD_MON",$sformatf("rrst_n = %0b, rdata =%0h, rinc= %0d, rempty=%0b",tr.rrst_n,tr.rdata,tr.rinc,tr.rempty),UVM_HIGH)

        rd_send.write(tr);

      end
    end
  endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
