/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fsm_coverage extends uvm_subscriber#(fsm_item);
    `uvm_component_utils(fsm_coverage)
    fsm_item tr;

    covergroup fsm_cg;
        option.per_instance=1;
      
      cp_rst_n:coverpoint tr.rst_n{
        bins inactive = {1};
        bins active   = {0};
      }
      
      cp_bit_in:coverpoint tr.bit_in {
        bins logic_0 = {0};
        bins logic_1 = {1};
      }
      
      cp_pf:coverpoint tr.pattern_found{
        bins high = {1};
        bins low  = {0};
      }
      
      cp_toggle:coverpoint tr.bit_in {
        bins seq_1011 = (1 => 0 => 1 =>1);
        bins cons_hits_1 = (1=>1=>1);
      }
      
      cp_state:coverpoint tr.current_state{
        bins idle  = {IDLE};
        bins S1    = {S1};
        bins S10   = {S10};
        bins S101  = {S101};
        bins S1011 = {S1011};  
        ignore_bins x_bit = {3'bxxx,3'bzzz};
      }
      
      cp_state_transition:coverpoint tr.current_state{
        bins idle_to_s1    =(IDLE => S1);
        bins s1011_to_idle = (S1011 => IDLE);
        bins s1011_to_s1   = (S1011 => S1);
        
        bins idle_stay  = (IDLE => IDLE);
        bins s1_stay    = (S1 => S1);
        bins s1_to_idle = (S1 => IDLE); /// due to rst it will trigger
        bins s1_to_s10 = (S1 => S10);
        bins s10_to_s101 = (S10 => S101);
        bins s101_to_s1011 = (S101 => S1011);
                
        illegal_bins idle_to_any_[]  = (IDLE =>S10,S101,S1011);
        illegal_bins s1_to_any_[]    = (S1 => S101,S1011);
        illegal_bins s10_to_any_[]   = (S10 => S1,S1011);
        illegal_bins S101_to_any_[]  = (S101 => S1,IDLE);
        illegal_bins s1011_to_any_[] = (S1011 => S10,S101);
      }
      
      cross_state_rst:cross cp_rst_n, cp_state {
        ignore_bins rst_active = binsof(cp_rst_n.active);
      }
      
      cross_state_bit:cross cp_state, cp_bit_in;   

    endgroup

    function new(string name,uvm_component parent);
        super.new(name,parent);
        fsm_cg = new();
    endfunction

    virtual function void write(fsm_item t);
        this.tr=t;
        fsm_cg.sample();
    endfunction

endclass


/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
