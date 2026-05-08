module apb_slave #(parameter ADDR_SIZE = 32,
                   parameter DATA_SIZE = 32)
  (
    input  logic                 PCLK,
    input  logic                 PRESETn,
    input  logic [ADDR_SIZE-1:0] PADDR,
    input  logic                 PSEL,
    input  logic                 PENABLE,
    input  logic                 PWRITE,
    input  logic [DATA_SIZE-1:0] PWDATA,
    output logic [DATA_SIZE-1:0] PRDATA,
    output logic                 PREADY,
    output logic                 PSLVERR
  );


  logic [ADDR_SIZE-1:0] mem [0:15];
  
  logic addr_valid;
  
  assign addr_valid = (PADDR[ADDR_SIZE-1:6] == 0) && (PADDR[5:2] < 16);


  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      PRDATA  <= 0;
      PREADY  <= 0;
      PSLVERR <= 0;

      for(int i = 0; i<16; i++) begin
        mem[i] <= 0;
      end

    end

    else begin

      if(PSEL && !PENABLE) begin
        PREADY  <= 0;
        PSLVERR <= 0;
      end

      else if (PSEL && PENABLE) begin
        PREADY <= 1'b1;

        if(addr_valid) begin
          PSLVERR <= 1'b0;

          if (PWRITE) 
            mem[PADDR[5:2]] <= PWDATA; // Write logic
          else 
            PRDATA <= mem[PADDR[5:2]]; // Read logic
        end

        else begin
          PSLVERR <= 1'b1;
          PRDATA <= 32'hDEADBEEF;
        end
      end

      else  begin 
        PREADY  <= 0;
        PSLVERR <= 0;
      end
    end
  end

endmodule


bind apb_slave apb_slave_sva chk_slave(
  
  .PCLK(PCLK),
  .PRESETn(PRESETn),
  .PADDR(PADDR),
  .PSEL(PSEL),
  .PENABLE(PENABLE),
  .PWRITE(PWRITE),
  .PWDATA(PWDATA),
  .PRDATA(PRDATA),                   
  .PREADY(PREADY),
  .PSLVERR(PSLVERR)
);