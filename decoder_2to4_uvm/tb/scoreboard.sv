
class dec_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(dec_scoreboard)
  dec_item tr;

  
  uvm_analysis_imp#(dec_item, dec_scoreboard) recv;

  logic [3:0] exp_y; // checking exp_value 
 
  
  int pass_count = 0;// Simple counters for checking
  int fail_count = 0;
  

  function new(string name = "dec_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv",this);
  endfunction

  
  virtual function void write(dec_item tr);
    `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)
    if(tr.en==1'b0) begin
      exp_y= 4'b0000;
    end else begin
      exp_y = (4'b0001 << tr.sel);
    end
      // Shift '1' to the left by 'sel' amount
      // sel=0 -> 1<<0 = 0001
      // sel=3 -> 1<<3 = 1000
    
    ////COMPARISION
    if (tr.y === exp_y) begin
      `uvm_info("SCB_PASS", $sformatf("MATCH! en=%b sel=%0d | Got: %b Expected: %b", 
                tr.en, tr.sel, tr.y, exp_y), UVM_LOW)
      pass_count++;
    end else begin
      `uvm_error("SCB_FAIL", $sformatf("MISMATCH! en=%b sel=%0d | Got: %b Expected: %b", 
                 tr.en, tr.sel, tr.y, exp_y))
      fail_count++;
    end
  
      
  endfunction

  
  virtual function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Tests Passed: %0d, Failed: %0d", pass_count, fail_count), UVM_LOW)
  endfunction
  
endclass