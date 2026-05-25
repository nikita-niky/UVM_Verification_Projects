/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

package fifo_params_pkg;

	parameter DEPTH = 16;
    parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = $clog2(DEPTH); 

    typedef logic [DATA_WIDTH-1:0] fifo_data;
    typedef logic [$clog2(DEPTH)-1:0] fifo_ptr;
    typedef logic [$clog2(DEPTH):0] fifo_count;

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
	`include "master_seq.sv"

    `include "sequencer.sv"

	`include "driver.sv"
    `include "monitor.sv"
    `include "scoreboard.sv"

    `include "agent.sv"
    `include "fifo_coverage.sv"


    `include "env.sv"

    `include "test.sv"
endpackage
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
