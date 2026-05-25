/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class arb_coverage extends uvm_subscriber#(arb_item);
    `uvm_component_utils(arb_coverage)
    arb_item tr;

  covergroup arb_cg;
    option.per_instance=1;

    cp_req:coverpoint tr.req{
      bins req_[] = {[0:15]};
    }

    cp_rst_n:coverpoint tr.rst_n {
      bins active = {0};
      bins inactive = {1};
    }

    cp_gnt: coverpoint tr.gnt {
      bins m0 = {4'b0001};
      bins m1 = {4'b0010};
      bins m2 = {4'b0100};
      bins m3 = {4'b1000};

    }

    cross_req_gnt: cross cp_req, cp_gnt;

    cross_rst_req: cross cp_rst_n, cp_req{
      bins rst_1_req_any = binsof(cp_req) && binsof(cp_rst_n) intersect {1};

      ignore_bins rst_0_req_any = binsof(cp_req) && binsof(cp_rst_n) intersect {0};

    }

  endgroup

    function new(string name,uvm_component parent);
        super.new(name,parent);
        arb_cg = new();
    endfunction

    virtual function void write(arb_item t);
        this.tr=t;
        arb_cg.sample();
    endfunction

endclass








  //two types we can write this type of coverage for tr.gnt 
//          bins gnt_[] = {[0:15]} with ($onehot(item) || item ==0);
//         bins gnt_[] = {0,1,2,4,8};
//         illegal_bins other = default; 


/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
