/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class p_enc_coverage extends uvm_subscriber#(enc_item);
    `uvm_component_utils(p_enc_coverage)
    enc_item tr;

    covergroup p_enc_cg;
      option.per_instance=1;
      cp_req : coverpoint tr.req {
         bins bit_0 = {4'b0001};
         bins bit_1 = {4'b0010};
         bins bit_2 = {4'b0100};
         bins bit_3 = {4'b1000};
         bins all_ones = {4'b1111};
         bins all_zeros = {4'b0000};
         bins others = default;
      	}
      
      cp_code: coverpoint tr.code {
        bins code []= {0,1,2,3};
      }
      
      cp_valid : coverpoint tr.valid {
        bins high = {1};
        bins low = {0};
      }
      cp_toggle_req0:coverpoint tr.req[0] {
  		bins toggle_0 = (0 => 1), (1 => 0);
	}
	  cp_toggle_req1:coverpoint tr.req[1] {
  		bins toggle_1 = (0 => 1), (1 => 0);
	}
      cp_toggle_req2:coverpoint tr.req[2] {
 	 bins toggle_2 = (0 => 1), (1 => 0);
	}
      cp_toggle_req3:coverpoint tr.req[3] {
 	 bins toggle_3 = (0 => 1), (1 => 0);
	}
      
      cross_priority: cross cp_req, cp_code {
        
        ignore_bins bit0_code_123= binsof(cp_req.bit_0) && (binsof(cp_code.code) intersect {1,2,3});
        ignore_bins bit1_code_023= binsof(cp_req.bit_1) && (binsof(cp_code.code) intersect {0,2,3});
        ignore_bins bit2_code_013= binsof(cp_req.bit_2) && (binsof(cp_code.code) intersect {0,1,3});
        ignore_bins bit3_code_012= binsof(cp_req.bit_3) && (binsof(cp_code.code) intersect {0,1,2});
        ignore_bins all_ones_code_012= binsof(cp_req.all_ones) && (binsof(cp_code.code) intersect {0,1,2});
        ignore_bins all_zeros_code_123= binsof(cp_req.all_zeros) && (binsof(cp_code.code) intersect {1,2,3});
              
      }
      
      
    endgroup

    function new(string name,uvm_component parent);
        super.new(name,parent);
        p_enc_cg = new();
    endfunction

    virtual function void write(enc_item t);
        this.tr=t;
        p_enc_cg.sample();
    endfunction

endclass


/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
