class mux_pattern_seq extends uvm_sequence #(mux_transaction);
    `uvm_object_utils(mux_pattern_seq)
  mux_transaction tr;
    function new(string name = "mux_pattern_seq");
      super.new(name);
    endfunction

    task body();
      logic [31:0] patterns[] = '{32'h0000_0000, 32'hFFFF_FFFF, 32'h5555_5555, 32'hAAAA_AAAA,32'h1, 32'h2, 32'h4, 32'h8, 32'h10, 32'h20, 32'h40, 32'h80};
        
        `uvm_info("SEQ", "Starting Pattern Sequence for Toggle Coverage", UVM_LOW)
        
        foreach (patterns[p]) begin
            for (int i = 0; i < 4; i++) begin
              tr = mux_transaction::type_id::create("tr");
              start_item(tr);
                // Force the select line and the specific data pattern
              if (!tr.randomize() with { 
                    tr.sel == i; 
                d[i] == patterns[p];
                
               foreach (d[j])
                 if (j != i) 
                   d[j] != patterns[p];
                 
                }) `uvm_error("SEQ", "Rand Fail")
                finish_item(tr);
            end
        end
    endtask
endclass