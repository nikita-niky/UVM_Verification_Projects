class counter_item extends uvm_sequence_item;
  `uvm_object_utils(counter_item)
  rand logic rst;
  rand logic load ;
  rand logic up_down; // 1:up 0 : down
  rand logic [3:0] count_in;
  
  logic [3:0] count;
  logic max_tick;
  logic min_tick;
  
  
  constraint con_load {load dist {1:=15, 0:=85}; } 
  
  constraint con_count_in {count_in dist {0:=10 , 15:=10, [1:14]:=80}; }
  
  constraint con_rst {rst dist {0:=90, 1:=10};}
  
  function new(string name = "counter_item");
    super.new(name);
  endfunction

   

endclass