module wptr_full #(parameter ADDR_SIZE = 4) (
  input  logic                 wclk, wrst_n, winc,
  input  logic [ADDR_SIZE:0]   wq2_rptr, 
  output logic                 wfull,
  output logic [ADDR_SIZE-1:0] waddr,
  output logic [ADDR_SIZE:0]   wptr
);
  logic [ADDR_SIZE:0] wbin;   ///binary 
  logic [ADDR_SIZE:0] wgraynext, wbinnext;
  logic wfull_val;

  
  assign waddr = wbin[ADDR_SIZE-1:0];  // Memory address is just the lower bits of the binary pointer

  always_ff @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n) 
      {wbin, wptr} <= '0;
    else         
      {wbin, wptr} <= {wbinnext, wgraynext};
  end

 
  assign wbinnext  = wbin + (winc & ~wfull);    // Increment binary pointer if not full
 
  assign wgraynext = (wbinnext >> 1) ^ wbinnext;   // Binary to Gray conversion: (bin >> 1) ^ bin

  // Full condition: MSB and 2nd MSB are inverted, rest are same
  // This happens because Gray code is reflective
  assign wfull_val = (wgraynext == {~wq2_rptr[ADDR_SIZE:ADDR_SIZE-1], wq2_rptr[ADDR_SIZE-2:0]});

  always_ff @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n) 
      wfull <= 1'b0;
    else        
      wfull <= wfull_val;
  end
endmodule