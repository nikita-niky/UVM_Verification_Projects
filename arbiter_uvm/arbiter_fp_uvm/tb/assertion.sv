module arbiter_assertion(
  input logic clk,
  input logic rst_n,
  input logic [3:0] req,
  input logic [3:0] gnt
);
  //active reset check
  property p_rst_logic;
    @(posedge clk) (!rst_n) |-> (gnt == 4'b0000);
  endproperty
  a_reset_logic:assert property(p_rst_logic)
    else $error("RESET active and gnt is not zero!");
  
    
  //inactive reset check
    property p_rst_ia;
      @(posedge clk) $rose(rst_n) |-> (gnt==4'b0000);
    endproperty
    a_rst_ia: assert property(p_rst_ia)
      else $error("failed to initialize gnt at 0000!!");
      
  // priority logic check
  property p_priority_check;
    @(posedge clk) disable iff(!rst_n) (req[0] && req[3]) |=> gnt==4'b0001;
  endproperty
      a_logic_check:assert property(p_priority_check)
        else $error("Priority logic has problem!!");
          
 //logic check

          
 a_0_check:assert property(@(posedge clk) disable iff(!rst_n) (req[0]) |=> (gnt ==4'b0001))
            else $error ("A_0 check failed");
   a_1_check:assert property(@(posedge clk) disable iff(!rst_n) (!req[0] && req[1]) |=> (gnt ==4'b0010))
              else $error ("A_1 check failed");
     a_2_check:assert property(@(posedge clk) disable iff(!rst_n) (!req[0] && !req[1] && req[2]) |=> (gnt ==4'b0100))
                else $error ("A_2 check failed");
       a_3_check:assert property(@(posedge clk) disable iff(!rst_n) (!req[0] && !req[1] && !req[2] && req[3]) |=> (gnt ==4'b1000))
                  else $error ("A_3 check failed");
            
          
 //ONE HOT check
 property p_one_hot_gnt;
   @(posedge clk) disable iff (!rst_n)
   $onehot0(gnt); // Returns true if 0 or 1 bit is high
 endproperty

 a_one_hot: assert property(p_one_hot_gnt) 
  else $error("ASSERT", "GNT is not one-hot!"); 
            
  //GHOST grant check
   property p_no_ghost_grant;
     @(posedge clk) disable iff (!rst_n)
     |gnt |-> |req; // If any grant is high, some request must be high
   endproperty
   a_no_ghost_grant:assert property(p_no_ghost_grant)
     else $error("Ghost grant given!!");

    
  

endmodule