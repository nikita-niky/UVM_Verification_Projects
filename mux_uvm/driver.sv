class mux_driver extends uvm_driver #(mux_transaction);
  `uvm_component_utils(mux_driver)
  mux_transaction tr;
  
  virtual mux_if.DRV vif;
  
  function new(string name="mux_driver",uvm_component parent);
    super.new(name,parent);
  endfunction;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    
    if(!uvm_config_db#(virtual mux_if.DRV)::get(this,"","vif",vif))
    `uvm_error("[DRV]"," Config_db not found !!")
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      tr=mux_transaction::type_id::create("tr");
      
      seq_item_port.get_next_item(tr);
      
      @(vif.clk);
//       #1;
      vif.d <= tr.d;
      vif.sel <= tr.sel;
      #10;
      
      seq_item_port.item_done();
      
    end
  endtask
  
endclass
      