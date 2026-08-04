/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class axi_driver extends uvm_driver #(axi_item);
  `uvm_component_utils(axi_driver)

  virtual axi_if vif;


  semaphore write_bus_lock;
  semaphore read_bus_lock;


  axi_item b_track[int][$]; 
  axi_item r_track[int][$]; 

  // --- Watchdog Configuration ---
  int timeout_cycles = 500; 

  function new(string name = "axi_driver", uvm_component parent);
    super.new(name, parent);
    write_bus_lock = new(1);
    read_bus_lock  = new(1);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    reset_signals();

    fork
      // Main Sequence Fetch Loop
      forever begin
        axi_item tr;
        seq_item_port.get_next_item(tr);

        `uvm_info("DRV", $sformatf("Accepting %s transfer. ID: %0d, Addr: %h, Len: %0d", tr.op.name(), tr.id, tr.addr, tr.len), UVM_HIGH)

        if(tr.op == WRITE) begin
          drive_write(tr);
        end else if(tr.op == READ) begin
          drive_read(tr);
        end

        seq_item_port.item_done();
      end

      // Continuous background channel handlers
      handle_b_channel();
      handle_r_channel();
      watchdog_timer();
    join
  endtask

  // --- Signal Initialization ---
  virtual task reset_signals();
    if (vif.rst === 1'b1) begin
      `uvm_info("DRV", "Waiting for Reset Release...", UVM_LOW)
      vif.drv_cb.awvalid <= 1'b0;
      vif.drv_cb.wvalid  <= 1'b0;
      vif.drv_cb.bready  <= 1'b0;
      vif.drv_cb.arvalid <= 1'b0;
      vif.drv_cb.rready  <= 1'b0;
      vif.drv_cb.wlast   <= 1'b0;


      wait(vif.rst === 1'b0);
    end
    @(vif.drv_cb);
    `uvm_info("DRV", "Reset De-asserted. Driver Operational.", UVM_LOW)
  endtask

  // --- Write Channel Driver ---
  virtual task drive_write(axi_item tr);

    write_bus_lock.get(1);
    b_track[tr.id].push_back(tr);


    fork
      // Channel: Write Address (AW)
      begin

        vif.drv_cb.awvalid <= 1'b1;
        vif.drv_cb.awid    <= tr.id;
        vif.drv_cb.awaddr  <= tr.addr;
        vif.drv_cb.awlen   <= tr.len;
        vif.drv_cb.awsize  <= tr.size;
        vif.drv_cb.awburst <= tr.burst;

        do begin
          @(vif.drv_cb);
        end while(vif.drv_cb.awready !== 1'b1);

        vif.drv_cb.awvalid <= 1'b0;
      end

      // Channel: Write Data (W)
      begin

        while(vif.drv_cb.awready !== 1'b1) begin
          @(vif.drv_cb);
        end

        for(int i=0; i<= tr.len; i++) begin
          vif.drv_cb.wvalid <= 1'b1;
          vif.drv_cb.wdata  <= tr.data[i];
          vif.drv_cb.wstrb  <= tr.strb[i];
          vif.drv_cb.wlast  <= (i == tr.len);

          do begin
            @(vif.drv_cb);
          end while (vif.drv_cb.wready !== 1'b1);
        end
        vif.drv_cb.wvalid <= 1'b0;
        vif.drv_cb.wlast  <= 1'b0;
      end

    join

    // Release write bus lock only after data phase finishes
    write_bus_lock.put(1);
  endtask

  // --- Read Channel Driver ---
  virtual task drive_read(axi_item tr);
    // Lock read channel to match in-order slave processing limits
    read_bus_lock.get(1);
    r_track[tr.id].push_back(tr);

    vif.drv_cb.arvalid <= 1'b1;
    vif.drv_cb.arid    <= tr.id;
    vif.drv_cb.araddr  <= tr.addr;
    vif.drv_cb.arlen   <= tr.len;
    vif.drv_cb.arsize  <= tr.size;
    vif.drv_cb.arburst <= tr.burst;

    do begin
      @(vif.drv_cb);
    end while (vif.drv_cb.arready !== 1'b1);

    vif.drv_cb.arvalid <= 1'b0;

    // Hold lock until background R channel thread completes final beat collection
    // This stops driver from pulsing arvalid while slave is busy streaming data.
  endtask

  // --- Write Response (B) Handler ---
  virtual task handle_b_channel();
    vif.drv_cb.bready <= 1'b1;
    forever begin
      @(vif.drv_cb);
      if (vif.drv_cb.bvalid === 1'b1 && vif.bready === 1'b1) begin
        int id = vif.drv_cb.bid;
        if (b_track.exists(id) && b_track[id].size() > 0) begin
          axi_item tr_match = b_track[id].pop_front();
          tr_match.resp = new[1];
          tr_match.resp[0] = vif.drv_cb.bresp;

          `uvm_info("DRV_B_CHAN", $sformatf("Write Response Received for ID: %0d -> RESP: %2b", id, tr_match.resp[0]), UVM_HIGH)
          if (b_track[id].size() == 0) b_track.delete(id);
        end else begin
          `uvm_error("DRV_UNEXP_B", $sformatf("Unmapped BVALID observed for ID: %0d", id))
        end
      end
    end
  endtask

  // --- Read Data (R) Handler ---
  virtual task handle_r_channel();
    vif.drv_cb.rready <= 1'b1;
    forever begin
      @(vif.drv_cb);
      if (vif.drv_cb.rvalid === 1'b1 && vif.rready === 1'b1) begin
        int id = vif.drv_cb.rid;
        if (r_track.exists(id) && r_track[id].size() > 0) begin
          axi_item tr_match = r_track[id][0]; 
          int b_idx;

          if (tr_match.data.size() == 0) begin
            tr_match.data = new[tr_match.len + 1];
            tr_match.resp = new[tr_match.len + 1];
            tr_match.current_beat_idx = 0;
          end

          b_idx = tr_match.current_beat_idx;
          tr_match.data[b_idx] = vif.drv_cb.rdata;
          tr_match.resp[b_idx] = vif.drv_cb.rresp;

          if(vif.drv_cb.rlast === 1'b1) begin
            if (b_idx != tr_match.len) begin
              `uvm_error("DRV_ERR", $sformatf("Premature RLAST seen at beat %0d! Expected: %0d", b_idx, tr_match.len))
            end
            void'(r_track[id].pop_front());
            if (r_track[id].size() == 0) r_track.delete(id);

            // Release read channel lock: Safe to issue next AR address now
            read_bus_lock.put(1);
          end else begin
            if (b_idx == tr_match.len) begin
              `uvm_error("DRV_ERR", $sformatf("RLAST missing on final expected beat (%0d) for ID %0d!", b_idx, id))
            end
            tr_match.current_beat_idx++;
          end
        end else begin
          `uvm_error("DRV_UNEXP_R", $sformatf("Unmapped RVALID observed for ID: %0d", id))
        end
      end
    end
  endtask

  // --- Unified Timeout Watchdog Timer ---
  virtual task watchdog_timer();
    int idle_count = 0;
    forever begin
      @(vif.drv_cb);
      if (b_track.size() > 0 || r_track.size() > 0) begin
        // A stall occurs when valid pins are high but ready pins remain low
        bit is_stalled = (vif.awvalid && !vif.drv_cb.awready) ||
        (vif.wvalid  && !vif.drv_cb.wready)  ||
        (vif.drv_cb.bvalid  && !vif.bready)  ||
        (vif.arvalid && !vif.drv_cb.arready) ||
        (vif.drv_cb.rvalid  && !vif.rready);

        if (is_stalled) begin
          idle_count++;
          //           `uvm_info("cnt",$sformatf("count = %0d",idle_count),UVM_LOW)
          if (idle_count >= timeout_cycles) begin
            `uvm_fatal("DRV_WATCHDOG", $sformatf("AXI Bus Handshake Timeout! Slave stalled for %0d cycles.", timeout_cycles))
          end
        end else begin
          idle_count = 0;
        end
      end else begin
        idle_count = 0;
      end
    end
  endtask
endclass

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
