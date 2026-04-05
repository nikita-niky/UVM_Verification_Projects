class univ_sr_driver extends uvm_driver #(sr_item);
  `uvm_component_utils(univ_sr_driver)
  sr_item tr;

  
  virtual sr_if vif;

  function new(string name = "univ_sr_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sr_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

 
  virtual task run_phase(uvm_phase phase);
    
    vif.drv_cb.rst       <= 1;
    vif.drv_cb.mode      <=0;
    vif.drv_cb.sin_left  <=0;
    vif.drv_cb.sin_right <=0;
    vif.drv_cb.d_in      <=0;

    repeat(2)@(vif.drv_cb);
    vif.drv_cb.rst      <=0;


    forever begin
      tr= sr_item::type_id::create("tr");
      seq_item_port.get_next_item(tr);
      drive_item(tr);
      seq_item_port.item_done();
    end
  endtask


  virtual task drive_item(sr_item tr);
    `uvm_info(get_type_name(), "Driving transaction to pins...", UVM_HIGH)
    
    @(vif.drv_cb);
    
    vif.drv_cb.rst       <= tr.rst;
    vif.drv_cb.mode      <= tr.mode;
    vif.drv_cb.sin_left  <=tr.sin_left;
    vif.drv_cb.sin_right <=tr.sin_right;
    vif.drv_cb.d_in      <=tr.d_in;
    
    `uvm_info("DRV",$sformatf("rst=%0b | mode=%2b | sin_left=%0b | sin_right=%0b | d_in=%4b ",tr.rst,tr.mode,tr.sin_left,tr.sin_right, tr.d_in),UVM_LOW)
    

    
    
  endtask
endclass
