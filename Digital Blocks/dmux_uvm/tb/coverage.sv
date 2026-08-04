/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class demux_coverage extends uvm_subscriber #(demux_item);
  `uvm_component_utils(demux_coverage)
  
  demux_item tr;
  
  covergroup demux_cg;
    option.per_instance=1;
    
    cp_sel: coverpoint tr.sel{
        bins all_inputs[] = {0, 1, 2, 3};
      illegal_bins out_of_range = {[4:$]};      
    }
    
    cp_sel_states: coverpoint tr.sel {
      bins valid[] = {0, 1, 2, 3};
      bins unknown = {2'bx, 2'bz}; 
	}
    
    cp_d: coverpoint tr.d {
       bins zero = {32'h0};
      bins max  = {32'hFFFF_FFFF};
      bins walking_1 = {32'h1, 32'h2, 32'h4, 32'h8, 32'h10, 32'h20, 32'h40, 32'h80};
     bins others = {[32'h1 : 32'hFFFF_FFFE]};
        
    }
    
    cp_y: coverpoint tr.y[tr.sel]{
      bins y_zero = {32'h0};
      bins y_max  = {32'hFFFF_FFFF};
      bins y_walking_1 = {32'h1, 32'h2, 32'h4, 32'h8, 32'h10, 32'h20, 32'h40, 32'h80};
      bins y_others = {[32'h0000_0001 : 32'hFFFF_FFFE]};
    }
    
     cp_sel_transitions: coverpoint tr.sel {
      bins transitions_0[] = (0 => 0, 1, 2, 3);
      bins transitions_1[] = (1 => 0, 1, 2, 3);
      bins transitions_2[] = (2 => 0, 1, 2, 3);
      bins transitions_3[] = (3 => 0, 1, 2, 3);
	}
    
    cp_y_toggles: coverpoint tr.y[tr.sel] {
        bins all_zeros = {32'h0000_0000};
        bins all_ones  = {32'hFFFF_FFFF};
        bins alternating_1 = {32'h5555_5555}; // 0101...
        bins alternating_2 = {32'hAAAA_AAAA}; // 1010...
    }
    
    
    cross_sel_d: cross cp_sel,cp_d;
    cross_sel_y: cross cp_sel, cp_y;
    cross_sel_toggle: cross cp_sel, cp_y_toggles;
    
  endgroup
  
   function new(string name, uvm_component parent);
        super.new(name, parent);
        demux_cg = new();
    endfunction
  
  virtual function void write(demux_item t);
        this.tr = t;
        demux_cg.sample();
    endfunction
  
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
