/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_reset_op_seq extends uvm_sequence#(fifo_item);
  `uvm_object_utils(fifo_reset_op_seq)
  fifo_item tr;

  bit is_write_mode;

  function new(string name = "fifo_reset_op_seq");
    super.new(name);
  endfunction


  virtual task body();
        // 1. Initial Reset to start clean
        tr= fifo_item::type_id::create("tr");
        repeat(2) begin
            `uvm_do_with(tr,{tr.wrst_n==1'b0; tr.rrst_n==1'b0; tr.winc==1'b0; tr.rinc==1'b0;})
        end
        #30;

        // 2. Start normal operation
        `uvm_info("RESET_SEQ", $sformatf("Starting traffic for %s", is_write_mode ? "Write" : "Read"), UVM_LOW)

        repeat(50) begin
            // Randomly inject a reset halfway through the traffic
            // This mimics a system-level brownout or emergency reset
            bit trigger_reset = ($urandom_range(0, 100) > 95); 

            if (trigger_reset) begin
                `uvm_info("RESET_SEQ", "Injecting Reset Transaction", UVM_LOW)
                // Send a specific 'Reset' item
                `uvm_do_with(req, {
                if(is_write_mode) { wrst_n == 0; winc == 0; rrst_n == 1; }
                else              { rrst_n == 0; rinc == 0; wrst_n == 1; }
                })

                // Optional: Send a few more idle cycles while in reset
                repeat(3) begin
                    `uvm_do_with(req, { wrst_n == 0; rrst_n == 0; winc == 0; rinc == 0; })
                end
                #50;
             repeat(3) begin
                    `uvm_do_with(req, { wrst_n == 1; rrst_n == 1; winc == 0; rinc == 0; })
                end
                #50;
            end 
            else begin
                repeat(3) begin
                    `uvm_do_with(req, { wrst_n == 1; rrst_n == 1; winc == 0; rinc == 0; })
                end
                #50;
                // Normal Operation
                `uvm_do_with(req, {
                if(is_write_mode) { wrst_n == 1; winc == 1; rrst_n == 1; rinc == 0; }
                else              { rrst_n == 1; rinc == 1; wrst_n == 1; winc == 0; }
                })
            end
         end
    endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
