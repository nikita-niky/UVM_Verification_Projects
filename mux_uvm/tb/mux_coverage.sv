class mux_coverage extends uvm_subscriber #(mux_transaction);
    `uvm_component_utils(mux_coverage)
    mux_transaction tr;
  
    covergroup mux_cg;
      option.per_instance=1;
 

    cp_sel: coverpoint tr.sel {
      bins all_inputs[] = {0, 1, 2, 3};
      illegal_bins out_of_range = {[4:$]};//safety check
    }

    cp_y: coverpoint tr.y {
      bins zero = {32'h0};
      bins max  = {32'hFFFF_FFFF};
      bins walking_1 = {32'h1, 32'h2, 32'h4, 32'h8, 32'h10, 32'h20, 32'h40, 32'h80};
      bins others = {[32'h1 : 32'hFFFF_FFFE]};
    }
    
    cp_d: coverpoint tr.d[tr.sel]{
      bins d_zero = {32'h0};
      bins d_max  = {32'hFFFF_FFFF};
      bins d_others = {[32'h0000_0001 : 32'hFFFF_FFFE]};
    }
    
    cp_sel_transitions: coverpoint tr.sel {
      bins transitions[] = (0,1,2,3 => 0, 1, 2, 3);
//       bins transitions_1[] = (1 => 0, 1, 2, 3);
//       bins transitions_2[] = (2 => 0, 1, 2, 3);
//       bins transitions_3[] = (3 => 0, 1, 2, 3);
	}
    
    cp_sel_states: coverpoint tr.sel {
      bins valid[] = {0, 1, 2, 3};
      bins unknown = {2'bx, 2'bz}; 
	}
   
      cp_y_toggles: coverpoint tr.y {
        bins all_zeros = {32'h0000_0000};
        bins all_ones  = {32'hFFFF_FFFF};
        bins alternating_1 = {32'h5555_5555}; // 0101...
        bins alternating_2 = {32'hAAAA_AAAA}; // 1010...
    }
      
    cross_sel_y: cross cp_sel, cp_y;
    cross_d_sel : cross cp_d, cp_sel;
    cross_sel_toggle: cross cp_sel, cp_y_toggles;
      
      
    endgroup
  
    function new(string name, uvm_component parent);
        super.new(name, parent);
        mux_cg = new();
    endfunction
  
  virtual function void write(mux_transaction t);
        this.tr = t;
        mux_cg.sample();
    endfunction
  
endclass