class fifo_random_seq extends uvm_sequence#(fifo_item);
    `uvm_object_utils(fifo_random_seq)

    fifo_item tr;

    function new(string name = "fifo_random_seq");
        super.new(name);
    endfunction

    task body();
      `uvm_info(get_type_name(), "Starting Random Stimulus for all ports...", UVM_LOW)
      
      repeat(50) begin
        tr = fifo_item::type_id::create("tr");
        start_item(tr);
        if(!tr.randomize() with {rst_n dist {1:=90, 0:=10};})
          `uvm_error("SEQ_2","Randomization failed")
          finish_item(tr);
         
         end
    endtask

endclass