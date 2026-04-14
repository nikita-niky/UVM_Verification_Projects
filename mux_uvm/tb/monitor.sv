class mux_monitor extends uvm_monitor;
  `uvm_component_utils(mux_monitor)
  virtual mux_if.MON vif;
  mux_transaction tr;
  
  uvm_analysis_port #(mux_transaction) send;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    send=new("send",this);
    
    if(!uvm_config_db#(virtual mux_if.MON)::get(this,"","vif",vif))
      `uvm_error("[MON]"," Interface not found!!!")
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      tr=mux_transaction::type_id::create("tr");
      
      @(vif.cb);
      
      tr.d = vif.d;
      tr.sel = vif.sel;
      tr.y = vif.y;
      
      send.write(tr);
      // for this the code is written in scoreboard beacuse the communication need to be in zero simulation time.
//       `uvm_info("[MON]","")
    end
  endtask
  
endclass
      
    
      