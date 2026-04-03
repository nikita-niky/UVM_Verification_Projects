class demux_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(demux_scoreboard)
  demux_item tr;
  
  uvm_analysis_imp #(demux_item, demux_scoreboard) recv;
  
  logic [31:0] exp [3:0];

    function new(string name, uvm_component parent);
      super.new(name, parent);
      recv = new("recv", this);
    endfunction

    virtual function void write(demux_item tr);
		
      foreach(exp[i]) 
        
          exp[i] = 32'h0; 
		  exp[tr.sel] = tr.d;
                  

	foreach(exp[i]) begin
       
      
    	if (tr.y[i] !== exp[i]) 
          `uvm_error("SCB_FAIL", $sformatf("Port %0d mismatch! d=%0h , y=%0h", i,exp[i],tr.y[i]))
      	else
          `uvm_info("SCB_PASS",$sformatf("sel=%0d, d=%0h, y=%0h",tr.sel,exp[i],tr.y[i]),UVM_LOW)
		end
    endfunction
  
endclass