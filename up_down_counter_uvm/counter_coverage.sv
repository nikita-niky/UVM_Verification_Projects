class counter_coverage extends uvm_subscriber#(counter_item);
    `uvm_component_utils(counter_coverage)
    counter_item tr;

    covergroup counter_cg;
        option.per_instance=1;
      
      cp_rst: coverpoint tr.rst{
        bins rst_[] = {0,1};
      }
      
      cp_load: coverpoint tr.load{
        bins load_[] = {0,1};
      }
      
      cp_up_down: coverpoint tr.up_down{
        bins up_down_[] = {0,1};
      }
      
      cp_count_in: coverpoint tr.count_in {
        bins count_in_[] = {[0:15]};
      }
      
      cp_count: coverpoint tr.count{
        bins count_[] = {[0:15]};
      }
      
      cp_max: coverpoint tr.max_tick{
        bins max_tick_[] = {0,1};
      }
      
      cp_min:coverpoint tr.min_tick{
        bins min_tick_[]= {0,1};
      }
      
      cross_rst_count : cross cp_rst, cp_count{
        illegal_bins rst_1_count_x = binsof(cp_rst) intersect {1} && binsof(cp_count) intersect {[1:15]};
      }
      
      cross_rst_during_load : cross cp_rst, cp_load{
        bins rst_during_load = binsof(cp_rst) intersect {1} && binsof(cp_load) intersect {1};
      }
      
      cross_max_15: cross cp_max, cp_count {
        bins max_hit = binsof(cp_max) intersect {1} && binsof(cp_count) intersect {15};
        illegal_bins max_wrong = binsof(cp_max) intersect {1} && binsof(cp_count) intersect {[0:14]};
        
        ignore_bins max_1_others = binsof(cp_max) intersect {0} && binsof(cp_count) intersect {[0:14]};
        
        illegal_bins max_0_wrong = binsof(cp_max) intersect {0} && binsof(cp_count) intersect {15};
      }
      
      cross_min_0: cross cp_min, cp_count{
        bins min_hit = binsof(cp_min) intersect {1} && binsof(cp_count) intersect {0};
        illegal_bins min_wrong_hit =binsof(cp_min) intersect {1} && binsof(cp_count) intersect {[1:15]}; 
        
        ignore_bins min_0_others = binsof(cp_min) intersect {0} && binsof(cp_count) intersect {[1:15]};
        
        illegal_bins min_0_wrong_hit =binsof(cp_min) intersect {0} && binsof(cp_count) intersect {0}; 
        
      }
      
      cp_up_down_toggle: coverpoint tr.up_down{
        bins up_to_down = (1 => 0);
        bins down_to_up = (0 => 1);
      }
      
           
      cp_wrap_around: coverpoint tr.count {
        bins up_wrap = (15 => 0);
        bins down_wrap = (0 => 15);
      }
        
    endgroup

    function new(string name,uvm_component parent);
        super.new(name,parent);
        counter_cg = new();
    endfunction

    virtual function void write(counter_item t);
        this.tr=t;
        counter_cg.sample();
    endfunction

endclass

