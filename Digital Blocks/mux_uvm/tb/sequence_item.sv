/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

// a transaction class

class mux_transaction extends uvm_sequence_item;
  rand logic[31:0] d[3:0];
  rand logic [1:0] sel;
  logic [31:0] y;
  logic clk;
  
  `uvm_object_utils(mux_transaction)
      
  
  function new(string name = "mux_transaction");
    super.new(name);
  endfunction
  
  constraint con_sel {sel dist {[0:3]:=25};}
  
  constraint con_data {d[sel] inside {[32'h0 :32'hFFFF_FFFF ]};}
  
  constraint con_interesting_data {
        foreach (d[i]) {
            d[i] dist {
                32'h0000_0000 := 10,
                32'hFFFF_FFFF := 10,
                [32'h0000_0001 : 32'hFFFF_FFFE] := 80
            };
        }
    }
  
  
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
