class fsm_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(fsm_scoreboard)
  fsm_item tr;

  
  uvm_analysis_imp#(fsm_item, fsm_scoreboard) recv;
  
  state_t exp_state = IDLE; // defined in pkg

  function new(string name = "fsm_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv",this);
  endfunction

 
  virtual function void write(fsm_item tr);
    
    if(tr.rst_n && exp_state !== 3'bxxx) begin
      `uvm_info(get_type_name(), "Scoreboard received item", UVM_LOW)
      if(tr.current_state !== exp_state) begin
        `uvm_error("SCB_FAIL",$sformatf("RTL state =%s Exp state =%s",tr.current_state.name(),exp_state.name()))
      end
      else begin
        `uvm_info("SCB_PASS",$sformatf("RTL state =%s Exp state =%s",tr.current_state.name(),exp_state.name()),UVM_LOW)
      end
    end
    
    if(tr.rst_n && exp_state == S1011) begin ///comparing the output 
      if(tr.pattern_found !==1'b1)
        `uvm_error("OUT_ERR","Pattern found should be HIGH in S1011")
        end
        else begin 
          if(tr.pattern_found !==1'b0)
            `uvm_error("OUT_ERR","Pattern found should BE LOW")
            end 
    
    
    if(!tr.rst_n) begin
      exp_state = IDLE;
      return;
    end    
    else begin   

      case(exp_state)  ///updating reference model for next clock
        IDLE:  exp_state = tr.bit_in ? S1 : IDLE;
        S1:    exp_state = tr.bit_in ? S1 : S10;
        S10:   exp_state = tr.bit_in ? S101 : IDLE;
        S101:  exp_state = tr.bit_in ? S1011: S10;
        S1011: exp_state = tr.bit_in ? S1 : IDLE;
        default: exp_state = IDLE;
      endcase
    end
           
        `uvm_info("SCB", $sformatf("Bit: %b | State Match: %s | Out Match: %b",tr.bit_in, tr.current_state.name(), tr.pattern_found), UVM_LOW)
                  
  endfunction

endclass