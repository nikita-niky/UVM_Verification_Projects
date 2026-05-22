class axi_random_stress_seq extends uvm_sequence #(axi_item);
  `uvm_object_utils(axi_random_stress_seq)

  function new(string name = "axi_random_stress_seq");
    super.new(name);
  endfunction

  int num_transactions = 500;

  virtual task body();
    axi_item write_history[$];

    for (int t = 0; t < num_transactions; t++) begin
      axi_item write_tr = axi_item::type_id::create("write_tr");

      start_item(write_tr);


      if (!write_tr.randomize() with {
        op == WRITE;
        size inside {0,1,2}; // Test narrow 1-byte transfers safely
        burst inside {[0:2]}; // INCR
        len inside {[0:15]};
        addr inside {[16'h1000 : 16'h3FFF]};
      }) begin
        `uvm_fatal("RAND_FAIL", "Randomization failed!")
      end
      `uvm_info("SEQ_RAND", $sformatf("[TX %0d/%0d] Blasting Random WRITE -> ID:%0d, Addr:%0h, Len:%0d", t+1, num_transactions, write_tr.id, write_tr.addr, write_tr.len), UVM_MEDIUM)

      finish_item(write_tr);
      write_history.push_back(write_tr);
    end

    // Matching Readback Loop
    while (write_history.size() > 0) begin
      axi_item w_match = write_history.pop_front();
      axi_item read_tr = axi_item::type_id::create("read_tr");

      start_item(read_tr);
      read_tr.op    = READ;
      read_tr.id    = w_match.id;
      read_tr.addr  = w_match.addr;
      read_tr.len   = w_match.len;
      read_tr.size  = w_match.size;
      read_tr.burst = w_match.burst;

      finish_item(read_tr);
    end
  endtask
endclass
