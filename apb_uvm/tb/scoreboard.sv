/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */
class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)
  apb_item tr;

  // Port to receive items from the monitor
  uvm_analysis_imp#(apb_item, apb_scoreboard) recv;

  logic [31:0] model_mem [logic [31:0]];
  
  
  function new(string name = "apb_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv",this);
  endfunction

  
  virtual function void write(apb_item tr);
    `uvm_info(get_type_name(), "Scoreboard received item", UVM_HIGH)
    
    if(!tr.preset_n) begin
      `uvm_info("SCB_RST","RESTE Detected clearing the model mem array",UVM_LOW)
      model_mem = '{};
      return;
    end
    
    else begin
      if(tr.pslverr) begin
        `uvm_info("SCB_SLVERR", $sformatf("Observed expected/actual SLVERR at Addr: %h", tr.addr), UVM_MEDIUM)
        return; // Skip data check if there's an error
      end

      if (tr.write_en) begin
        model_mem[tr.addr] = tr.data;
        `uvm_info("SCB_WR", $sformatf("Predictor: Updated Addr = %h with Data = %h", tr.addr, tr.data), UVM_LOW)

      end

      // Case 3: Read Transaction - Compare against the Golden Model
      else begin
        if (model_mem.exists(tr.addr)) begin
          if (model_mem[tr.addr] == tr.data) begin
            `uvm_info("SCB_PASS", $sformatf("PASS: Read Addr = %h, Expected = %h, Got = %h", tr.addr, model_mem[tr.addr], tr.data), UVM_LOW)

          end
          else begin
            `uvm_error("SCB_FAIL", $sformatf("FAIL: Read Addr = %h, Expected = %h, Got = %h", tr.addr, model_mem[tr.addr], tr.data))
          end
        end
        else begin
          // If we haven't written to this address yet, the Slave RTL (our code) returns 0
          if (tr.data !== 32'h0) begin
            `uvm_error("SCB_EMPTY", $sformatf("FAIL: Read uninitialized Addr = %h, Expected 0, Got = %h", tr.addr, tr.data))
          end
        end
      end
    end


    
  endfunction

  
endclass

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */