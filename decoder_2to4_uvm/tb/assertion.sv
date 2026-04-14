module dec_assertion( 
  input logic [1:0] sel,
  input logic en,
  input logic [3:0] y
);
//The One-Hot Assertion
  property p_one_hot;
    @(en or sel or y) (en==1'b1) |-> ($onehot(y));
  endproperty
  
  assert_one_hot: assert property(p_one_hot)
    else 
      $error("Violation: More than one output bit is high!");
    
//The All-Zero (Disabled) Assertion
  property p_disabled_zero;
    @(en or sel or y) (en==1'b0)|-> (y==4'b0000);
  endproperty
   
  assert_disable_zero: assert property(p_disabled_zero)
    else 
      $error("Violation: Output is not zero when disabled!");
 
 //  The X-Propagation Assertion   
   property p_x_prop;
     @(en or sel or y) (en===1'b1 && $isunknown(sel))|-> $isunknown(y);
   endproperty
      
   assert_x_prop: assert property(p_x_prop)
     else
       $error("Violation: X on 'sel' did not propagate to 'y'!");

 //   The Functional Mapping Assertion
    property p_functional_check;
      @(en or sel or y) (en==1'b1) |-> (y==(4'b0001<< sel));
    endproperty
      
    assert_functional_check: assert property(p_functional_check)
      else
        $error("Violation: Output y does not match selection input!");

 //  Stability Assertion       
     property p_stability;
       @(en or sel or y) $stable(en) && $stable(sel) |->  $stable(y);
     endproperty
          
     assert_stability: assert property(p_stability)
       else
         $error("Glitch detected: Output changed without input change!");
            
            
    

endmodule