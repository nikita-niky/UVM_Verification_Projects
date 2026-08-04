/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class dec_master_seq extends uvm_sequence#(dec_item);
   `uvm_object_utils(dec_master_seq)

   function new(string name = "dec_master_seq");
     super.new(name);
   endfunction

   dec_base_sequence     s1;
   dec_en_zero_seq       s2;
   dec_en_one_seq        s3;
   dec_walking_ones_seq  s4;
   dec_en_toggle_seq     s5;
   dec_x_propogation_seq s6;
   dec_sel_toggle_seq    s7;

   task body();
      s1 = dec_base_sequence::type_id::create("s1");
      s2 = dec_en_zero_seq::type_id::create("s2");
      s3 = dec_en_one_seq::type_id::create("s3");
      s4 = dec_walking_ones_seq::type_id::create("s4");
      s5 = dec_en_toggle_seq::type_id::create("s5");
      s6 = dec_x_propogation_seq::type_id::create("s6");
      s7 = dec_sel_toggle_seq::type_id::create("s7");     
     



     // m_sequencer is the sequencer this master is running on
     `uvm_info("MASTER_SEQ", "Starting Sequence 1...", UVM_LOW)
            s1.start(m_sequencer);
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 2...", UVM_LOW)
            s2.start(m_sequencer);
     
      
     `uvm_info("MASTER_SEQ", "Starting Sequence 3...", UVM_LOW)
            s3.start(m_sequencer);
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 4...", UVM_LOW)
            s4.start(m_sequencer);
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 5...", UVM_LOW)
            s5.start(m_sequencer);
     
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 6...", UVM_LOW)
            s6.start(m_sequencer);
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 7...", UVM_LOW)
            s7.start(m_sequencer);
     

      endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
