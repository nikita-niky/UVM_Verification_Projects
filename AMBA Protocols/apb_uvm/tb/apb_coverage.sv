/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */
class apb_coverage extends uvm_subscriber#(apb_item);
    `uvm_component_utils(apb_coverage)
    apb_item tr;

    covergroup apb_cg;
        option.per_instance=1;
      
      cp_addr: coverpoint tr.addr{
        bins low_range = {[0:15]};
        bins mid_range = {[16:31]};
        bins high_range = {[32:63]};
        bins illegal = {[64:$]};
      }
      
      cp_wr_en: coverpoint tr.write_en{
        bins wr = {1};
        bins rd = {0};
      }
      
      cp_slverr:coverpoint tr.pslverr{
        bins err_detected = {1};
        bins no_err = {0};
      }
      
      cp_rst: coverpoint tr.preset_n{
        bins rst_active   = {0};
        bins rst_inactive = {1};
      }
      
      cross_addr_wr:cross cp_addr, cp_wr_en{
        ignore_bins illegal_wr = binsof(cp_addr.illegal) && binsof(cp_wr_en.wr);
      }
      
    endgroup

    function new(string name,uvm_component parent);
        super.new(name,parent);
        apb_cg = new();
    endfunction

    virtual function void write(apb_item t);
        this.tr=t;
        apb_cg.sample();
    endfunction

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */

