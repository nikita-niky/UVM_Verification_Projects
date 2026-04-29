`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)
  fifo_item tr;

 
  uvm_analysis_imp_wr #(fifo_item, fifo_scoreboard) wr_recv;
  uvm_analysis_imp_rd #(fifo_item, fifo_scoreboard) rd_recv;

  f_data exp_q[$];
  f_data exp_rdata;
  int count; // for internal data value check to make it easy to debug
 
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_recv = new("wr_recv",this);
    rd_recv = new("rd_recv",this);
  endfunction

  
  virtual function void write_wr(fifo_item tr);
    if(!tr.wrst_n) begin
      `uvm_info("SCB", "Reset detected, clearing WR queue", UVM_LOW)
      exp_q.delete();
      count=0;
      return;
    end
   
     
    if(tr.wrst_n &&tr.winc!==1'bx ) begin
      `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)

      if(tr.winc && !tr.wfull) begin
        exp_q.push_back(tr.wdata);
        count++;
        
        `uvm_info("SCB_WR",$sformatf("DATA WRITTEN=%0h , count=%0d",tr.wdata,count),UVM_LOW)
      end
      else if (tr.winc && tr.wfull ) begin
        `uvm_info("SCB_wr_ig", "Write ignored correctly: FIFO Full", UVM_LOW)

      end       
    end      
     

  endfunction
  
  virtual function void write_rd(fifo_item tr);
    
    if(!tr.rrst_n) begin
      `uvm_info("SCB", "Reset detected, clearing RD queue", UVM_LOW) 
      exp_q.delete();
      count=0;
      return;
    end

    if(tr.rrst_n && tr.rinc!==1'bx) begin
       `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)
      if(tr.rinc && !tr.rempty) begin
       if (exp_q.size()>0 ) begin
        exp_rdata = exp_q.pop_front();
          count--;
            `uvm_info("SCB_RD",$sformatf("DATA READ=%0h ,count=%0d",tr.rdata,count),UVM_LOW)      
          if(tr.rdata === exp_rdata)  //comparision
            `uvm_info("SCB_PASS",$sformatf("MATCH exp_rdata=%0h, ACT rdata=%0h",exp_rdata,tr.rdata),UVM_LOW)
            else 
              `uvm_error("SCB_FAIL",$sformatf("MISMATCH exp_rdata=%0h, ACT rdata=%0h",exp_rdata,tr.rdata)) 
              end
         else begin
          `uvm_warning("SCB_EMPTY_ERR", "RTL read data, but Scoreboard queue is empty!")
         end
        end
         if(tr.rinc && tr.rempty)begin
          `uvm_info("SCB_EMPTY_READ", "RTL attempted read but Scoreboard queue is empty!",UVM_LOW)
      end
    end          
  endfunction


  
endclass
      