class counter_driver extends uvm_driver #(counter_item);
  `uvm_component_utils(counter_driver)
  counter_item tr;

  
  virtual counter_if vif;

  function new(string name = "counter_driver", uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual counter_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  
  virtual task run_phase(uvm_phase phase);
    
    vif.drv_cb.rst <= 1;
    vif.drv_cb.load <= 0;
    vif.drv_cb.up_down <= 0;
    vif.drv_cb.count_in <= 0;
    
    repeat(2) @(vif.drv_cb);
    vif.drv_cb.rst <= 0;
    
    
    forever begin
      tr= counter_item::type_id::create("tr");
      seq_item_port.get_next_item(tr);
          
      drive_item(tr);
      seq_item_port.item_done();
    end
  endtask

 
  virtual task drive_item(counter_item tr);
    `uvm_info(get_type_name(), "Driving transaction to pins...", UVM_HIGH)
    
    @(vif.drv_cb);
    
    vif.drv_cb.rst      <= tr.rst;
    vif.drv_cb.load     <= tr.load;
    vif.drv_cb.up_down  <= tr.up_down;
    vif.drv_cb.count_in <= tr.count_in;
    
    `uvm_info("DRV",$sformatf("rst=%0b,load=%0b | up_down=%0b | count_in=%0d",tr.rst,tr.load,tr.up_down,tr.count_in),UVM_LOW)
    
    @(vif.drv_cb);//for synchornity
    
    
    
  endtask
endclass
