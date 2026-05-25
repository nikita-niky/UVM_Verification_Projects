/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class arbiter_coverage extends uvm_subscriber#(arbiter_item);
    `uvm_component_utils(arbiter_coverage)
    arbiter_item tr;

    covergroup arbiter_cg;
        option.per_instance=1;
      
      cp_req:coverpoint tr.req{
        bins req_[] = {[0:15]};
      }
      
      cp_rst_n:coverpoint tr.rst_n {
        bins active = {0};
        bins inactive = {1};
      }
      
      cp_gnt: coverpoint tr.gnt {
        //two types we can write this type of coverage
//         bins gnt_[] = {0,1,2,4,8};
//         illegal_bins other = default; 
        bins gnt_[] = {[0:15]} with ($onehot(item) || item ==0);
      }
      
      cross_rst_req: cross cp_rst_n, cp_req{
        bins rst_1_req_any = binsof(cp_req) && binsof(cp_rst_n) intersect {1};
        
        ignore_bins rst_0_req_any = binsof(cp_req) && binsof(cp_rst_n) intersect {0};
        
      }
      

       

    endgroup

    function new(string name,uvm_component parent);
        super.new(name,parent);
        arbiter_cg = new();
    endfunction

    virtual function void write(arbiter_item t);
        this.tr=t;
        arbiter_cg.sample();
    endfunction

endclass


/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
