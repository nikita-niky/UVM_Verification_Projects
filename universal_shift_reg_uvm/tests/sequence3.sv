class univ_sr_stress_seq extends uvm_sequence#(sr_item);
  `uvm_object_utils(univ_sr_stress_seq)

    sr_item tr;

  function new(string name = "univ_sr_stress_seq");
        super.new(name);
    endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence 3 body", UVM_LOW) 
    tr = sr_item::type_id::create("tr");
    
    ///Stress test
    `uvm_do_with(tr,{tr.rst==0; tr.mode==2'b11; tr.d_in ==4'b1010; })
    
    repeat(2) begin
    `uvm_do_with(tr,{tr.rst==0; tr.mode==2'b01; tr.sin_left==1'b1;})
    end
    
    repeat(2) begin
      `uvm_do_with(tr,{tr.rst==0; tr.mode==2'b10; tr.sin_right==1'b0;})
    end
    
    `uvm_do_with(tr,{tr.rst==1;})
    
    `uvm_do_with(tr,{tr.rst == 0; tr.mode == 2'b11; tr.d_in == 4'b1111;})
    `uvm_do_with(tr,{tr.rst == 0; tr.mode == 2'b00;})
    
    `uvm_do_with(tr,{tr.rst==1;})
    
        
    `uvm_info(get_type_name(), "Sequence 3 body finished", UVM_LOW)    
  endtask
  
  
endclass