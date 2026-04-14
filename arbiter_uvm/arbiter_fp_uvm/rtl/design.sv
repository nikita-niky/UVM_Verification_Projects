module fixed_arbiter (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [3:0] req,
    output logic [3:0] gnt
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      gnt <= 4'b0000;
    end else begin
    
      if      (req[0]) gnt <= 4'b0001; 
      else if (req[1]) gnt <= 4'b0010;
      else if (req[2]) gnt <= 4'b0100;
      else if (req[3]) gnt <= 4'b1000;
      else             gnt <= 4'b0000;
    end
  end

endmodule

bind fixed_arbiter arbiter_assertion chk(
  .clk(clk),
  .rst_n(rst_n),
  .req(req),
  .gnt(gnt)
);