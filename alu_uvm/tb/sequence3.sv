/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class alu_stress_seq extends uvm_sequence#(alu_item);
  `uvm_object_utils(alu_stress_seq)

    alu_item tr;

  function new(string name = "alu_stress_seq");
        super.new(name);
    endfunction

    task body();
      `uvm_info(get_type_name(), "Starting stress seq  Stimulus for all ports...", UVM_LOW)
      
      repeat(50) begin //500 can be used if not covering all values
     
      tr = alu_item::type_id::create("tr");
      start_item(tr); 

        if(!tr.randomize() with {a inside {[0:15]};
                                 b inside {[0:15]};
                                 op inside {[ADD:SHR]};
                                })
          begin
        `uvm_error(get_type_name(), "Randomization failed!")
      end

      finish_item(tr);
    end

    `uvm_info(get_type_name(), "Sequence body finished", UVM_LOW)
         
    endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
