class demux_base_seq extends uvm_sequence#(demux_item);
  demux_item tr;
  
  `uvm_object_utils(demux_base_seq)
  
  function new (string name = "demux_base_seq");
    super.new(name);
  endfunction
  
  task body();
    repeat(50) begin // repeat value se double output values
      tr= demux_item::type_id::create("tr");
      start_item(tr);
      if(tr.randomize())
        finish_item(tr);
        
      else
        `uvm_error("[SEQ]","Randomization failed !!!")
    end
  endtask
  
endclass