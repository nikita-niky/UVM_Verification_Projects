module fsm_moore (
    input  logic clk,
    input  logic rst_n,
    input  logic bit_in,
    output logic pattern_found
);

    typedef enum logic [2:0] {
        IDLE  = 3'b000,
        S1    = 3'b001,
        S10   = 3'b010,
        S101  = 3'b011,
        S1011 = 3'b100
    } state_t;

    state_t current_state, next_state;

   
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= IDLE;
        else        current_state <= next_state;
    end

  
    always_comb begin
        next_state = current_state;
        pattern_found = 1'b0;

        case (current_state)
            IDLE:  next_state = bit_in ? S1   : IDLE;
            S1:    next_state = bit_in ? S1   : S10;
            S10:   next_state = bit_in ? S101 : IDLE;
            S101:  next_state = bit_in ? S1011: S10;
            S1011: begin
                pattern_found = 1'b1;
                next_state = bit_in ? S1 : IDLE; // Non-overlapping
            end
            default: next_state = IDLE;
        endcase
    end
endmodule


bind fsm_moore fsm_assertion chk(
  .clk(clk),
  .rst_n(rst_n),
  .bit_in(bit_in),
  .pattern_found(pattern_found),
  .current_state(dut.current_state)
);