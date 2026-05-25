/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module fifo_mem #(
    parameter ADDR_SIZE = 4,
    parameter DATA_SIZE = 8
)(
    input  logic                 wclk, winc, wfull,rclk,rrst_n,rinc,rempty,
    input  logic [ADDR_SIZE-1:0] waddr, raddr,
    input  logic [DATA_SIZE-1:0] wdata,
    output logic [DATA_SIZE-1:0] rdata
);
    localparam DEPTH = 1 << ADDR_SIZE;
    logic [DATA_SIZE-1:0] mem [DEPTH];

//     assign rdata = mem[raddr];
     always_ff @(posedge rclk or negedge rrst_n) begin
      if(!rrst_n) begin
        rdata <=0;
      end
      else if (rinc && !rempty) begin
        rdata <= mem[raddr];
      end
    end
  

    always_ff @(posedge wclk) begin
        if (winc && !wfull) 
          mem[waddr] <= wdata;
    end
endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
