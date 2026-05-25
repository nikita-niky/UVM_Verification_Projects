/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

interface fifo_if (input logic wclk, input logic rclk);

  parameter DATA_SIZE = 8;

  ///Write Domain signals
  logic wrst_n;
  logic [DATA_SIZE-1:0] wdata;
  logic winc;
  logic wfull;
  
  //Read Domain Signals
  logic rrst_n;  
  logic [DATA_SIZE-1:0] rdata; 
  logic rinc;
  logic rempty;
  
  //-----------------
  //WRITE CLOCKING BLK
  ///-----------------
  
  clocking w_cb @(posedge wclk);
    default input #1ns output #1ns;
    output wdata, winc, wrst_n;
    input wfull;
  endclocking
  
  //--------------------
  //READ CLOCKING BLOCK
  //--------------------
  
  clocking r_cb @(posedge rclk);
    default input #1ns output #1ns;
    output rinc, rrst_n;
    input rdata, rempty;
  endclocking
  
  clocking mon_wr_cb @(posedge wclk);
    default input #1ns output #1ns;
    input wrst_n, wdata, winc, wfull;
  endclocking
  
  clocking mon_rd_cb @(posedge rclk);
    default input #1ns output #1ns;
    input rrst_n, rdata, rinc, rempty;
  endclocking
  
    modport W_DRV (clocking w_cb, input wclk);
    modport R_DRV (clocking r_cb, input rclk);
            
    modport W_MON (clocking mon_wr_cb, input wclk );
    modport R_MON (clocking mon_rd_cb, input rclk );
   
endinterface
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
