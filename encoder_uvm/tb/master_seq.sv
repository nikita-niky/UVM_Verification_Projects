/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class p_enc_master_seq extends uvm_sequence#(enc_item);
   `uvm_object_utils(p_enc_master_seq)

   function new(string name = "p_enc_master_seq");
     super.new(name);
   endfunction

   p_enc_base_sequence  s1;
   p_enc_conflict_seq   s2;
   p_enc_all_zeros_seq  s3;
   p_enc_random_seq     s4;

   task body();
      s1 = p_enc_base_sequence::type_id::create("s1");
      s2 = p_enc_conflict_seq::type_id::create("s2");
      s3 = p_enc_all_zeros_seq::type_id::create("s3");
      s4 = p_enc_random_seq::type_id::create("s4");

     // m_sequencer is the sequencer this master is running on
     `uvm_info("MASTER_SEQ", "Starting Sequence 1...", UVM_LOW)
            s1.start(m_sequencer);
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 2...", UVM_LOW)
            s2.start(m_sequencer);
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 3...", UVM_LOW)
            s3.start(m_sequencer);
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 4...", UVM_LOW)
            s4.start(m_sequencer);

            
   endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
