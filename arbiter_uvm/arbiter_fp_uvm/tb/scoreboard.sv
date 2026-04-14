class arbiter_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(arbiter_scoreboard)
  arbiter_item tr;


  uvm_analysis_imp#(arbiter_item, arbiter_scoreboard) recv;
  
  
  logic [3:0] exp_gnt;
  
  function new(string name = "arbiter_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv",this);
  endfunction

  
  virtual function void write(arbiter_item tr);
    `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)
    
    ref_model(tr);/// golden model
    
  endfunction
  
  virtual function void ref_model(arbiter_item tr);
    
    if(!tr.rst_n) begin
      exp_gnt = 4'b0000;
      `uvm_info("SCB_RST", "System in Reset - Forcing exp_gnt to 0", UVM_HIGH)
    end
    else begin

      if(tr.req[0]) exp_gnt = 4'b0001;
      else if(tr.req[1]) exp_gnt = 4'b0010;
      else if(tr.req[2]) exp_gnt = 4'b0100;
      else if(tr.req[3]) exp_gnt = 4'b1000;
      else 				 exp_gnt = 4'b0000;

    end
       
    if(tr.rst_n && exp_gnt !==4'bxxxx) begin
      `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)
      if(tr.gnt !== exp_gnt) begin
        `uvm_error("SCB_FAIL",$sformatf("REQ =%4b Exp GNT =%4b | Got=%4b",tr.req,exp_gnt,tr.gnt))
      end
      else begin
        `uvm_info("SCB_PASS",$sformatf("REQ =%4b | Exp GNT =%4b | Got =%4b ",tr.req,exp_gnt,tr.gnt),UVM_LOW)
      end
    end
    else begin
      `uvm_info("SCB","RESET ACTIVE",UVM_LOW)
    end
    
  endfunction

endclass