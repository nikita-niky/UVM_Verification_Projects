class counter_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(counter_scoreboard)
  counter_item tr;

  
  uvm_analysis_imp#(counter_item, counter_scoreboard) recv;

  logic [3:0] exp_count ;
  logic exp_max_tick;
  logic exp_min_tick;


  function new(string name = "counter_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv",this);
  endfunction

 
  virtual function void write(counter_item tr);
   
    if (!tr.rst && exp_count !== 4'bxxxx) begin 
      `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)

      if (tr.count !== exp_count ) begin
        `uvm_error("SCB_FAIL", $sformatf("Mismatch! Exp=%0d, Act=%0d", exp_count, tr.count))
      end else begin
        `uvm_info("SCB_PASS", $sformatf("Match! Exp=%0d, Act=%0d", exp_count, tr.count),UVM_LOW)

      end
    end

    if(tr.rst) begin
      exp_count = 4'b0000;
      `uvm_info("SCB_RST", "System in Reset - Forcing exp_count to 0", UVM_HIGH)

    end
    else 
      if (tr.load) begin
        exp_count = tr.count_in;
      end
    else begin
      if(tr.up_down)
        exp_count = exp_count + 1'b1;
      else
        exp_count = exp_count - 1'b1;
    end

    check_flags(tr);
  

  endfunction

  virtual function void check_flags(counter_item tr);
    exp_max_tick =(tr.count==4'b1111);
    exp_min_tick = (tr.count==4'b0000);

    if(tr.max_tick !==exp_max_tick)
      `uvm_error("SCB_TICK","Max Tick Mismatch!!")
      if(tr.min_tick!== exp_min_tick)
        `uvm_error("SCB_TICK","Min Tick Mismatch!!")
   endfunction

endclass
      
      
      
