package arbiter_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "seq_item.sv"
    /// sequences
	`include "sequencer.sv"
    `include "sequence1.sv"
    `include "sequence2.sv"
	`include "sequence3.sv"
	`include "sequence4.sv"
	`include "master_seq.sv"

    

	`include "driver.sv"
    `include "monitor.sv"
    `include "scoreboard.sv"

    `include "agent.sv"
    `include "arbiter_coverage.sv"


    `include "env.sv"

    `include "test.sv"
endpackage