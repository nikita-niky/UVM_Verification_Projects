module sync_fifo #(
    parameter DEPTH = 16,
    parameter DATA_WIDTH = 8
)(
  input  logic                   clk,
  input  logic                   rst_n,

  // Write Interface
  input  logic                   wr_en,
  input  logic [DATA_WIDTH-1:0]  wdata,

  // Read Interface
  input  logic                   rd_en,
  output logic [DATA_WIDTH-1:0]  rdata, 

  // Status Flags
  output logic                   full,
  output logic                   empty
);

    // Internal Memory and Pointers
  logic [DATA_WIDTH-1:0] mem [DEPTH]; 
  logic [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr;  
  logic [$clog2(DEPTH):0] count; 

    // 1. Write Logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr] <= wdata;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // 2. Read Logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
        end else if (rd_en && !empty) begin
            rdata  <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    // 3. Counter Logic (To handle Status Flags)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1; // Write only
                2'b01: count <= count - 1; // Read only
                default: count <= count;   // Both or neither (no change)
            endcase
        end
    end

    // 4. Assignments
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

endmodule


bind sync_fifo fifo_assertion chk(
  .clk(clk),
  .rst_n(rst_n),
  .wr_en(wr_en),
  .wdata(wdata),
  .rd_en(rd_en),
  .rdata(rdata),
  .full(full),
  .empty(empty)
);