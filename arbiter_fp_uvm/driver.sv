class arbiter_driver extends uvm_driver #(arbiter_item);
  `uvm_component_utils(arbiter_driver)

  arbiter_item tr;
  virtual arbiter_if vif;

  function new(string name = "arbiter_driver", uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual arbiter_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction


  virtual task run_phase(uvm_phase phase);
    
    vif.drv_cb.rst_n <= 0;
    vif.drv_cb.req <= 0;
    
    repeat(2) @(vif.drv_cb);
    vif.drv_cb.rst_n <= 1;
    
    forever begin
      tr= arbiter_item::type_id::create("tr");
      seq_item_port.get_next_item(tr);
      drive_item(tr);
      seq_item_port.item_done();
    end
  endtask


  virtual task drive_item(arbiter_item tr);
    `uvm_info(get_type_name(), "Driving transaction to pins...", UVM_HIGH)
    
    @(vif.drv_cb);
    vif.drv_cb.rst_n <= tr.rst_n;
    vif.drv_cb.req <= tr.req;
    
    `uvm_info("DRV", $sformatf("Driving rst_n = %0b | req = %4b", tr.rst_n, tr.req), UVM_LOW)
    @(vif.drv_cb);
    

  endtask
endclass
