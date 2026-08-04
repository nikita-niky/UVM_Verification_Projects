/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module apb_master #(parameter ADDR_SIZE = 32,
                    parameter DATA_SIZE = 32)(
  
  input  logic                 PCLK,
  input  logic                 PRESETn,
  
  input  logic                 transfer,   // Trigger from system
  input  logic [ADDR_SIZE-1:0] addr_in,
  input  logic [DATA_SIZE-1:0] data_in,
  input  logic                 write_en,

  // APB Interface
  output logic [ADDR_SIZE-1:0] PADDR,
  output logic                 PSEL,
  output logic                 PENABLE,
  output logic                 PWRITE,
  output logic [DATA_SIZE-1:0] PWDATA,
  input  logic [DATA_SIZE-1:0] PRDATA,
  input  logic                 PREADY
);

  typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state_t;
  state_t state, next_state;

  // State Transition
  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) state <= IDLE;
    else          state <= next_state;
  end

  // Next State Logic
  always_comb begin
    case (state)
      IDLE:   next_state = transfer ? SETUP : IDLE;
      SETUP:  next_state = ACCESS;
      ACCESS: next_state = PREADY   ? (transfer? SETUP: IDLE) : ACCESS;
      default: next_state = IDLE;
    endcase
  end

  // Output Logic
  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      PSEL    <= 0;
      PENABLE <= 0;
      PADDR   <= 0;
      PWRITE  <= 0;
      PWDATA  <= 0;
    end 
    else begin
      
      case (next_state)
        
        IDLE: begin
          PSEL    <= 0;
          PENABLE <= 0;
        end
        
        SETUP: begin
          PSEL    <= 1;
          PENABLE <= 0;
          PADDR   <= addr_in;
          PWRITE  <= write_en;
          PWDATA  <= data_in;
        end
        
        ACCESS: begin
          PSEL    <= 1;
          PENABLE <= 1;
        end
        
      endcase
    end
  end
endmodule


bind apb_master apb_master_sva ckh_master(
  
  .PCLK(PCLK),
  .PRESETn(PRESETn),
  .transfer(transferr),
  .addr_in(addr_in),
  .data_in(data_in),
  .write_en(write_en),
  .PADDR(PADDR),
  .PSEL(PSEL),
  .PENABLE(PENABLE),
  .PWRITE(PWRITE),
  .PWDATA(PWDATA),
  .PRDATA(PRDATA),                   
  .PREADY(PREADY)
);

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */