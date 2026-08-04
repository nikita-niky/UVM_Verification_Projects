/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

`include "apb_master.sv"
`include "apb_slave.sv"

module apb_system_top #(parameter ADDR_SIZE = 32,
                        parameter DATA_SIZE = 32)
  (
    input logic clk, 
    input logic rst_n,
    
    input logic                 transfer,
    input logic [ADDR_SIZE-1:0] addr_in,
    input logic [DATA_SIZE-1:0] data_in,
    input logic                 write_en
  );

  // Internal Wires (The Bus)
  logic [ADDR_SIZE-1:0] paddr, pwdata, prdata;
  logic psel, penable, pwrite, pready, pslverr;

  // Instantiate Master
  apb_master master_inst (
    .PCLK(clk), .PRESETn(rst_n), .transfer(transfer), .addr_in(addr_in),.data_in(data_in),.write_en(write_en),.PADDR(paddr), .PSEL(psel), .PENABLE(penable),.PWRITE(pwrite),.PWDATA(pwdata), .PRDATA(prdata), .PREADY(pready)
  );

  // Instantiate Slave
  apb_slave slave_inst (
    .PCLK(clk), .PRESETn(rst_n),
    .PADDR(paddr), .PSEL(psel), .PENABLE(penable), .PWRITE(pwrite), .PWDATA(pwdata), .PRDATA(prdata), .PREADY(pready), .PSLVERR(pslverr)
  );

endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
