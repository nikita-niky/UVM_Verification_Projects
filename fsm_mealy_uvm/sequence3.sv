class fsm_reset_seq extends uvm_sequence#(fsm_item);
    `uvm_object_utils(fsm_reset_seq)

    fsm_item tr;

    function new(string name = "fsm_reset_seq");
        super.new(name);
    endfunction

    virtual task body();
      `uvm_info(get_type_name(), "Starting reset Stimulus for all ports...", UVM_LOW)
       tr = fsm_item::type_id::create("tr");
      
      
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.bit_in==1'b1;})
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.bit_in==1'b0;})
      `uvm_do_with(tr,{tr.rst_n==1'b0; tr.bit_in==1'b1;}) //rst 
      
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.bit_in==1'b1;})
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.bit_in==1'b0;})
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.bit_in==1'b1;})
      `uvm_do_with(tr,{tr.rst_n==1'b1; tr.bit_in==1'b1;})// seq
            
      `uvm_info(get_type_name(), "Sequence 3 body finished", UVM_LOW)
      
    endtask

endclass