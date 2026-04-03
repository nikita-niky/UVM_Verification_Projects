module counter (
    input  logic       clk,
    input  logic       rst,
    input  logic       load,
    input  logic       up_down,    // 1: Up, 0: Down
    input  logic [3:0] count_in,   // user specific count value,where he wantto start counting
    output logic [3:0] count,
    output logic       max_tick,   // High when count hits 15
    output logic       min_tick    // High when count hits 0
);

    // Main Counter Logic
  always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
        end
        else if (load) begin
            count <= count_in;
        end
        else begin
          if (up_down) // 1 up  0 down
                count <= count + 1'b1;
            else
                count <= count - 1'b1;
        end
    end

    // Status Flags (Combinational)
    // These are often used as "Look-ahead" signals for larger systems
    assign max_tick = (count == 4'b1111);
    assign min_tick = (count == 4'b0000);

endmodule

bind counter counter_assertion inst(
  .clk(clk),
  .rst(rst),
  .load(load),
  .up_down(up_down),
  .count_in(count_in),
  .count(count),
  .max_tick(max_tick),
  .min_tick(min_tick)
);