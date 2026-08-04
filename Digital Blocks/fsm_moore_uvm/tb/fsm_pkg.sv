/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

package fsm_enum;
  typedef enum logic [2:0] {
    IDLE  = 3'b000,
    S1    = 3'b001,
    S10   = 3'b010,
    S101  = 3'b011,
    S1011 = 3'b100
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
