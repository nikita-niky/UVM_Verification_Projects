package axi_param;
 
    parameter DATA_WIDTH = 32;    
    parameter ADDR_WIDTH = 16;
	parameter STRB_WIDTH = (DATA_WIDTH/8);  
    parameter ID_WIDTH = 8;
	typedef enum {READ,WRITE} op_e;

endpackage

package axi_pkg;
    import uvm_pkg::*;
    import axi_param::*;

    `include "uvm_macros.svh"

    `include "seq_item.sv"
    /// sequences
    `include "sequence1.sv"
    `include "sequence2.sv"
	`include "sequence3.sv"
	`include "sequence4.sv"
	`include "sequence5.sv"
    `include "sequence6.sv"
    `include "sequence7.sv"
    `include "sequence8.sv"
	`include "master_seq.sv"

    `include "sequencer.sv"

	`include "driver.sv"
    `include "monitor.sv"
    `include "scoreboard.sv"

    `include "agent.sv"
    `include "axi_coverage.sv"

    `include "env.sv"

    `include "test.sv"
endpackage