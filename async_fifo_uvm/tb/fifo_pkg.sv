/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

package fifo_params_pkg;
  parameter ADDR_SIZE = 4;
  parameter DATA_SIZE = 8;
parameter DEPTH = 2 ** ADDR_SIZE; /// in this case it should be 16

  typedef logic [DATA_SIZE-1:0] f_data;
  typedef logic [ADDR_SIZE-1:0] f_addr;
  typedef logic [ADDR_SIZE:0]   f_ptr;

endpackage

package fifo_pkg;
    import uvm_pkg::*;
	import fifo_params_pkg::*;

    `include "uvm_macros.svh"

    `include "seq_item.sv"
    /// sequences
    `include "sequence1.sv"
    `include "sequence2.sv"
	`include "sequence3.sv"
	`include "sequence4.sv"
	`include "sequence5.sv"
	`include "sequence6.sv"

    `include "sequencer.sv"

	`include "wr_driver.sv"
	
    `include "wr_monitor.sv"
	`include "rd_driver.sv"
    `include "rd_monitor.sv"
    `include "scoreboard.sv"

    `include "wr_agent.sv"
	`include "rd_agent.sv"

    `include "fifo_coverage.sv"


    `include "env.sv"

    `include "test_1.sv"
	`include "test_2.sv"
	`include "test_3.sv"
	`include "test_4.sv"
	`include "test_5.sv"
	`include "test_6.sv"
endpackage

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
