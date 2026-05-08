class apb_master_seq extends uvm_sequence#(apb_item);
   `uvm_object_utils(apb_master_seq)

   function new(string name = "apb_master_seq");
     super.new(name);
   endfunction

   apb_write_read_seq       s1;
   apb_memory_stress_seq    s2;
   apb_error_injection_seq  s3;
   apb_reset_chk_seq        s4;
   apb_b2b_seq              s5;
   

   task body();
      s1 = apb_write_read_seq::type_id::create("s1");
      s2 = apb_memory_stress_seq::type_id::create("s2");
      s3 = apb_error_injection_seq::type_id::create("s3");
      s4 = apb_reset_chk_seq::type_id::create("s4");
      s5 = apb_b2b_seq::type_id::create("s5");



     // m_sequencer is the sequencer this master is running on
     `uvm_info("MASTER_SEQ", "Starting Sequence 1...", UVM_LOW)
     s1.start(m_sequencer);
     
     #50;

     `uvm_info("MASTER_SEQ", "Starting Sequence 2...", UVM_LOW)
     s2.start(m_sequencer);
     
     #50;

     `uvm_info("MASTER_SEQ", "Starting Sequence 3...", UVM_LOW)
     s3.start(m_sequencer);
      
     #50;

     `uvm_info("MASTER_SEQ", "Starting Sequence 4...", UVM_LOW)
     s4.start(m_sequencer);
     
     #50;

     `uvm_info("MASTER_SEQ", "Starting Sequence 5...", UVM_LOW)
     s5.start(m_sequencer);


   endtask
endclass