/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class mux_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(mux_scoreboard)
  mux_transaction tr;
  logic [31:0] exp;
  
    
  uvm_analysis_imp#(mux_transaction,mux_scoreboard) recv;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
    recv=new("recv",this);
  endfunction
  
  
  
  virtual function void write(mux_transaction tr);
    
    exp= tr.d[tr.sel];
    
    if(exp===tr.y) begin
      
      `uvm_info("SCB", $sformatf("PASS: Sel %0d, exp= %0h, y=%0h", tr.sel,exp,tr.y), UVM_MEDIUM)
    end 
    
    else begin
      `uvm_error("SCB", $sformatf("MISMATCH! Sel:%0d Got:%0h Exp:%0h", tr.sel, tr.y, exp))
    end
    
  endfunction
  
endclass

        
      
    
    
      
    
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
