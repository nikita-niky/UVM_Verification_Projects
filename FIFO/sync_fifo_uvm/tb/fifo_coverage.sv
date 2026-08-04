/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_coverage extends uvm_subscriber#(fifo_item);
    `uvm_component_utils(fifo_coverage)
    fifo_item tr;

    covergroup fifo_cg;
        option.per_instance=1;
       
      cp_rst_n:coverpoint tr.rst_n {
        bins active   = {0};
        bins inactive = {1};
      }
      
      cp_wr_en:coverpoint tr.wr_en {
        bins wr_high = {1};
        bins wr_low  = {0};        
      }
      
      cp_rd_en:coverpoint tr.rd_en {
        bins rd_high = {1};
        bins rd_low  = {0};  
      }
      
      cp_full: coverpoint tr.full {
      	bins f_high = {1};
        bins f_low  = {0}; 
      }
      
      cp_empty: coverpoint tr.empty {
      	bins e_high = {1};
        bins e_low  = {0}; 
      }
      
      cp_wdata: coverpoint tr.wdata {
        bins zeros = {8'h00};
        bins ones = {8'hFF};
        bins low_range = {[8'h01:8'h3F]};
        bins mid_range = {[8'h40: 8'hBF]};
        bins hi_range = {[8'hC0:8'hFE]};
      }
      cp_rdata: coverpoint tr.rdata {
        bins zeros = {8'h00};
        bins ones = {8'hFF};
        bins low_range = {[8'h01:8'h3F]};
        bins mid_range = {[8'h40: 8'hBF]};
        bins hi_range = {[8'hC0:8'hFE]};
      }
      
      cross_rdata_en : cross cp_rdata, cp_rd_en {
        ignore_bins en_0_rdata_any = binsof(cp_rd_en.rd_low);
      }
      
      cross_write_when_full: cross cp_full, cp_wr_en {
        bins write_when_full = binsof(cp_full.f_high) && binsof(cp_wr_en.wr_high);
      }
      
      cross_empty_rd: cross cp_empty,cp_rd_en {
        bins read_when_empty = binsof(cp_empty.e_high) && binsof(cp_rd_en.rd_high);
      }
      
      cross_wdata_en: cross cp_wdata, cp_wr_en {
        ignore_bins wr_low = binsof(cp_wr_en.wr_low); 
      }
      
      cp_fifo_depth_transitions: coverpoint tr.full {
        bins empty_to_full = (0 => 1);
        bins full_to_empty = (1 => 0);
      }
      
      
      cross_simultaneous: cross cp_wr_en, cp_rd_en {
        bins read_write_together = binsof(cp_wr_en.wr_high) && binsof(cp_rd_en.rd_high);
        ignore_bins just_read = binsof(cp_rd_en.rd_low);
        ignore_bins just_write = binsof(cp_wr_en.wr_low);
      }
      
      cross_reset_state: cross cp_rst_n, cp_full {
        illegal_bins reset_while_full = binsof(cp_rst_n.active) && binsof(cp_full.f_high);
      }
      
    endgroup

    function new(string name,uvm_component parent);
        super.new(name,parent);
        fifo_cg = new();
    endfunction

    virtual function void write(fifo_item t);
        this.tr=t;
        fifo_cg.sample();
    endfunction

endclass


/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
