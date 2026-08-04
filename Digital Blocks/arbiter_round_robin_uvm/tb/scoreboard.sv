/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class arb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(arb_scoreboard)
  arb_item tr;

  
  uvm_analysis_imp#(arb_item, arb_scoreboard) recv;

  logic [3:0] exp_gnt;
  int next_top_priority;
  

  function new(string name = "arb_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv",this);
  endfunction

  
  virtual function void write(arb_item tr);
     
    logic [3:0] current_exp_gnt = 4'b0000;
    int master_idx ;
    
    // rst_n check
    if(!tr.rst_n) begin
      `uvm_info("SCB_RST", "System in Reset, checking for clear outputs", UVM_LOW)
      next_top_priority = 0;
      exp_gnt = 4'b0000;
     
      if (tr.gnt !== 4'b0000) begin
        `uvm_error("RST_FAIL", "GNT not zero during reset!")
        
      end
      return;
    end
    
    //initial 
    for(int i=0; i < 4;i++) begin
      master_idx = (next_top_priority + i) % 4;
      if(tr.req[master_idx]) begin
        current_exp_gnt[master_idx]=1'b1;
        break;
      end
    end
    
    //comparision
    if(tr.rst_n && exp_gnt!==4'bxxxx)begin
      `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)
      if(tr.gnt !== exp_gnt) 
        `uvm_error("SCB_FAIL",$sformatf("Mismatch Req=%4b, Exp:%4b, Act: %4b",tr.req,exp_gnt,tr.gnt))
      else 
        `uvm_info("SCB_PASS",$sformatf("Match Req=%4b ,Exp:%4b, Act: %4b",tr.req,exp_gnt,tr.gnt),UVM_LOW)
     end
          
     //updating the virtual pointer for the next cycle
        exp_gnt = current_exp_gnt;
      
      if(|current_exp_gnt) begin
        for(int j=0;j<4 ;j++) begin
          if(current_exp_gnt[j]) begin
            next_top_priority = (j + 1) % 4;
            break;
          end
        end
      end
    
    
    
  endfunction

  
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
