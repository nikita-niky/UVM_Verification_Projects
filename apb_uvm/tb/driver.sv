class apb_driver extends uvm_driver #(apb_item);
  `uvm_component_utils(apb_driver)
  apb_item tr;


  virtual apb_if vif;

  function new(string name = "apb_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  
  virtual task run_phase(uvm_phase phase);
    
    vif.transfer <= 0;
    vif.addr_in  <= 0;
    vif.data_in  <= 0;
    vif.write_en <= 0;  
    
    forever begin
      tr= apb_item::type_id::create("tr");
      seq_item_port.get_next_item(tr);
      drive_item(tr);
      seq_item_port.item_done();
    end
  endtask

 
  virtual task drive_item(apb_item tr);
    `uvm_info(get_type_name(), "Driving transaction to pins...", UVM_HIGH)
    @(vif.cb_m);
    vif.cb_m.addr_in <= tr.addr;
    vif.cb_m.data_in <= tr.data;
    vif.cb_m.write_en <= tr.write_en;
    vif.cb_m.transfer <= 1'b1;

    @(vif.cb_m);
    // now master in setup state
    wait(vif.cb_m.pready===1'b1 && vif.penable === 1'b1);
    @(vif.cb_m);
    vif.cb_m.transfer <= 1'b0; // for B2B test diable this

    tr.prdata = vif.cb_m.prdata;
    tr.pslverr = vif.cb_m.pslverr;
    
    if(tr.write_en) 
      `uvm_info("WR","------------WRITE HAPPENING-----------------",UVM_LOW)
      else
        `uvm_info("RD","------------READ HAPPENING-----------------",UVM_LOW)
    
    `uvm_info("DRV", $sformatf("Done: Addr=%h, Data=%h, Write=%b", tr.addr, tr.data, tr.write_en), UVM_LOW)
    
    
  endtask
endclass
