class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)
  fifo_item tr;

  
  uvm_analysis_imp#(fifo_item, fifo_scoreboard) recv;
  
  fifo_data exp_q[$];
  fifo_data exp_rdata;
  int exp_count;
  fifo_data prev_rd[$];
  

  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv",this);
  endfunction


  virtual function void write(fifo_item tr);
    
//     ///checking flags
    if(tr.rst_n) begin

        if ((exp_count == 0) && tr.empty!==1'b1) 
          `uvm_error("E_FLAG_ERR","the count value reached 0 but empty flag still not asserted")
          end
    
      ///READ LOGIC
          if(tr.rst_n && tr.rd_en!==1'bx) begin
            `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)
            if (tr.rd_en) begin

              if(tr.rst_n && !tr.empty && prev_rd.size()>0 && (exp_count >0)) begin
                exp_rdata = prev_rd.pop_front();
                exp_count --;
                `uvm_info("SCB_RD",$sformatf("DATA READ=%0h ,count = %0d",tr.rdata, exp_count),UVM_LOW)

                if(tr.rdata === exp_rdata)  //comparision
                  `uvm_info("SCB_PASS",$sformatf("MATCH exp_rdata=%0h, ACT rdata=%0h",exp_rdata,tr.rdata),UVM_LOW)
                  else 
                    `uvm_error("SCB_FAIL",$sformatf("MISMATCH exp_rdata=%0h, ACT rdata=%0h",exp_rdata,tr.rdata))
                    end
                    
                    ///updating the valuse in next cycle
                    if(exp_q.size()>0) 
                      prev_rd.push_back(exp_q.pop_front());


                else begin
                  `uvm_info("SCB_EMPTY_READ", "RTL attempted read but Scoreboard queue is empty!",UVM_HIGH)
                end
              end

            end

  
      ///WRITE LOGIC
            if(tr.rst_n && tr.wr_en!==1'bx) begin
              `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)
              if(tr.wr_en && !tr.full && (exp_count < DEPTH) ) begin
                exp_q.push_back(tr.wdata);
                exp_count ++;
                `uvm_info("SCB_WR",$sformatf("DATA WRITTEN=%0h ,count = %0d",tr.wdata, exp_count),UVM_LOW)
              end
              else if (tr.wr_en && tr.full) begin
                `uvm_info("SCB_wr_ig", "Write ignored correctly: FIFO Full", UVM_LOW)
                if(exp_count !== DEPTH) ///FULL flag check
                  `uvm_error("F_FLAG_ERR","count reached max value but full flag is not asserted")                  
              end              
            end         
            
      //RESET logic
            if(!tr.rst_n) begin
              `uvm_info("SCB_RST", "System in Reset, checking for clear outputs", UVM_LOW)
              exp_q.delete();
              prev_rd.delete();
              exp_count = 0;

              return;
            end
            
  endfunction

       
endclass
