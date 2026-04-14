class arb_monitor extends uvm_monitor;
  `uvm_component_utils(arb_monitor)

  virtual arb_if vif;
  arb_item tr;

  uvm_analysis_port #(arb_item) send;

  function new(string name = "arb_monitor", uvm_component parent);
    super.new(name, parent);
    send = new("send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual arb_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
   
    forever begin
      tr = arb_item::type_id::create("tr");

      @(vif.mon_cb);

      tr.rst_n = vif.mon_cb.rst_n;
      tr.req = vif.mon_cb.req;
      tr.gnt = vif.mon_cb.gnt;

      `uvm_info("MON", $sformatf("rst_n=%0b | req: %4b, gnt: %4b",tr.rst_n, tr.req, tr.gnt), UVM_LOW)      


      send.write(tr);

    end
  endtask
endclass