class demux_driver extends uvm_driver#(demux_item);
  `uvm_component_utils(demux_driver)
  demux_item tr;
  
  virtual demux_if.DRV vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual demux_if.DRV)::get(this, "", "vif", vif))
      `uvm_error("DRV", "VIF.DRV not found")
      
      endfunction

    virtual task run_phase(uvm_phase phase);
        vif.sel <= 2'b0;

    
        forever begin
          tr=demux_item::type_id::create("tr");
          
          seq_item_port.get_next_item(tr);
          
          @(posedge vif.clk);
          	vif.rst_n <= 1'b1;
            vif.d   <= tr.d;
            vif.sel <= tr.sel;
			`uvm_info("DRV", $sformatf("Driving d=%h sel=%0d", tr.d, tr.sel), UVM_HIGH)
          
            seq_item_port.item_done();
        end
    endtask
endclass