/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

package fsm_enum;
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S1   = 2'b01, // Found '1'
        S10  = 2'b10, // Found '10'
        S101 = 2'b11  // Found '101'
    } state_t;
endpackage

package fsm_pkg;
    import uvm_pkg::*;
	import fsm_enum::*;

    `include "uvm_macros.svh"

    `include "seq_item.sv"
    /// sequences
    `include "sequence1.sv"
    `include "sequence2.sv"
	`include "sequence3.sv"
	`include "sequence4.sv"
	`include "master_seq.sv"

    `include "sequencer.sv"

	`include "driver.sv"
    `include "monitor.sv"
    `include "scoreboard.sv"

    `include "agent.sv"
    `include "fsm_coverage.sv"


    `include "env.sv"

    `include "test.sv"
endpackage
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
