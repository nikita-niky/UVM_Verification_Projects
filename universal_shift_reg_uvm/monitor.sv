class univ_sr_monitor extends uvm_monitor;
  `uvm_component_utils(univ_sr_monitor)

  virtual sr_if vif;
  sr_item tr;


  uvm_analysis_port #(sr_item) send;

  function new(string name = "univ_sr_monitor", uvm_component parent);
    super.new(name, parent);
    send = new("send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sr_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);

    forever begin
      tr = sr_item::type_id::create("tr");
      @(vif.mon_cb);

      if(vif.mon_cb.rst) begin

        `uvm_info("MON","Reset ACTIVE", UVM_LOW)

        tr.rst        = vif.mon_cb.rst;
        tr.mode        = vif.mon_cb.mode;
        tr.sin_left   = vif.mon_cb.sin_left;
        tr.sin_right  = vif.mon_cb.sin_right;
        tr.d_in       = vif.mon_cb.d_in;
        tr.q_out      = vif.mon_cb.q_out;

        `uvm_info("MON",$sformatf("rst=%0b | mode=%2b | sin_left=%0b | sin_right=%0b | d_in=%4b | q_out=%4b",tr.rst,tr.mode,tr.sin_left,tr.sin_right, tr.d_in, tr.q_out ),UVM_LOW)

        send.write(tr);

      end
      else begin

        tr.rst        = vif.mon_cb.rst;
        tr.mode        = vif.mon_cb.mode;
        tr.sin_left   = vif.mon_cb.sin_left;
        tr.sin_right  = vif.mon_cb.sin_right;
        tr.d_in       = vif.mon_cb.d_in;

        tr.q_out      = vif.mon_cb.q_out; //result

        `uvm_info("MON",$sformatf("rst=%0b | mode=%2b | sin_left=%0b | sin_right=%0b | d_in=%4b | q_out=%4b",tr.rst,tr.mode,tr.sin_left,tr.sin_right, tr.d_in, tr.q_out ),UVM_LOW)

        send.write(tr);

      end
    end

  endtask
endclass