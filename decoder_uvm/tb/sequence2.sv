/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class dec_en_zero_seq extends uvm_sequence#(dec_item);
    `uvm_object_utils(dec_en_zero_seq)

    dec_item tr;

    function new(string name = "dec_en_zero_seq");
        super.new(name);
    endfunction

    task body();
        `uvm_info(get_type_name(), "Starting en_zero Stimulus for all ports...", UVM_LOW)

      repeat(5) begin
         tr=dec_item::type_id::create("tr");
         start_item(tr);
        if(!tr.randomize() with {en == 0;}) 
            begin
             `uvm_fatal(get_type_name(), "Randomization failed!")
            end

            finish_item(tr);
         end
    endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
