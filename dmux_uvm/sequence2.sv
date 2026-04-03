class demux_all_ones_seq extends uvm_sequence#(demux_item);
  demux_item tr;
  
  `uvm_object_utils(demux_all_ones_seq)
  
  function new (string name = "demux_all_ones_seq");
    super.new(name);
  endfunction
  
 task body();
    `uvm_info("SEQ", "Starting All-Ones Stimulus for all ports...", UVM_LOW)
   
   repeat(20) begin

        
        req = demux_item::type_id::create("req");
        
        start_item(req);
        
        
        if(!req.randomize() with { 
          sel dist {[0:3]:=25}; 
            d   == 32'hFFFF_FFFF; 
        }) begin
            `uvm_fatal("SEQ", "Randomization failed!")
        end
        
        finish_item(req);
    end

endtask
  
endclass

