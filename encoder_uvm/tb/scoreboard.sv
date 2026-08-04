/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */


class p_enc_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(p_enc_scoreboard)
  enc_item tr;


  uvm_analysis_imp #(enc_item, p_enc_scoreboard) recv;

  // Simple counters for checking
  int pass_count = 0;
  int fail_count = 0;
  logic [1:0] exp_code;
  logic exp_valid;

  function new(string name = "p_enc_scoreboard", uvm_component parent);
    super.new(name, parent);
    recv = new("recv",this);
  endfunction
  
  virtual function void write(enc_item tr);
    
   `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)
    exp_code = 2'b00;  // Reset every time
   exp_valid = 1'b0; // Reset every time
    ///Referance model
         if (tr.req[3]) begin exp_code =2'b11; exp_valid = 1'b1; end
    else if (tr.req[2]) begin exp_code =2'b10; exp_valid = 1'b1; end
    else if (tr.req[1]) begin exp_code =2'b01; exp_valid = 1'b1; end
    else if (tr.req[0]) begin exp_code =2'b00; exp_valid = 1'b1; end
    else begin exp_code = 2'b00; exp_valid = 1'b0; end
    // comparision
    
    if ((tr.code== exp_code) && (tr.valid == exp_valid)) begin
      pass_count++;
      `uvm_info("SCB_PASS",$sformatf("PASS !! Req = %0b-> Got code =%0d, valid =%0b",tr.req,tr.code,tr.valid),UVM_LOW)
    end
    else begin
      fail_count++;
      `uvm_error("SCB_MISMATCH", $sformatf("FAIL! Req:%b | Expected Code:%0d Valid:%b | Got Code:%0d Valid:%b",tr.req, exp_code, exp_valid, tr.code, tr.valid))
    end
  endfunction

  virtual function void report_phase(uvm_phase phase);
    `uvm_info("SCB_SUMMARY", $sformatf("Verification Complete: %0d Passed, %0d Failed",pass_count, fail_count), UVM_LOW)
  endfunction
  
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
