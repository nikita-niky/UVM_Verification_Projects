module univ_sr (
    input  logic       clk,
    input  logic       rst,      // Synchronous Reset
    input  logic [1:0] mode,// 00: Hold, 01: Shift Right, 10: Shift Left, 11: Parallel Load
    input  logic       sin_left, // Serial input for Shift Right (enters at MSB)
    input  logic       sin_right,// Serial input for Shift Left (enters at LSB)
    input  logic [3:0] d_in,     // Parallel Data Input
    output logic [3:0] q_out     // Parallel Data Output
);

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      q_out <= 4'b0000;
    end else begin
      case (mode)
        2'b00: q_out <= q_out;                   // Hold
        2'b01: q_out <= {sin_left, q_out[3:1]};  // Shift Right (Serial in to MSB)
        2'b10: q_out <= {q_out[2:0], sin_right}; // Shift Left (Serial in to LSB)
        2'b11: q_out <= d_in;                    // Parallel Load
        default: q_out <= q_out;
      endcase
    end
  end

endmodule


bind univ_sr univ_sr_assertion check_inst(
  .clk(clk),
  .rst(rst),
  .mode(mode),
  .sin_left(sin_left),
  .sin_right(sin_right),
  .d_in(d_in),
  .q_out(q_out)
);