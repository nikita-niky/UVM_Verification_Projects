module sync_ptr #(parameter ADDR_SIZE = 4) (
    input  logic [ADDR_SIZE:0] ptr_in,
    input  logic               clk, rst_n,
    output logic [ADDR_SIZE:0] ptr_out
);
    logic [ADDR_SIZE:0] sync_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {ptr_out, sync_reg} <= '0;
        end else begin
            {ptr_out, sync_reg} <= {sync_reg, ptr_in};
        end
    end
endmodule