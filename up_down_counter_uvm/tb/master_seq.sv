class counter_master_seq extends uvm_sequence#(counter_item);
   `uvm_object_utils(counter_master_seq)

   function new(string name = "counter_master_seq");
     super.new(name);
   endfunction

   counter_base_sequence  s1;
   counter_directed_seq   s2;
 
 

   task body();
      s1 = counter_base_sequence::type_id::create("s1");
      s2=counter_directed_seq::type_id::create("s2");
      

     `uvm_info("MASTER_SEQ", "Starting Sequence 1...", UVM_LOW)
            s1.start(m_sequencer);
     
     #50;
     
     `uvm_info("MASTER_SEQ", "Starting Sequence 2...", UVM_LOW)
            s2.start(m_sequencer);

            
   endtask
endclass