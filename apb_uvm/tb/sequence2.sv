/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class apb_memory_stress_seq extends apb_base_seq;
  `uvm_object_utils(apb_memory_stress_seq)

  
  function new(string name = "apb_memory_stress_seq");
    super.new(name);
  endfunction

  
  virtual task body();
    
    logic [31:0] test_data[16];
    `uvm_info(get_type_name(), "Starting FULL MEMORY STRESS TEST", UVM_LOW)
    
    for(int i=0 ;i<16;i++) begin
      test_data[i] = $urandom;
      do_write(i*4, test_data[i]);
    end
    
    for(int i = 0; i<16; i++) begin
      do_read(i*4);
    end   
    
   
  endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
