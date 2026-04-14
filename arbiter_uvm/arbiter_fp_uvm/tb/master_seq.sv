class arbiter_master_seq extends uvm_sequence#(arbiter_item);
  `uvm_object_utils(arbiter_master_seq)


  function new(string name = "arbiter_master_seq");
    super.new(name);
  endfunction

  arbiter_directed_sequence  s1;
  arbiter_stress_sequence    s2;
  arbiter_reset_sequence     s3;
  arbiter_starvation_sequence s4;

  task body();
    s1 = arbiter_directed_sequence::type_id::create("s1");
    s2 = arbiter_stress_sequence::type_id::create("s2");
    s3 = arbiter_reset_sequence::type_id::create("s3");
    s4 = arbiter_starvation_sequence::type_id::create("s4");



    // m_sequencer is the sequencer this master is running on
    `uvm_info("MASTER_SEQ", "Starting Sequence 1...", UVM_LOW)
    s1.start(m_sequencer);

    #20;

    `uvm_info("MASTER_SEQ", "Starting Sequence 2...", UVM_LOW)
    s2.start(m_sequencer);

    #30;

    `uvm_info("MASTER_SEQ", "Starting Sequence 3...", UVM_LOW)
    s3.start(m_sequencer);
    #20;

    `uvm_info("MASTER_SEQ", "Starting Sequence 4...", UVM_LOW)
    s4.start(m_sequencer);



  endtask
endclass