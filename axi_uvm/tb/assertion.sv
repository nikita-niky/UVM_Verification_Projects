/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module axi_assertions #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16,
    parameter ID_WIDTH = 8
)(
    input logic clk,
    input logic rst,

    // Write Address Channel
    input logic [ID_WIDTH-1:0] awid,
    input logic [ADDR_WIDTH-1:0] awaddr,
    input logic [7:0] awlen,
    input logic [2:0] awsize,
    input logic [1:0] awburst,
    input logic awvalid,
    input logic awready,

    // Write Data Channel
    input logic [DATA_WIDTH-1:0] wdata,
    input logic [(DATA_WIDTH/8)-1:0] wstrb,
    input logic wlast,
    input logic wvalid,
    input logic wready,

    // Write Response Channel
    input logic [ID_WIDTH-1:0] bid,
    input logic [1:0] bresp,
    input logic bvalid,
    input logic bready,

    // Read Address Channel
    input logic [ID_WIDTH-1:0] arid,
    input logic [ADDR_WIDTH-1:0] araddr,
    input logic [7:0] arlen,
    input logic [2:0] arsize,
    input logic [1:0] arburst,
    input logic arvalid,
    input logic arready,

    // Read Data Channel
    input logic [ID_WIDTH-1:0] rid,
    input logic [DATA_WIDTH-1:0] rdata,
    input logic [1:0] rresp,
    input logic rlast,
    input logic rvalid,
    input logic rready
);

    // Default clocking context for synchronous properties
    default clocking AXI_CLK @(posedge clk); endclocking

    // ==========================================================================
    // RULE 1: HANDSHAKE STABILITY (Valid & Payload must lock until Ready asserts)
    // ==========================================================================

    
    property p_awvalid_stable;
        ($past(awvalid) && !$past(awready) && awvalid) -> 
        $stable({awid, awaddr, awlen, awsize, awburst});
    endproperty
    assert_awvalid_stable: assert property (disable iff (rst) p_awvalid_stable)
        else $error("AXI_SVA_AW_STABLE: AW payload changed before AWREADY handshake! @ %0t", $time);

    property p_wvalid_stable;
        ($past(wvalid) && !$past(wready) && wvalid) -> 
        $stable({wdata, wstrb, wlast});
    endproperty
    assert_wvalid_stable: assert property (disable iff (rst) p_wvalid_stable)
        else $error("AXI_SVA_W_STABLE: W payload changed before WREADY handshake! @ %0t", $time);

    property p_arvalid_stable;
        ($past(arvalid) && !$past(arready) && arvalid) -> 
        $stable({arid, araddr, arlen, arsize, arburst});
    endproperty
    assert_arvalid_stable: assert property (disable iff (rst) p_arvalid_stable)
        else $error("AXI_SVA_AR_STABLE: AR payload changed before ARREADY handshake! @ %0t", $time);

    property p_bvalid_stable;
        ($past(bvalid) && !$past(bready) && bvalid) -> 
        $stable({bid, bresp});
    endproperty
    assert_bvalid_stable: assert property (disable iff (rst) p_bvalid_stable)
        else $error("AXI_SVA_B_STABLE: BVALID or payload changed before BREADY handshake! @ %0t", $time);

    property p_rvalid_stable;
        ($past(rvalid) && !$past(rready) && rvalid) -> 
        $stable({rid, rdata, rresp, rlast});
    endproperty
    assert_rvalid_stable: assert property (disable iff (rst) p_rvalid_stable)
        else $error("AXI_SVA_R_STABLE: RVALID or payload changed before RREADY handshake! @ %0t", $time);


    // ==========================================================================
    // RULE 2: ILLEGAL BURST TYPE CONSTRAINTS (AXI4 forbids 2'b11)
    // ==========================================================================
      
    property p_awburst_legal;
        awvalid |-> awburst != 2'b11;
    endproperty
    assert_awburst_legal: assert property (disable iff (rst) p_awburst_legal)
        else $error("AXI_SVA_AW_BURST: Illegal AWBURST type 2'b11 detected! @ %0t", $time);

    property p_arburst_legal;
        arvalid |-> arburst != 2'b11;
    endproperty
    assert_arburst_legal: assert property (disable iff (rst) p_arburst_legal)
        else $error("AXI_SVA_AR_BURST: Illegal ARBURST type 2'b11 detected! @ %0t", $time);


    // ==========================================================================
    // RULE 3: WRAP BURST SPECIFIC ALIGNMENT RULES
    // ==========================================================================
      
    property p_aw_wrap_len_legal;
        awvalid && (awburst == 2'b10) |-> (awlen == 8'd1 || awlen == 8'd3 || awlen == 8'd7 || awlen == 8'd15);
    endproperty
    assert_aw_wrap_len_legal: assert property (disable iff (rst) p_aw_wrap_len_legal)
        else $error("AXI_SVA_AW_WRAP_LEN: AXI WRAP Write burst length must be 2, 4, 8, or 16 beats! @ %0t", $time);

    property p_ar_wrap_len_legal;
        arvalid && (arburst == 2'b10) |-> (arlen == 8'd1 || arlen == 8'd3 || arlen == 8'd7 || arlen == 8'd15);
    endproperty
    assert_ar_wrap_len_legal: assert property (disable iff (rst) p_ar_wrap_len_legal)
        else $error("AXI_SVA_AR_WRAP_LEN: AXI WRAP Read burst length must be 2, 4, 8, or 16 beats! @ %0t", $time);


    // ==========================================================================
    // RULE 4: DATA CONTAINER SIZE CHECK
    // ==========================================================================
      
    property p_awsize_legal;
        awvalid |-> (1 << awsize) <= (DATA_WIDTH / 8);
    endproperty
    assert_awsize_legal: assert property (disable iff (rst) p_awsize_legal)
        else $error("AXI_SVA_AW_SIZE: AWSIZE configuration exceeds data bus byte width! @ %0t", $time);

    property p_arsize_legal;
        arvalid |-> (1 << arsize) <= (DATA_WIDTH / 8);
    endproperty
    assert_arsize_legal: assert property (disable iff (rst) p_arsize_legal)
        else $error("AXI_SVA_AR_SIZE: ARSIZE configuration exceeds data bus byte width! @ %0t", $time);


    // ==========================================================================
    // RULE 5: RESET DE-ASSERTION AND INITIALIZATION
    // ==========================================================================
    // Master Valids must be low when reset is active
      
    property p_reset_clean_master;
        rst |-> (awvalid == 1'b0 && wvalid == 1'b0 && arvalid == 1'b0);
    endproperty
    assert_reset_clean_master: assert property (@(posedge clk) p_reset_clean_master)
        else $error("AXI_SVA_RST_MASTER: Master driven valid high while reset active! @ %0t", $time);

    property p_reset_clean_slave;
        rst |=> (bvalid == 1'b0 && rvalid == 1'b0);
    endproperty
    assert_reset_clean_slave: assert property (@(posedge clk) p_reset_clean_slave)
        else $error("AXI_SVA_RST_SLAVE: Slave driven valid high during/immediately after reset! @ %0t", $time);


    // ==========================================================================
    // CRITICAL ADDITION RULE 6: WRITE STROBE VALIDATION
    // ==========================================================================
      
    // AXI Spec mandates that when WVALID is low, WSTRB can be anything, but when 
    // WVALID is high, it is illegal to assert strobe bits outside the bus limits.
      
    property p_wstrb_bounds;
        wvalid |-> (wstrb >> (DATA_WIDTH/8)) == '0;
    endproperty
    assert_wstrb_bounds: assert property (disable iff (rst) p_wstrb_bounds)
        else $error("AXI_SVA_WSTRB_BOUNDS: WSTRB asserts bits out of bus parameter dimensions! @ %0t", $time);

endmodule

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
