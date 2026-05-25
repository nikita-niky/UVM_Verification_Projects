/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

package apb_params_pkg;

	parameter ADDR_SIZE = 32;
	parameter DATA_SIZE = 32;

endpackage

package apb_pkg;
    import uvm_pkg::*;
	import apb_params_pkg::*;
    `include "uvm_macros.svh"

    `include "seq_item.sv"
    /// sequences
	`include "sequence.sv"
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
    `include "apb_coverage.sv"


    `include "env.sv"

    `include "test.sv"

endpackage
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
