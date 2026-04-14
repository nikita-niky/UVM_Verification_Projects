class dec_coverage extends uvm_subscriber#(dec_item);
    `uvm_component_utils(dec_coverage)
    dec_item tr;

    covergroup dec_cg;
        option.per_instance=1;
      
      cp_sel: coverpoint tr.sel{
        bins input_value[]= {0,1,2,3};
      }
      
      cp_sel_toggle : coverpoint tr.sel iff(tr.en == 1){
        bins transition_0[] = (0 => 0,1,2,3);
        bins transition_1[] = (1 => 0,1,2,3);
        bins transition_2[] = (2 => 0,1,2,3);
        bins transition_3[] = (3 => 0,1,2,3);
      }
      
      cp_en: coverpoint tr.en{
        bins en_off= {0};
        bins en_on = {1};
      }
      
      cp_y:coverpoint tr.y iff (!$isunknown(tr.sel)){
        bins idle = {4'b0000};
        bins output_y[] = {4'b0001,4'b0010,4'b0100,4'b1000};
        illegal_bins multi_bit = default;
      }
      
      cross_sel_en: cross cp_sel , cp_en;

      
      
    endgroup

    function new(string name,uvm_component parent);
        super.new(name,parent);
        dec_cg = new();
    endfunction

    virtual function void write(dec_item t);
        this.tr=t;
        dec_cg.sample();
    endfunction

endclass

