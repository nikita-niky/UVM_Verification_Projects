package mux_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "sequence_item.sv"
//// sequences
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
    `include "mux_coverage.sv"
//     `include "assertion.sv"

    `include "env.sv"

    `include "test.sv"
endpackage