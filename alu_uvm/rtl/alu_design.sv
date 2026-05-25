// ==========================================================================
// Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
// Copyright:   (c) 2026 Nikita Agrawal
// License:     MIT License (see LICENSE file in root)
// ==========================================================================

module alu (
  input  logic        clk,
  input  logic        rst,
  input  logic [3:0]  a,
  input  logic [3:0]  b,
  input  logic [2:0]  op,
  output logic [3:0]  res,   //result
  output logic        carry, // C: Unsigned Carry-out
  output logic        zero,  // Z: Zero Flag
  output logic        neg,   // N: Negative Flag (Sign bit)
  output logic        ovfl   // V: Signed Overflow Flag
);

    
    logic [4:0] full_res; // 5 bits to capture the Carry/Borrow
    logic [3:0] res_comb; // Combinational result for flag calculation

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            res   <= 4'b0;
            carry <= 1'b0;
            zero  <= 1'b0;
            neg   <= 1'b0;
            ovfl  <= 1'b0;
        end
      else begin
            case (op)
                3'b000: begin // ADD
                    full_res = a + b;
                    res      <= full_res[3:0];
                    carry    <= full_res[4];
                    // V: Positive + Positive = Negative OR Negative + Negative = Positive
                    ovfl     <= (a[3] == b[3]) && (full_res[3] != a[3]);
                end

                3'b001: begin // SUB
                    full_res = a - b;
                    res      <= full_res[3:0];
                    carry    <= full_res[4];
                    // V: Positive - Negative = Negative OR Negative - Positive = Positive
                    ovfl     <= (a[3] != b[3]) && (full_res[3] != a[3]);
                end

                3'b010: res <= a & b;  // AND
                3'b011: res <= a | b;  // OR
                3'b100: res <= a ^ b;  // XOR
                3'b101: res <= ~a;     // NOT A
                3'b110: res <= a << 1; // SHL
                3'b111: res <= a >> 1; // SHR
                default: res <= 4'b0000;
            endcase

          
            if (op == 3'b000 || op == 3'b001) begin
              zero <= (full_res[3:0] == 4'b0000);
                neg  <= full_res[3];
            end else begin
                
                carry <= 1'b0;
                ovfl  <= 1'b0;
                zero  <= (res_comb == 4'b0000); 
                neg   <= res_comb[3];
            end
        end
    end

    
    always_comb begin
        case(op)
            3'b010: res_comb = a & b;
            3'b011: res_comb = a | b;
            3'b100: res_comb = a ^ b;
            3'b101: res_comb = ~a;
            3'b110: res_comb = a << 1;
            3'b111: res_comb = a >> 1;
            default: res_comb = 4'b0;
        endcase
    end

endmodule

///connecting assertion to design

bind alu alu_assertion assert_inst(
  .clk(clk),
  .rst(rst),
  .a(a),
  .b(b),
  .op(op),
  .res(res),
  .carry(carry),
  .zero(zero),
  .neg(neg),
  .ovfl(ovfl)
);


// ==========================================================================
// Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
// Copyright:   (c) 2026 Nikita Agrawal
// License:     MIT License (see LICENSE file in root)
// ==========================================================================