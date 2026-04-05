class univ_sr_full_random_seq extends uvm_sequence#(sr_item);
  `uvm_object_utils(univ_sr_full_random_seq)

    sr_item tr;

  function new(string name = "univ_sr_full_random_seq");
        super.new(name);
    endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence 4 body", UVM_LOW) 


    `uvm_info("SEQ_RAND", "Starting Random Stress Test", UVM_LOW)
    repeat(100) begin
      tr = sr_item::type_id::create("tr");
      start_item(tr);
      if(!tr.randomize() with {tr.mode inside {[0:3]};
                               tr.sin_left dist {0:=50, 1:=50};
                               tr.sin_right dist {0:=50, 1:=50};
                               tr.d_in inside {[0:15]};
                               tr.rst dist {0:=90, 1:=10};
                              }) begin
        `uvm_error("SEQ_4","Randomization failed!")
      end
      finish_item(tr);        

    end

    `uvm_info(get_type_name(), "Sequence 4 body finished", UVM_LOW)    
  endtask

  
endclass