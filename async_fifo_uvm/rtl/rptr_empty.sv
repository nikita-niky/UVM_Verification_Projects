module rptr_empty #(parameter ADDR_SIZE = 4) (
  input  logic                 rclk, rrst_n, rinc,
  input  logic [ADDR_SIZE:0]   rq2_wptr,
  output logic                 rempty,
  output logic [ADDR_SIZE-1:0] raddr,
  output logic [ADDR_SIZE:0]   rptr
);
  logic [ADDR_SIZE:0] rbin;
  logic [ADDR_SIZE:0] rgraynext, rbinnext;
  logic rempty_val;

  assign raddr = rbin[ADDR_SIZE-1:0];

  always_ff @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) 
      {rbin, rptr} <= '0;
    else        
      {rbin, rptr} <= {rbinnext, rgraynext};
  end

  assign rbinnext  = rbin + (rinc & ~rempty);
  assign rgraynext = (rbinnext >> 1) ^ rbinnext;

  assign rempty_val = (rgraynext == rq2_wptr);

  always_ff @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) 
      rempty <= 1'b1;
    else        
      rempty <= rempty_val;
  end
endmodule