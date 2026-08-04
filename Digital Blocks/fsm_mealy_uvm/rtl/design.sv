/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module fsm_mealy (
    input  logic clk,
    input  logic rst_n,
    input  logic bit_in,
    output logic pattern_found
);

  typedef enum logic [1:0] {
        IDLE = 2'b00,
        S1   = 2'b01, // Found '1'
        S10  = 2'b10, // Found '10'
        S101 = 2'b11  // Found '101'
    } state_t;
  
    state_t current_state, next_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

// coding style chnaged in order to have knowledge of both style
    always_comb begin
       
        next_state = current_state;
        pattern_found = 1'b0;

        case (current_state)
            IDLE: begin
                if (bit_in) next_state = S1;
                else        next_state = IDLE;
            end

            S1: begin
                if (bit_in) next_state = S1;
                else        next_state = S10;
            end

            S10: begin
                if (bit_in) next_state = S101;
                else        next_state = IDLE;
            end

            S101: begin
                if (bit_in) begin
                    pattern_found = 1'b1; // Logic: 101 + '1' = 1011 (Success!)
                    next_state = S1;      // Overlapping: last '1' is first of next seq
                end else begin
                    pattern_found = 1'b0;
                    next_state = S10;     // Overlapping: 101 + '0' = 10 (Valid suffix)
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule

bind fsm_mealy fsm_assertion chk(
  .clk(clk),
  .rst_n(rst_n),
  .bit_in(bit_in),
  .pattern_found(pattern_found),
  .current_state(dut.current_state)
);
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
