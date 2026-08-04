/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

interface apb_if(input logic pclk);
  
  parameter ADDR_SIZE = 32;
  parameter DATA_SIZE = 32;

  logic preset_n;
  logic [ADDR_SIZE-1:0] paddr;
  logic                 psel;
  logic                 penable;
  logic                 pwrite;
  logic [DATA_SIZE-1:0] pwdata;
  logic [DATA_SIZE-1:0] prdata;
  logic                 pready;
  logic                 pslverr;
  
  logic [31:0] addr_in;
  logic [31:0] data_in;
  logic        write_en;
  logic        transfer;
  
  
  clocking cb_m @(posedge pclk);
    default input #1ns output #1ns;
    input paddr, psel, penable, pwrite, pwdata, prdata, pready , pslverr;
    output addr_in, data_in, write_en, transfer;
  endclocking
  
  
  clocking mon_cb @(posedge pclk);
    default input #1ns output #1ns;
    input paddr, psel, penable, pwrite, pwdata,  prdata, pready, pslverr;
  endclocking
  
  modport MASTER(output addr_in, data_in, write_en, transfer, input pclk, preset_n);
  modport MON(clocking mon_cb, input pclk, preset_n);
  

endinterface
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */