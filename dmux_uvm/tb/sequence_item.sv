class demux_item extends uvm_sequence_item;
  rand logic [31:0] d;
  rand logic [1:0] sel;
  logic [31:0] y [0:3];
  
  
  `uvm_object_utils(demux_item)

  
  function new(string name="demux_item");
    super.new(name);
  endfunction
  
  constraint con_sel {sel dist {[0:3]:=25};}
  
  constraint con_d {d inside {[32'h0:32'hFFFF_FFFF]};}
  
endclass
  
  