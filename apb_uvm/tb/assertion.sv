module apb_master_sva(
  input  logic        PCLK,
  input  logic        PRESETn,

  input  logic        transfer,   
  input  logic [31:0] addr_in,
  input  logic [31:0] data_in,
  input  logic        write_en,

  // APB Interface
  input logic [31:0] PADDR,
  input logic        PSEL,
  input logic        PENABLE,
  input logic        PWRITE,
  input logic [31:0] PWDATA,
  input logic [31:0] PRDATA,
  input logic        PREADY
); 
 typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state_t;
  state_t state;
  
  
  //RESET chk
  property p_mstr_reset_chk;
    @(posedge PCLK) !PRESETn |=> (!PSEL && !PENABLE && !PADDR && !PWRITE && !PWDATA);
  endproperty
  
  a_mstr_reset_chk:assert property(p_mstr_reset_chk)
    else $error("RESET asserted But the Signals still 1");
    
//     property p_mstr_reset;
    // @(negedge PRESETn) 1 |=> @(posedge PCLK) (!PSEL && !PENABLE);  // can also chk reset like this 
// endproperty
    
  //1. PSEL must go high when a transfer is requested (IDLE -> SETUP)
  property p_mstr_psel_start;
    @(posedge PCLK) disable iff (!PRESETn)
    (state == IDLE && transfer) |=> (PSEL ==1);
  endproperty
  
  a_mstr_psel_start:assert property(p_mstr_psel_start)
    else $error("PSEL not asserted even after tranfer with IDLE");
    
    
  // 2. PENABLE must be LOW during SETUP and HIGH during ACCESS  
   property p_penable_logic;
     @(posedge PCLK) disable iff (!PRESETn)
     (state == SETUP) |-> (PENABLE == 0) ##1 (PENABLE == 1);
   endproperty
    
    a_penable_logic: assert property(p_penable_logic)
      else $error("PENABLE not asserted for SETUP phase");
      
  // 3. Stability: PADDR/PWRITE/PWDATA must not change during the ACCESS phase
      
      property p_signals_stable;
        @(posedge PCLK) disable iff(!PRESETn)
        (state == ACCESS && !PREADY) |=> ($stable (PADDR) && $stable(PWRITE) && $stable(PWDATA));
      endproperty
      a_signals_stable:assert property (p_signals_stable)
        else $error("Signals NOT Stable in ACCESS state");
        
//PROTOCOL PHASE VALIDATION
        
    //penable must be 1 only after psel is 1
    assert property (@(posedge PCLK) disable iff (!PRESETn) PENABLE |-> PSEL)
      else $error("PENABLE 1 when PSEL 0 ");
    
      // checking the psel and penable when moving from setup to access state
   assert property(@(posedge PCLK) disable iff (!PRESETn) (PSEL && !PENABLE) |=> (PSEL && PENABLE))
     else $error("PROTOCOL violation in SETUP to ACCESS phase");
     
    // write behavious validation
     assert property (@(posedge PCLK) disable iff (!PRESETn) (PSEL && PENABLE && PWRITE) |-> !$isunknown(PWDATA))
       else $error("invalid PWDATA recived");
       
       assert property (@(posedge PCLK) disable iff (!PRESETn) (PSEL) |-> !$isunknown(PADDR))
         else $error("MASTER ERR: Master driving 'X' on PADDR");
        
endmodule
         
         
         
         
module apb_slave_sva(
  input  logic        PCLK,
  input  logic        PRESETn,
  input  logic [31:0] PADDR,
  input  logic        PSEL,
  input  logic        PENABLE,
  input  logic        PWRITE,
  input  logic [31:0] PWDATA,
  input  logic [31:0] PRDATA,
  input  logic        PREADY,
  input  logic        PSLVERR
);
 
  ///RESET chk
  property p_slv_reset_chk;
    @(posedge PCLK) !PRESETn |=> (!PRDATA && !PREADY && !PSLVERR);
  endproperty
  a_slv_reset_ckh:assert property(p_slv_reset_chk)
    else $error("PRESET is active but signals have value");
    
    
  //READ data protocol validation
  assert property (@(posedge PCLK) disable iff (!PRESETn) (PSEL && PENABLE && !PWRITE) |-> !$isunknown(PRDATA))
    else $error("invalid PRDATA recived");
    
  // 1. Slave must not drive PREADY or PSLVERR if PSEL is low
  property p_slave_idle_check;
  @(posedge PCLK) disable iff (!PRESETn)
    (!PSEL) |=> (PREADY == 0 && PSLVERR == 0);
endproperty
assert_slave_idle_check: assert property (p_slave_idle_check)
  else $error("SLAVE IDLE chk fail");

// 2. PSLVERR Logic: If address is invalid, PSLVERR must go high during ACCESS
property p_slave_error_check;
  @(posedge PCLK) disable iff (!PRESETn)
  (PSEL && PENABLE && !((PADDR[31:6] == 0) && (PADDR[5:2] < 16))) |=> (PSLVERR == 1);
endproperty
assert_slave_error_check: assert property (p_slave_error_check)
  else $error("PSLVERR not working as desired");

// 3. PREADY Requirement: PREADY should eventually go high to prevent bus hang
property p_slave_finish;
  @(posedge PCLK) disable iff (!PRESETn)
  PSEL |-> s_eventually PREADY;
endproperty
assert_slave_finish: assert property (p_slave_finish)
  else $error("PREADY not 1 when PSEL goes 1 can cause bus hang");
  
  
  
endmodule