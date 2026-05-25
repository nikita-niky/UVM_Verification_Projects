/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

package counter_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "seq_item.sv"
    /// sequences
    `include "sequence1.sv"
    `include "sequence2.sv"
	
	`include "master_seq.sv"

    `include "sequencer.sv"

	`include "driver.sv"
    `include "monitor.sv"
    `include "scoreboard.sv"

    `include "agent.sv"
    `include "counter_coverage.sv"


    `include "env.sv"

    `include "test.sv"
endpackage
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
