/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class alu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alu_scoreboard)
  alu_item tr;

  
  uvm_analysis_imp#(alu_item, alu_scoreboard) recv;

  // Simple counters for checking
  int pass_count = 0;
  int fail_count = 0;
  
  logic [3:0] exp_res;
  logic exp_carry, exp_zero, exp_neg, exp_ovfl;
  logic [4:0] tmp_full;
 

  function new(string name = "alu_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv",this);
  endfunction

  
  virtual function void write(alu_item tr);
    `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)
    
    if (tr.rst == 1 || $isunknown(tr.a)) begin
    `uvm_info("SCB", "Ignoring reset/unknown packet", UVM_HIGH)
    return; 
  end
    
    case(tr.op)
      
      ADD: begin
        tmp_full = tr.a +tr.b;
        exp_res = tmp_full[3:0];
        exp_carry = tmp_full[4];
        exp_ovfl = (tr.a[3] == tr.b[3])&&(exp_res[3]!= tr.a[3]);
      end
      
      SUB: begin
        tmp_full = tr.a - tr.b;
        exp_res = tmp_full[3:0];
        exp_carry = tmp_full[4];
        exp_ovfl = (tr.a[3] !=tr.b[3]) && (exp_res[3] != tr.a[3] );
      end
      
      AND: exp_res = tr.a & tr.b;
      OR:  exp_res = tr.a | tr.b;
      XOR: exp_res = tr.a ^ tr.b;
      NOT: exp_res = ~tr.a;
      SHL: exp_res = tr.a << 1;
      SHR: exp_res = tr.a >> 1;
      
      default exp_res = 0;
    endcase
    
    exp_zero = (exp_res == 4'b0);
    exp_neg = (exp_res[3]);
    
    if(tr.op > SUB ) begin
      exp_carry = 0;
      exp_ovfl = 0;
    end
    
    ////COMPARISION
    
    if((tr.res == exp_res)    &&
       (tr.carry == exp_carry)&&
       (tr.zero == exp_zero)  &&
       (tr.neg == exp_neg)    &&
       (tr.ovfl == exp_ovfl)) begin
      pass_count++;
      `uvm_info("SCB_PASS", $sformatf("Match! OP=%s A=%0d B=%0d | RES=%0d Flags=%b%b%b%b",tr.op.name(), tr.a, tr.b, tr.res, tr.carry, tr.zero, tr.neg, tr.ovfl), UVM_LOW)
      
    end 
    else 
      begin
      fail_count++;
      `uvm_error("SCB_FAIL", $sformatf("Mismatch! OP=%s A=%0d B=%0d | EXP_RES=%0d ACT_RES=%0d | EXP_Flags=%b%b%b%b ACT_Flags=%b%b%b%b", tr.op.name(), tr.a, tr.b, exp_res, tr.res, exp_carry, exp_zero, exp_neg, exp_ovfl, tr.carry, tr.zero, tr.neg, tr.ovfl))
    end
     
  endfunction

  virtual function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Tests Passed: %0d, Failed: %0d", pass_count, fail_count), UVM_LOW)
  endfunction
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */