class arb_master_seq extends uvm_sequence#(arb_item);
   `uvm_object_utils(arb_master_seq)

   function new(string name = "arb_master_seq");
     super.new(name);
   endfunction

   arb_all_high_sequence      s1;
   arb_walking_ones_sequence  s2;
   arb_random_sequence        s3;
   arb_directed_sequence      s4;
  
   task body();
      s1 = arb_all_high_sequence::type_id::create("s1");
      s2 = arb_walking_ones_sequence::type_id::create("s2");
      s3 = arb_random_sequence::type_id::create("s3");
      s4 = arb_directed_sequence::type_id::create("s4");
     
     

     // m_sequencer is the sequencer this master is running on
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
     
     
   endtask
endclass