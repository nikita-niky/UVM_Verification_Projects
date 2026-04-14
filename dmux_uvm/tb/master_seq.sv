class demux_master_seq extends uvm_sequence #(demux_item);
  `uvm_object_utils(demux_master_seq)
  
  function new(string name = "demux_master_seq");
    super.new(name);
  endfunction

        // Instances of the sub-sequences
        demux_base_seq        s1;
        demux_all_ones_seq    s2;
        demux_all_zeros_seq   s3;
        demux_select_unknown  s4;
        demux_pattern_seq     s5;

        task body();
            s1 = demux_base_seq::type_id::create("s1");
            s2 = demux_all_ones_seq::type_id::create("s2");
            s3 = demux_all_zeros_seq::type_id::create("s3");
            s4 = demux_select_unknown::type_id::create("s4");
            s5 = demux_pattern_seq::type_id::create("s5");

          

            `uvm_info("MASTER_SEQ", "Starting Sequence 1...", UVM_LOW)
            s1.start(m_sequencer); 
//           // m_sequencer is the sequencer this master is running on
            
            `uvm_info("MASTER_SEQ", "Starting Sequence 2...", UVM_LOW)
            s2.start(m_sequencer);
            
            `uvm_info("MASTER_SEQ", "Starting Sequence 3...", UVM_LOW)
            s3.start(m_sequencer);
          
          `uvm_info("MASTER_SEQ", "Starting Sequence 4...", UVM_LOW)
            s4.start(m_sequencer);
          
          `uvm_info("MASTER_SEQ", "Starting Sequence 5...", UVM_LOW)
            s5.start(m_sequencer);
          
          
        endtask
endclass