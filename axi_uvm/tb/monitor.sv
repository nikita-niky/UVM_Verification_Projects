/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class axi_monitor extends uvm_monitor;
  `uvm_component_utils(axi_monitor)

  virtual axi_if vif;
  uvm_analysis_port #(axi_item) ap;

  axi_item aw_fifo[$];
  axi_item w_fifo[$];
  axi_item ar_fifo[$];


  axi_item active_w_packet;
  int      w_beat_idx;

  function new(string name = "axi_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    // Secure execution boundary: hold thread operations until hardware rst drops
    if (vif.rst === 1'b1) begin
      wait(vif.rst === 1'b0);
    end
    @(vif.mon_cb);

    fork
      sample_aw_channel();
      sample_w_channel();
      sample_b_channel();
      sample_ar_channel();
      sample_r_channel();
    join
  endtask

  // ==========================================================================
  // WRITE ADDRESS CHANNEL SAMPLER
  // ==========================================================================
  virtual task sample_aw_channel();
    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.awvalid === 1'b1 && vif.mon_cb.awready === 1'b1) begin
        axi_item tr = axi_item::type_id::create("tr_aw");
        tr.op    = WRITE;
        tr.id    = vif.mon_cb.awid;
        tr.addr  = vif.mon_cb.awaddr;
        tr.len   = vif.mon_cb.awlen;
        tr.size  = vif.mon_cb.awsize;
        tr.burst = vif.mon_cb.awburst;

        aw_fifo.push_back(tr);
      end
    end
  endtask

  // ==========================================================================
  // WRITE DATA CHANNEL SAMPLER
  // ==========================================================================
  virtual task sample_w_channel();
    w_beat_idx = 0;
    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.wvalid === 1'b1 && vif.mon_cb.wready === 1'b1) begin
        // Synchronize Beat 0 with the earliest matching AW transaction block
        if (w_beat_idx == 0) begin
          // Wait if data arrives before the address phase finishes handshaking
          while (aw_fifo.size() == 0) begin
            @(vif.mon_cb);
            // If data handshakes while waiting, capture it instead of dropping it
            if (!(vif.mon_cb.wvalid && vif.mon_cb.wready)) continue;
          end

          active_w_packet = aw_fifo.pop_front();
          active_w_packet.data = new[active_w_packet.len + 1];
          active_w_packet.strb = new[active_w_packet.len + 1];
        end

        active_w_packet.data[w_beat_idx] = vif.mon_cb.wdata;
        active_w_packet.strb[w_beat_idx] = vif.mon_cb.wstrb;

        if (vif.mon_cb.wlast === 1'b1 || w_beat_idx == active_w_packet.len) begin
          if (vif.mon_cb.wlast === 1'b0 && w_beat_idx == active_w_packet.len) begin
            `uvm_error("MON_W_ERR", "WLAST missing on final expected write burst beat!")
          end

          w_fifo.push_back(active_w_packet);
          w_beat_idx = 0;
        end else begin
          w_beat_idx++;
        end
      end
    end
  endtask

  // ==========================================================================
  // WRITE RESPONSE (B) CHANNEL SAMPLER
  // ==========================================================================
  virtual task sample_b_channel();
    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.bvalid === 1'b1 && vif.mon_cb.bready === 1'b1) begin
        if (w_fifo.size() > 0) begin
          axi_item final_tr = w_fifo.pop_front();
          final_tr.resp    = new[1];
          final_tr.resp[0] = vif.mon_cb.bresp;

          // Broadcast completed write transaction out of the monitor port
          ap.write(final_tr);
        end else begin
          `uvm_error("MON_UNEXP_B", $sformatf("Observed unmapped BVALID handshake for ID: %0d", vif.mon_cb.bid))
        end
      end
    end
  endtask

  // ==========================================================================
  // READ ADDRESS CHANNEL SAMPLER
  // ==========================================================================
  virtual task sample_ar_channel();
    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.arvalid === 1'b1 && vif.mon_cb.arready === 1'b1) begin
        axi_item tr = axi_item::type_id::create("tr_ar");
        tr.op    = READ;
        tr.id    = vif.mon_cb.arid;
        tr.addr  = vif.mon_cb.araddr;
        tr.len   = vif.mon_cb.arlen;
        tr.size  = vif.mon_cb.arsize;
        tr.burst = vif.mon_cb.arburst;

        ar_fifo.push_back(tr);
      end
    end
  endtask

  // ==========================================================================
  // READ DATA CHANNEL SAMPLER
  // ==========================================================================
  virtual task sample_r_channel();
    axi_item active_r_packet;
    int      r_beat_idx = 0;

    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.rvalid === 1'b1 && vif.mon_cb.rready === 1'b1) begin
        if (r_beat_idx == 0) begin
          if (ar_fifo.size() > 0) begin
            active_r_packet = ar_fifo.pop_front();
            active_r_packet.data = new[active_r_packet.len + 1];
            active_r_packet.resp = new[active_r_packet.len + 1];
          end else begin
            `uvm_error("MON_UNEXP_R", $sformatf("Observed unexpected RVALID data beat for ID: %0d", vif.mon_cb.rid))
            continue;
          end
        end
        `uvm_info("MON_DEBUG_BEAT", $sformatf("SAMPLING BEAT %0d -> RID:%0h | Wire RDATA:%0h | Wire RLAST:%0b | Queue Size:%0d",r_beat_idx, vif.mon_cb.rid, vif.mon_cb.rdata, vif.mon_cb.rlast, ar_fifo.size()), UVM_HIGH)

        active_r_packet.data[r_beat_idx] = vif.mon_cb.rdata;
        active_r_packet.resp[r_beat_idx] = vif.mon_cb.rresp;

        if (vif.mon_cb.rlast === 1'b1 || r_beat_idx == active_r_packet.len) begin
          if (vif.mon_cb.rlast === 1'b0 && r_beat_idx == active_r_packet.len) begin
            `uvm_error("MON_R_ERR", "RLAST missing on final expected read burst beat!")
          end

          // Broadcast completed read transaction out of the monitor port
          ap.write(active_r_packet);
          r_beat_idx = 0;
        end else begin
          r_beat_idx++;
        end
      end
    end
  endtask
endclass

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
