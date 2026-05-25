/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_master_seq extends uvm_sequence#(fifo_item);
   `uvm_object_utils(fifo_master_seq)
  fifo_item tr;
  

   function new(string name = "fifo_master_seq");
     super.new(name);
   endfunction

   fifo_directed_sequence  s1;
   fifo_random_seq         s2;
   fifo_simultaneous_seq   s3;
   fifo_ovfl_unfl_seq      s4;
   fifo_threshold_seq      s5;

   task body();
      s1 = fifo_directed_sequence::type_id::create("s1");
      s2 = fifo_random_seq::type_id::create("s2");
      s3 = fifo_simultaneous_seq::type_id::create("s3");
      s4 = fifo_ovfl_unfl_seq::type_id::create("s4");
      s5 = fifo_threshold_seq::type_id::create("s5");
     

     repeat(2) begin
       `uvm_do_with(tr,{tr.rst_n==1'b0;})
     end

//      // m_sequencer is the sequencer this master is running on
     `uvm_info("MASTER_SEQ", "Starting Sequence 1...", UVM_LOW)
     s1.start(m_sequencer);
     
     #20;

     `uvm_info("MASTER_SEQ", "Starting Sequence 2...", UVM_LOW)
     s2.start(m_sequencer);
       
     #20;

     `uvm_info("MASTER_SEQ", "Starting Sequence 3...", UVM_LOW)
     s3.start(m_sequencer);
  
     #20;


     `uvm_info("MASTER_SEQ", "Starting Sequence 4...", UVM_LOW)
     s4.start(m_sequencer);
  
     #20;

     `uvm_info("MASTER_SEQ", "Starting Sequence 5...", UVM_LOW)
     s5.start(m_sequencer);
  
     #20;
           
   endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
