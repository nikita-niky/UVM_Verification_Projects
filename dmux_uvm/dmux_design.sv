module demux_1to4 (
  input  logic [31:0] d,
  input  logic [1:0]  sel,
  output logic [31:0] y [0:3],
  input logic clk,
  input logic rst_n
);
  
 always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            y <= '{default: 32'h0};
        end else begin
          	 y <= '{default: 32'h0};
          	 y[sel] <= d;
        end
    end
  
endmodule

bind demux_1to4 demux_assertion check_inst (
    .d(d),
    .sel(sel),
    .clk(clk),
    .rst_n(rst_n),
    .y(y)
);