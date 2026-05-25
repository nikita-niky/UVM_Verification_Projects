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
      
      cp_wrst_n:coverpoint tr.wrst_n{
        bins rst_active = {0};
        bins rst_inactive = {1};
      }
      
      cp_rrst_n:coverpoint tr.rrst_n{
        bins rst_active = {0};
        bins rst_inactive = {1};
      }
      
      cp_winc:coverpoint tr.winc{
        bins w_active = {1};
        bins w_inactive = {0};
      }
      
      cp_rinc:coverpoint tr.rinc{
        bins r_active = {1};
        bins r_inactive = {0};
      }
      
      cp_full:coverpoint tr.wfull{
        bins is_full = {1};
        bins not_full = {0};
        
      }
      
      cp_empty:coverpoint tr.rempty{
        bins is_empty = {1};
        bins not_empty = {0};
      }
      
      cp_wdata:coverpoint tr.wdata {
        bins zeros       = { 'h00 };   
        bins ones        = { 'hFF };  
        bins alt_5       = { 'h55 };             
        bins alt_A       = { 'hAA };            
        bins walking_1   = { 1, 2, 4, 8, 16, 32, 64, 128 };
        bins others      = default;              
      }
      
      cp_rdata:coverpoint tr.rdata {
        bins zeros       = { 'h00 };   
        bins ones        = { 'hFF };  
        bins alt_5       = { 'h55 };             
        bins alt_A       = { 'hAA };            
        bins walking_1   = { 1, 2, 4, 8, 16, 32, 64, 128 };
        bins others      = default;
      }
      
      rst_x_full: cross cp_wrst_n, cp_full {
        illegal_bins rst_with_full_1 = binsof(cp_wrst_n.rst_active) && binsof(cp_full.is_full);
                bins when_rst_not_active = !binsof(cp_wrst_n.rst_active);
      }
      
      rd_empty: cross cp_empty, cp_rrst_n {
        illegal_bins rst_with_not_empty = binsof(cp_rrst_n.rst_active) && binsof(cp_empty.not_empty);
        bins when_rst_not_active = !binsof(cp_rrst_n.rst_active);
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
