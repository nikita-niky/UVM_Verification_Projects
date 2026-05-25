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

class alu_master_seq extends uvm_sequence#(alu_item);
   `uvm_object_utils(alu_master_seq)

   function new(string name = "alu_master_seq");
     super.new(name);
   endfunction

   alu_base_sequence  s1;
   alu_directed_seq   s2;
   alu_stress_seq     s3;
 

   task body();
      s1 = alu_base_sequence::type_id::create("s1");
      s2 = alu_directed_seq::type_id::create("s2"); 
      s3 = alu_stress_seq::type_id::create("s3");
  

     // m_sequencer is the sequencer this master is running on
     `uvm_info("MASTER_SEQ", "Starting Sequence 1...", UVM_LOW)
            s1.start(m_sequencer);

     `uvm_info("MASTER_SEQ", "Starting Sequence 2...", UVM_LOW)
            s2.start(m_sequencer);
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 3...", UVM_LOW)
            s3.start(m_sequencer);

   endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
