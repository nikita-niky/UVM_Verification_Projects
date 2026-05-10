class counter_directed_seq extends uvm_sequence#(counter_item);
  `uvm_object_utils(counter_directed_seq)

    counter_item tr;

  function new(string name = "counter_directed_seq");
        super.new(name);
    endfunction

    task body();
      `uvm_info(get_type_name(), "Starting directed test Stimulus for all ports...", UVM_LOW)
      
      `uvm_do_with(tr,{tr.load==1; tr.count_in==15; tr.up_down==1;})
      
      `uvm_do_with(tr,{tr.load==0; tr.count_in==4; tr.up_down==1;})
      
      `uvm_do_with(tr,{tr.load==1; tr.count_in==0; tr.up_down==0;})
      
      `uvm_do_with(tr,{tr.load==0; tr.count_in==1; tr.up_down==0;})
      
      ///Priority test
      `uvm_do_with(tr, {tr.load==0; tr.up_down==1;}) 
      
	  `uvm_do_with(tr, {tr.load==0; tr.up_down==1;}) 
      
      `uvm_do_with(tr, {tr.load==1; tr.count_in==7; tr.up_down==0;}) 
      
      
      //does reset override a LOAD command
      `uvm_do_with(tr, {tr.rst==1; tr.load==1; tr.count_in==10;}) 
      `uvm_do_with(tr, {tr.rst==0; tr.load==0;})
      
      //toggle stress test
      repeat(5) begin
        `uvm_do_with(tr, {tr.load==0; tr.up_down==1;}) // Up
        `uvm_do_with(tr, {tr.load==0; tr.up_down==0;}) // Down
      end
      
      
      //continous load
      repeat(3) begin
        `uvm_do_with(tr, {tr.load==1; tr.count_in==5;})
      end
      
    endtask

endclass