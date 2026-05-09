class mux_select_unknown extends uvm_sequence #(mux_transaction);
  mux_transaction tr;
  
  `uvm_object_utils(mux_select_unknown)
  
  function new(string name = "mux_select_unknown");
      super.new(name);
    endfunction
    
    task body();
      `uvm_info("SEQ", "Starting Select-Unknown Stimulus...", UVM_LOW)
      
      
      
      repeat(5) begin
    	tr= mux_transaction::type_id::create("tr");
      	start_item(tr);
      	if (tr.randomize()) begin
        	tr.sel = 2'bx; 
        	finish_item(tr);
        end 
        else
          begin 
            `uvm_error("[SEQ4]","Randomization failed !!!")
    	  end
      end
        
            
            
        
    endtask
endclass