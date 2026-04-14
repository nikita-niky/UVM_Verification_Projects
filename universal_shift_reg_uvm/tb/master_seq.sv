class univ_sr_master_seq extends uvm_sequence#(sr_item);
   `uvm_object_utils(univ_sr_master_seq)

   function new(string name = "univ_sr_master_seq");
     super.new(name);
   endfunction

   univ_sr_directed_sequence  s1;
   univ_sr_reset_seq          s2;
   univ_sr_stress_seq         s3;
   univ_sr_full_random_seq    s4;


  task body();
    s1 = univ_sr_directed_sequence::type_id::create("s1");
    s2 = univ_sr_reset_seq::type_id::create("s2");
    s3 = univ_sr_stress_seq::type_id::create("s3");
    s4 = univ_sr_full_random_seq::type_id::create("s4");


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