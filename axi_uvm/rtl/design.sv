module axi_slave #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 16,
  parameter STRB_WIDTH = (DATA_WIDTH/8),
  parameter ID_WIDTH = 8
)(
  input logic clk,
  input logic rst,

  // Write Address Channel
  input logic [ID_WIDTH-1:0]   awid,
  input logic [ADDR_WIDTH-1:0] awaddr,
  input logic [7:0]            awlen,
  input logic [2:0]            awsize,
  input logic [1:0]            awburst,
  input logic                  awlock,
  input logic [3:0]            awcache,
  input logic [2:0]            awprot,
  input logic                  awvalid,
  output logic                 awready,

  // Write Data Channel
  input logic [DATA_WIDTH-1:0] wdata,
  input logic [STRB_WIDTH-1:0] wstrb,
  input logic                  wlast,
  input logic                  wvalid,
  output logic                 wready,

  // Write Response Channel
  output logic [ID_WIDTH-1:0] bid,
  output logic [1:0]          bresp,
  output logic                bvalid,
  input logic                 bready,

  // Read Address Channel
  input logic [ID_WIDTH-1:0]    arid,
  input logic [ADDR_WIDTH-1:0]  araddr,
  input logic [7:0]             arlen,
  input logic [2:0]             arsize,
  input logic [1:0]             arburst,
  input logic                   arlock,
  input logic [3:0]             arcache,
  input logic [2:0]             arprot,
  input logic                   arvalid,
  output logic                  arready,

  // Read Data Channel
  output logic [ID_WIDTH-1:0]     rid,
  output logic [DATA_WIDTH-1:0]   rdata,
  output logic [1:0]              rresp,
  output logic                    rlast,
  output logic                    rvalid,
  input logic                     rready
);

  localparam int BYTE_WIDTH = 8;
  localparam logic [ADDR_WIDTH-1:0] MEM_LIMIT = 16'h4000;

  // --- State Machines ---
  typedef enum logic { R_IDLE, R_DATA } read_state_e;
  typedef enum logic [1:0] { W_IDLE, W_DATA, W_RESP } write_state_e;
  typedef logic [ADDR_WIDTH-1:0] addr_t;

  write_state_e w_state;
  read_state_e r_state;

  // --- Registers ---
  logic [ID_WIDTH-1:0]    w_id_reg;
  logic [ADDR_WIDTH-1:0]  w_addr_reg;
  logic [7:0]             w_count_reg;
  logic [7:0]             w_len_orig_reg;
  logic [2:0]             w_size_reg;
  logic [1:0]             w_burst_reg;

  logic [ID_WIDTH-1:0]    r_id_reg;
  logic [ADDR_WIDTH-1:0]  r_addr_reg;
  logic [7:0]             r_count_reg;
  logic [7:0]             r_len_orig_reg;
  logic [2:0]             r_size_reg;
  logic [1:0]             r_burst_reg;
  logic [1:0]             w_resp_reg;
  logic                   r_addr_invalid_reg;
  logic [1:0]             r_resp_local;

  // Memory array: Split into byte-lanes to reliably infer true hardware BRAM
  logic [BYTE_WIDTH-1:0] mem_lane [STRB_WIDTH-1:0][0:(2**ADDR_WIDTH)/STRB_WIDTH-1];


  // --- Standard-Compliant AXI Address Calculator ---
  function automatic logic [ADDR_WIDTH-1:0] get_next_addr(
    input logic [ADDR_WIDTH-1:0] cur,
    input logic [2:0] sz,
    input logic [1:0] brst,
    input logic [7:0] original_len
  );
    logic [ADDR_WIDTH-1:0] bytes;
    logic [ADDR_WIDTH-1:0] mask;
    logic [ADDR_WIDTH-1:0] aligned;
    logic [ADDR_WIDTH-1:0] wrap_mask;
    int burst_bytes;

    bytes = 1 << sz;
    mask = ~(bytes - 1);
    aligned = cur & mask;

    if (brst == 2'b00) return cur; // FIXED

    if (brst == 2'b10) begin // WRAP
      burst_bytes = bytes * (int'(original_len) + 1);

      wrap_mask = addr_t'(burst_bytes - 1);

      if (((aligned + bytes) & ~wrap_mask) != (aligned & ~wrap_mask)) begin
        return (aligned + bytes) - addr_t'(burst_bytes);
      end
      return aligned + bytes;
    end

    return aligned + bytes; // INCR
  endfunction


  // ==========================================================================
  // WRITE CHANNEL
  // ==========================================================================
  assign bresp = w_resp_reg;

  always_ff @(posedge clk) begin
    if (rst) begin
      w_state     <= W_IDLE;
      awready     <= 1'b0;
      wready      <= 1'b0;
      bvalid      <= 1'b0;
      bid         <= '0;
      w_resp_reg  <= 2'b00;
      w_count_reg <= '0;
    
      for (int lane = 0; lane < STRB_WIDTH; lane++) begin
        for (int idx = 0; idx < (2**ADDR_WIDTH)/STRB_WIDTH; idx++) begin
          mem_lane[lane][idx] = 8'h00; // Clear hardware cells to prevent 'hxx data drops
        end
      end
      
    end else begin
      case (w_state)
        W_IDLE: begin
          awready <= 1'b1;
          wready  <= 1'b0;
          if (awvalid && awready) begin
            w_id_reg       <= awid;
            w_addr_reg     <= awaddr;
            w_count_reg    <= awlen;
            w_len_orig_reg <= awlen;
            w_size_reg     <= awsize;
            w_burst_reg    <= awburst;
            w_resp_reg     <= (awaddr >= MEM_LIMIT) ? 2'b11 : 2'b00;
            awready        <= 1'b0;
            wready         <= 1'b1;
            w_state        <= W_DATA;
          end
        end

        W_DATA: begin
          if (wvalid && wready) begin
            logic [ADDR_WIDTH-1:0] aligned_word_addr;
            aligned_word_addr = w_addr_reg & ~((1 << w_size_reg) - 1);

            if (w_addr_reg >= MEM_LIMIT) begin
              w_resp_reg <= 2'b11;
            end

            if ((w_resp_reg != 2'b11) && (w_addr_reg < MEM_LIMIT)) begin
              automatic logic [ADDR_WIDTH-$clog2(STRB_WIDTH)-1:0] word_idx = aligned_word_addr >> $clog2(STRB_WIDTH);
              for (int i = 0; i < STRB_WIDTH; i++) begin
                if (wstrb[i]) begin
                  mem_lane[i][word_idx] <= wdata[(i*BYTE_WIDTH) +: BYTE_WIDTH];
                end
              end
            end

            w_addr_reg <= get_next_addr(w_addr_reg, w_size_reg, w_burst_reg, w_len_orig_reg);

            if (w_count_reg == 0) begin
              wready  <= 1'b0;
              bid     <= w_id_reg;
              bvalid  <= 1'b1;
              w_state <= W_RESP;
            end else begin
              w_count_reg <= w_count_reg - 1;
            end
          end
        end

        W_RESP: begin
          if (bready && bvalid) begin
            bvalid  <= 1'b0;
            awready <= 1'b1;
            w_state <= W_IDLE;
          end
        end
      endcase
    end
  end

  // ==========================================================================
  // READ CHANNEL ==========================================================================
  assign rresp = r_resp_local;
  assign rid   = r_id_reg;

  logic [ADDR_WIDTH-1:0] r_ram_addr;
  assign r_ram_addr = (r_state == R_IDLE) ? araddr : r_addr_reg;

  logic [DATA_WIDTH-1:0] ram_data_out;

  // Gated Synchronous Memory Block (Infers Block RAM cleanly)
  always_ff @(posedge clk) begin
    if ((r_state == R_IDLE && arvalid && arready) || (r_state == R_DATA && rready && rvalid)) begin
        
      automatic logic [ADDR_WIDTH-1:0] aligned_read = r_ram_addr & ~((1 << (r_state == R_IDLE ? arsize : r_size_reg)) - 1);
        
      automatic logic [ADDR_WIDTH-$clog2(STRB_WIDTH)-1:0] word_idx = aligned_read >> $clog2(STRB_WIDTH);
        
      for (int i = 0; i < STRB_WIDTH; i++) begin
        ram_data_out[(i*BYTE_WIDTH) +: BYTE_WIDTH] <= mem_lane[i][word_idx];
        
      end
    end
  end

  assign rdata = (!r_addr_invalid_reg) ? ram_data_out : '0;

  always_ff @(posedge clk) begin
    if (rst) begin
      r_state            <= R_IDLE;
      arready            <= 1'b0;
      rvalid             <= 1'b0;
      rlast              <= 1'b0;
      r_id_reg           <= '0;
      r_resp_local       <= 2'b00;
      r_count_reg        <= '0;
      r_addr_reg         <= '0;
      r_addr_invalid_reg <= 1'b0;
    end else begin
      case (r_state)
        R_IDLE: begin
          arready <= 1'b1;
          if (arvalid && arready) begin
            r_id_reg           <= arid;
            r_count_reg        <= arlen;
            r_len_orig_reg     <= arlen;
            r_size_reg         <= arsize;
            r_burst_reg        <= arburst;
            r_addr_invalid_reg <= (araddr >= MEM_LIMIT);
            arready            <= 1'b0;

            r_addr_reg         <= get_next_addr(araddr, arsize, arburst, arlen);
            r_resp_local       <= (araddr >= MEM_LIMIT) ? 2'b11 : 2'b00;
            rvalid             <= 1'b1;
            rlast              <= (arlen == 0);
            r_state            <= R_DATA;
          end
        end

        R_DATA: begin
          if (rvalid && rready) begin
            if (rlast) begin
              rvalid             <= 1'b0;
              rlast              <= 1'b0;
              r_addr_invalid_reg <= 1'b0;
              arready            <= 1'b1;
              r_state            <= R_IDLE;
            end else begin
              logic [ADDR_WIDTH-1:0] next_addr;
              next_addr          = get_next_addr(r_addr_reg, r_size_reg, r_burst_reg, r_len_orig_reg);
              r_addr_reg         <= next_addr;

               r_addr_invalid_reg <= (next_addr >= MEM_LIMIT);
              r_resp_local       <= (next_addr >= MEM_LIMIT) ? 2'b11 : 2'b00;

              rvalid             <= 1'b1;
              rlast              <= (r_count_reg == 1);
              r_count_reg        <= r_count_reg - 1;
            end
          end
        end
      endcase
    end
  end

endmodule



bind axi_slave axi_assertions checker_inst (
  .clk(clk),
  .rst(rst),
  
  .awid(awid),
  .awaddr(awaddr),
  .awlen(awlen),
  .awsize(awsize),
  .awburst(awburst),
  .awvalid(awvalid),
  .awready(awready),
  
  .wdata(wdata),
  .wstrb(wstrb),
  .wlast(wlast),
  .wvalid(wvalid),
  .wready(wready),
  
  .bid(bid),
  .bresp(bresp),
  .bvalid(bvalid),
  .bready(bready),
  
  .arid(arid),
  .araddr(araddr),
  .arlen(arlen),
  .arsize(arsize),
  .arburst(arburst),
  .arvalid(arvalid),
  .arready(arready),
  
  .rid(rid),
  .rdata(rdata),
  .rresp(rresp),
  .rlast(rlast),
  .rvalid(rvalid),
  .rready(rready)
);

