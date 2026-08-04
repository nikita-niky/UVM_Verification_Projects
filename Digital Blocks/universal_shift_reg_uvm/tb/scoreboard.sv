/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class univ_sr_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(univ_sr_scoreboard)
  sr_item tr;

  
  uvm_analysis_imp#(sr_item, univ_sr_scoreboard) recv;

 
  logic [3:0] exp_q_out; 

  function new(string name = "univ_sr_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv",this);
  endfunction

  
  virtual function void write(sr_item tr);
    

    if(!tr.rst && exp_q_out !== 4'bxxxx) begin
      `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)
      if(tr.q_out !== exp_q_out) begin
        `uvm_error("SCB_FAIL",$sformatf(" MISMATCH!! mode =%2b | EXP=%4b, ACT=%4b",tr.mode , exp_q_out, tr.q_out))
      end else begin
        `uvm_info("SCB_PASS",$sformatf("MATCH!!mode =%2b | EXP=%4b, ACT=%4b",tr.mode , exp_q_out, tr.q_out),UVM_LOW)
      end
    end
    
    
    ///GOLDEN MODEL
    
    if(tr.rst) begin
      exp_q_out = 4'b0000;
      `uvm_info("SCB_RST", "System in Reset - Forcing exp_q_out to 0", UVM_HIGH)
    end else begin
      case(tr.mode)
        2'b00   : exp_q_out = exp_q_out;
        2'b01   : exp_q_out = {tr.sin_left, exp_q_out[3:1]};
        2'b10   : exp_q_out = {exp_q_out[2:0],tr.sin_right};
        2'b11   : exp_q_out =tr.d_in;
        default : exp_q_out = exp_q_out;
      endcase
    end

  endfunction

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
