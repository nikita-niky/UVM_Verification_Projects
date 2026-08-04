/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class univ_sr_coverage extends uvm_subscriber#(sr_item);
    `uvm_component_utils(univ_sr_coverage)
    sr_item tr;

  covergroup univ_sr_cg;
    option.per_instance=1;

    cp_mode: coverpoint tr.mode{
      bins idle     = {2'b00};
      bins sr       = {2'b01};
      bins sl       = {2'b10};
      bins parallel = {2'b11};
    }

    cp_rst:coverpoint tr.rst {
      bins low  = {0};
      bins high = {1};
    }

    cp_d_in: coverpoint tr.d_in {
      bins all_zero = {4'b0000};
      bins all_ones = {4'b1111};
      bins others[] = {[1:14]};
    }

    cp_q_out:coverpoint tr.q_out {
      bins all_zero = {4'b0000};
      bins all_ones = {4'b1111};
      bins others[] = {[4'b0001:4'b1110]};
    }

    ///walking ones
    cp_toggle_qout:coverpoint tr.q_out{
      wildcard bins bit0_1 = {4'b???1};
      wildcard bins bit1_1 = {4'b??1?};
      wildcard bins bit2_1 = {4'b?1??};
      wildcard bins bit3_1 = {4'b1???};
    }

    cp_mode_toggle:coverpoint tr.mode{
      bins r_to_l     = (2'b01 => 2'b10); 
      bins l_to_r     = (2'b10 => 2'b01);
      bins load_to_sh = (2'b11 => 2'b01), (2'b11 => 2'b10);
      bins any_to_rst = (2'b00, 2'b01, 2'b10, 2'b11 => 2'b00);
    }

    cross_mode_rst: cross cp_mode, cp_rst;


  endgroup

  function new(string name,uvm_component parent);
    super.new(name,parent);
    univ_sr_cg = new();
  endfunction

  virtual function void write(sr_item t);
    this.tr=t;
    univ_sr_cg.sample();
  endfunction

endclass


/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
