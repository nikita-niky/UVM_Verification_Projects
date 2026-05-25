// ==========================================================================
// Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
// Copyright:   (c) 2026 Nikita Agrawal
// License:     MIT License (see LICENSE file in root)
// ==========================================================================

class alu_coverage extends uvm_subscriber#(alu_item);
    `uvm_component_utils(alu_coverage)
    alu_item tr;

    covergroup alu_cg;
        option.per_instance=1;
      
      cp_rst: coverpoint tr.rst {
        bins active = {1};
        bins inactive = {0};
        bins deassertion = (1=>0);
      }
      
      cp_a:coverpoint tr.a{
        bins a_low = {0};
        bins a_high= {15};
        bins a_other= {[1:14]};
      }
      
      cp_b:coverpoint tr.b {
        bins b_low = {0};
        bins b_high= {15};
        bins b_other = {[1:14]};
      }
      
      cp_res: coverpoint tr.res{
        bins res_values[]={[0:15]};
      }
      
      cp_op:coverpoint tr.op {
        bins op_values[] = {[ADD:SHR]};
        bins math_to_logic = (ADD,SUB => AND,OR,XOR,NOT,SHL,SHR);
      }
            
      cp_carry: coverpoint tr.carry {bins carry_[] = {0,1};}
      
      cp_zero:  coverpoint tr.zero{bins zero_[] = {0,1};}
      
      cp_neg:   coverpoint tr.neg {bins neg_[]={0,1};}
      
      cp_ovfl:  coverpoint tr.ovfl {bins ovfl_[]={0,1};}
      
      cross_math_ovfl: cross cp_op, cp_ovfl {
        ignore_bins logic_ops = binsof(cp_op) intersect {AND,OR,XOR,NOT,SHL,SHR};
      }
      
      cross_sub_neg: cross cp_op, cp_neg {
        bins sub_negative = binsof(cp_op) intersect {SUB} && binsof(cp_neg) intersect {1};
        ignore_bins shr_neg = binsof(cp_op) intersect {SHR} && binsof(cp_neg) intersect {1};
      }
      
      cross_add_carry: cross cp_op,cp_carry {
        
        bins add_carry = binsof(cp_op) intersect {ADD} && binsof(cp_carry) intersect {1};
        
        ignore_bins logic_carry_one = binsof(cp_op) intersect {AND,OR,XOR,NOT,SHL,SHR} && binsof(cp_carry) intersect {1};
      }
      

    endgroup

    function new(string name,uvm_component parent);
        super.new(name,parent);
        alu_cg = new();
    endfunction

    virtual function void write(alu_item t);
        this.tr=t;
        alu_cg.sample();
    endfunction

endclass

// ==========================================================================
// Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
// Copyright:   (c) 2026 Nikita Agrawal
// License:     MIT License (see LICENSE file in root)
// ==========================================================================