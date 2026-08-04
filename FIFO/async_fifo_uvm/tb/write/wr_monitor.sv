/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_wr_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_wr_monitor)

  virtual fifo_if vif;
  fifo_item tr;

  uvm_analysis_port #(fifo_item) wr_send;

  function new(string name = "fifo_wr_monitor", uvm_component parent);
    super.new(name, parent);
    wr_send = new("wr_send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);

    forever begin

      @(vif.mon_wr_cb);

      if (vif.mon_wr_cb.wrst_n == 1'b0) begin
        tr = fifo_item::type_id::create("tr");
        tr.wrst_n = 1'b0; // This triggers the scoreboard's if(!tr.wrst_n)
        tr.winc   = vif.mon_wr_cb.winc;
        tr.wdata  = '0;
        tr.wfull  = vif.mon_wr_cb.wfull;
        wr_send.write(tr);
        // Optional: wait for reset to release so we don't spam the scoreboard
        wait(vif.mon_wr_cb.wrst_n == 1'b1);
      end

      if( vif.mon_wr_cb.wrst_n==1'b1) begin
        if(vif.mon_wr_cb.winc==1'b1 && vif.mon_wr_cb.wfull==1'b0 ) begin

          tr = fifo_item::type_id::create("tr");
          tr.wrst_n = vif.mon_wr_cb.wrst_n;
          tr.wdata  = vif.mon_wr_cb.wdata;
          tr.winc   = vif.mon_wr_cb.winc;
          tr.wfull  = vif.mon_wr_cb.wfull;

          `uvm_info("WR_MON",$sformatf("wrst_n = %0b, wdata =%0h, winc= %0d, wfull=%0b",tr.wrst_n,tr.wdata,tr.winc,tr.wfull),UVM_HIGH)

          wr_send.write(tr);

        end

        else if(vif.mon_wr_cb.winc==1'b1 && vif.mon_wr_cb.wfull==1'b1)begin
          tr = fifo_item::type_id::create("tr");
          tr.wrst_n = vif.mon_wr_cb.wrst_n;
          tr.wdata  = vif.mon_wr_cb.wdata;
          tr.winc   = vif.mon_wr_cb.winc;
          tr.wfull  = vif.mon_wr_cb.wfull;

          `uvm_info("WR_MON",$sformatf("wrst_n = %0b, wdata =%0h, winc= %0d, wfull=%0b",tr.wrst_n,tr.wdata,tr.winc,tr.wfull),UVM_HIGH)

          wr_send.write(tr);
        end
      end

    end

  endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
