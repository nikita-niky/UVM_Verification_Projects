class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)

  virtual fifo_if vif;
  fifo_item tr;

  uvm_analysis_port #(fifo_item) send;

  function new(string name = "fifo_monitor", uvm_component parent);
    super.new(name, parent);
    send = new("send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
   
    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.wr_en || vif.mon_cb.rd_en || !vif.mon_cb.rst_n) begin
        tr = fifo_item::type_id::create("tr");
        tr.rst_n = vif.mon_cb.rst_n;
        tr.wr_en = vif.mon_cb.wr_en;
        tr.rd_en = vif.mon_cb.rd_en;
        tr.wdata = vif.mon_cb.wdata;
        tr.full  = vif.mon_cb.full;
        tr.empty = vif.mon_cb.empty;
        tr.rdata = vif.mon_cb.rdata;

        `uvm_info("MON", $sformatf("rst_n=%0b, wr_en=%0b, wdata=%0h, rd_en=%0b, rdata=%0h, full=%0b, empty=%0b",tr.rst_n,tr.wr_en, tr.wdata, tr.rd_en, tr.rdata, tr.full, tr.empty), UVM_LOW) 

        send.write(tr);
      end

    end
  endtask
endclass