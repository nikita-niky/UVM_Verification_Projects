class axi_master_seq extends uvm_sequence#(axi_item);
   `uvm_object_utils(axi_master_seq)

   function new(string name = "axi_master_seq");
     super.new(name);
   endfunction
  
   axi_sanity_sequence         s1;
   axi_random_stress_seq       s2;
   axi_error_injection_seq     s3;
   axi_interleave_stress_seq   s4;
   axi_slave_stall_seq         s5;
   axi_sparse_strobe_seq       s6;
   axi_burst_boundary_seq      s7;
   axi_protocol_violation_seq  s8;
   
  


   task body();
      s1 = axi_sanity_sequence::type_id::create("s1");
      s2 = axi_random_stress_seq::type_id::create("s2");
      s3 = axi_error_injection_seq::type_id::create("s3");
     s4 = axi_interleave_stress_seq::type_id::create("s4");
     s5 = axi_slave_stall_seq::type_id::create("s5");
     s6 = axi_sparse_strobe_seq::type_id::create("s6");
     s7 = axi_burst_boundary_seq ::type_id::create("s7");
     s8 = axi_protocol_violation_seq ::type_id::create("s8");
     

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
     

     
     `uvm_info("MASTER_SEQ", "Starting Sequence 8...", UVM_LOW)
     s8.start(m_sequencer);

            
   endtask
endclass