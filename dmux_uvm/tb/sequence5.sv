class demux_pattern_seq extends uvm_sequence #(demux_item);
  `uvm_object_utils(demux_pattern_seq)
  demux_item tr;
  
  function new(string name = "demux_pattern_seq");
    super.new(name);
  endfunction

  task body();
    // 1. Correct array declaration
    logic [31:0] patterns [] = '{
                                 32'h5555_5555, 32'hAAAA_AAAA,
                                 32'h1, 32'h2, 32'h4, 32'h8, 
                                 32'h10, 32'h20, 32'h40, 32'h80};
        
    `uvm_info("SEQ", "Starting Pattern Sequence for Toggle Coverage", UVM_LOW)
        
    foreach (patterns[p]) begin
      repeat(50) begin

        tr = demux_item::type_id::create("tr");
        start_item(tr);
              
        // 2. Simplified constraints
        if (!tr.randomize() with { 
          sel dist {[0:3]:=25};           // Force the current port
          d   == patterns[p]; // Force the current toggle pattern
        }) begin
          `uvm_error("SEQ", "Randomization Failed!")
        end
        
        finish_item(tr);
//       end
      end
    end
  endtask
endclass