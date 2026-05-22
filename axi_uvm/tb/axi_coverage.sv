class axi_coverage extends uvm_subscriber#(axi_item);
  `uvm_component_utils(axi_coverage)
  axi_item tr;

  covergroup axi_cg;
    option.per_instance=1;
    
    cp_op: coverpoint tr.op {
      bins WRITE_OP = {WRITE};
      bins READ_OP  = {READ};
    }
   
    cp_id: coverpoint tr.id {
      bins low_ids  = {[0:3]};
      bins med_ids  = {[4:11]};
      bins high_ids = {[12:15]};
      bins error_id = {8'hFF}; 
    }

   
    cp_len: coverpoint tr.len {
      bins single_beat = {0};
      bins short_burst = {[1:3]};
      bins long_burst  = {[4:15]};
      
    }
    
    cp_size: coverpoint tr.size {
      bins size_1_byte  = {3'b000};
      bins size_2_bytes = {3'b001};
      bins size_4_bytes = {3'b010}; // 32-bit container
    }
    
    cp_burst_type: coverpoint tr.burst {
      bins FIXED_BURST = {2'b00};
      bins INCR_BURST  = {2'b01};
      bins WRAP_BURST  = {2'b10};
    }

    
    cp_unaligned_offset: coverpoint (tr.addr % 4) {
      bins ALIGNED   = {0};
      bins OFFSET_1B = {1};
      bins OFFSET_2B = {2};
      bins OFFSET_3B = {3};
    }

    cp_resp_status: coverpoint tr.resp[0] {
      bins OKAY_RESP   = {2'b00};
      bins DECERR_RESP = {2'b11};
    }
       
    cross_burst_x_len: cross cp_burst_type, cp_len {
      illegal_bins illegal_wrap_len = binsof(cp_burst_type.WRAP_BURST) && binsof(cp_len) intersect {0}; 
    }
    
    cross_id_x_len: cross cp_id, cp_len{
      ignore_bins error = binsof(cp_id.error_id) && binsof(cp_len);
      ignore_bins er = binsof(cp_id.low_ids) && binsof(cp_len.single_beat);
    }
    
    cross_op_x_resp: cross cp_op, cp_resp_status;


  endgroup

  function new(string name,uvm_component parent);
    super.new(name,parent);
    axi_cg = new();
  endfunction

  virtual function void write(axi_item t);
    this.tr=t;
    axi_cg.sample();
  endfunction

endclass

