`include "sync_ptr.sv"
`include "wptr_full.sv"
`include "rptr_empty.sv"
`include "fifo_mem.sv"

module async_fifo #(
    parameter ADDR_SIZE = 4,
    parameter DATA_SIZE = 8
)(
    input  logic [DATA_SIZE-1:0] wdata,
    input  logic                 winc, wclk, wrst_n,
    input  logic                 rinc, rclk, rrst_n,
    output logic [DATA_SIZE-1:0] rdata,
    output logic                 wfull,
    output logic                 rempty
);

    logic [ADDR_SIZE-1:0] waddr, raddr;
    logic [ADDR_SIZE:0]   wptr, rptr, wq2_rptr, rq2_wptr;

    // Synchronize Read Pointer to Write Clock Domain
    sync_ptr #(ADDR_SIZE) sync_r2w (
        .clk(wclk), .rst_n(wrst_n), .ptr_in(rptr), .ptr_out(wq2_rptr)
    );

    // Synchronize Write Pointer to Read Clock Domain
    sync_ptr #(ADDR_SIZE) sync_w2r (
        .clk(rclk), .rst_n(rrst_n), .ptr_in(wptr), .ptr_out(rq2_wptr)
    );

    // Dual-Port Memory
    fifo_mem #(ADDR_SIZE, DATA_SIZE) mem (.*);

    // Read Logic & Empty Flag
    rptr_empty #(ADDR_SIZE) rlogic (.*);

    // Write Logic & Full Flag
    wptr_full #(ADDR_SIZE) wlogic (.*);

endmodule


// Bind Top-Level
  bind async_fifo fifo_top_sva #(ADDR_SIZE, DATA_SIZE) u_top_sva (.*);

  // Bind Sync Pointers (This binds to BOTH instances automatically)
  bind sync_ptr fifo_sync_ptr_sva #(ADDR_SIZE) u_sync_sva (.*);

  // Bind Write Logic
  bind wptr_full wptr_full_sva #(ADDR_SIZE) u_wptr_sva (.*);

  // Bind Read Logic
  bind rptr_empty rptr_empty_sva #(ADDR_SIZE) u_rptr_sva (.*);

  // Bind Memory
  bind fifo_mem fifo_mem_sva #(ADDR_SIZE, DATA_SIZE) u_mem_sva (.*);

