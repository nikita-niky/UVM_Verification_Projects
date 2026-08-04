/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fsm_master_seq extends uvm_sequence#(fsm_item);
   `uvm_object_utils(fsm_master_seq)

   function new(string name = "fsm_master_seq");
     super.new(name);
   endfunction

   fsm_random_sequence  s1;
   fsm_directed_seq     s2;
   fsm_reset_seq        s3;
   fsm_overlap_seq      s4;

   task body();
      s1 = fsm_random_sequence::type_id::create("s1");
      s2 = fsm_directed_seq::type_id::create("s2");
      s3 = fsm_reset_seq::type_id::create("s3");
      s4 = fsm_overlap_seq::type_id::create("s4");
      

     `uvm_info("MASTER_SEQ", "Starting Sequence 1...", UVM_LOW)
     s1.start(m_sequencer);
     
     #10;
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 2...", UVM_LOW)
     s2.start(m_sequencer);
     
     #10;
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 3...", UVM_LOW)
     s3.start(m_sequencer);
     
     #10;
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 4...", UVM_LOW)
     s4.start(m_sequencer);

            
   endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
