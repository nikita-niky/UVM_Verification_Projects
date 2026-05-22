class axi_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(axi_scoreboard)

  uvm_analysis_imp#(axi_item, axi_scoreboard) recv;

  int pass_count = 0;
  int fail_count = 0;
  int resp_pass_count = 0;
  int resp_fail_count = 0;

  // --- Typdef Sanitized Associative Array Structure ---
  bit [7:0] shadow_mem[bit [ADDR_WIDTH-1:0]];
  logic [ADDR_WIDTH-1:0] MEM_LIMIT = 16'h4000;

  function new(string name = "axi_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this);
  endfunction

  virtual function void write(axi_item tr);
    logic [ADDR_WIDTH-1:0] loop_addr = tr.addr;
    bit [1:0] exp_status = (tr.addr >= MEM_LIMIT) ? 2'b11 : 2'b00;

    // ==========================================================================
    // WRITE TRANSACTION VERIFICATION
    // ==========================================================================
    if(tr.op == WRITE) begin
      `uvm_info("SCB_WR", $sformatf("Verifying WRITE -> ID: %0d | Addr: %0h | Len: %0d", tr.id, tr.addr, tr.len), UVM_HIGH)

      if(exp_status == 2'b00) begin
        for(int i=0; i <= tr.len; i++) begin
          // True AXI Specification Bus Lane Mapping Rule Formulations
          logic [ADDR_WIDTH-1:0] aligned_address = loop_addr & ~((1 << tr.size) - 1);
          int bytes_in_transfer = 1 << tr.size;
          logic [ADDR_WIDTH-1:0] bus_word_base = loop_addr & ~(STRB_WIDTH - 1);

          for(int b=0; b < STRB_WIDTH; b++) begin
            logic [ADDR_WIDTH-1:0] physical_target_byte = bus_word_base + b;

            if ((physical_target_byte >= aligned_address) && (physical_target_byte< aligned_address + bytes_in_transfer)) begin              

              if (tr.strb[i][b]) begin
                shadow_mem[physical_target_byte] = tr.data[i][(b*8) +: 8];
              end
            end
          end
          loop_addr = get_next_burst_addr(loop_addr, tr.size, tr.burst, tr.len, tr.addr);
        end
      end

      // Verify BRESP Response
      if(tr.resp[0] === exp_status) begin
        resp_pass_count++;
      end else begin
        `uvm_error("SCB_RESP_FAIL", $sformatf("WRITE BRESP MISMATCH! ID: %0d | Exp: %2b | Act: %2b", tr.id, exp_status, tr.resp[0]))
        resp_fail_count++;
      end
    end

    // ==========================================================================
    // READ TRANSACTION VERIFICATION
    // ==========================================================================
    else if(tr.op == READ) begin
      `uvm_info("SCB_RD", $sformatf("Verifying READ -> ID: %0d | Addr: %0h | Len: %0d", tr.id, tr.addr, tr.len), UVM_HIGH)
      for(int i = 0; i <= tr.len; i++) begin
        logic [DATA_WIDTH-1:0] exp_word = 0;
        bit [1:0] current_beat_exp_status = (loop_addr >= MEM_LIMIT) ? 2'b11 : 2'b00;

        if (current_beat_exp_status == 2'b00) begin
          // Fetching the full 32-bit word exactly like the simplified memory lane structure
          automatic logic [ADDR_WIDTH-1:0] base_word_addr = (loop_addr >> 2) << 2;
          for(int b=0; b < STRB_WIDTH; b++) begin
            logic [ADDR_WIDTH-1:0] target_byte_addr = base_word_addr + b;
            if (shadow_mem.exists(target_byte_addr)) exp_word[(b*8)+:8] = shadow_mem[target_byte_addr];
            else                                     exp_word[(b*8)+:8] = 8'h00;
          end
        end

        // Verify full word matching
        if(tr.data[i] === exp_word) begin
          `uvm_info("DATA_MATCH", $sformatf("READ DATA MATCH at Beat %0d! |Addr: %h| Exp: %h | Act: %h", i, loop_addr, exp_word, tr.data[i]), UVM_HIGH)
          pass_count++;
        end else begin
          `uvm_error("DATA_MISMATCH", $sformatf("READ DATA MISMATCH at Beat %0d!| Addr: %h| Exp: %h| Act: %h", i, loop_addr, exp_word, tr.data[i]))
          fail_count++;
        end

        if(tr.resp[i] === current_beat_exp_status) 
          resp_pass_count++;
        else
          `uvm_error("RESP_MISMATCH", $sformatf("RRESP MISMATCH! Exp: %2b | Act: %2b", current_beat_exp_status, tr.resp[i]))

          loop_addr = get_next_burst_addr(loop_addr, tr.size, tr.burst, tr.len, tr.addr);
      end
    end
  endfunction

  // --- Standard-Compliant Address Stepping Logic Engine ---
  function automatic logic [ADDR_WIDTH-1:0] get_next_burst_addr(
    input logic [ADDR_WIDTH-1:0] cur,
    input bit   [2:0]            sz,
    input bit   [1:0]            brst,
    input bit   [7:0]            len,
    input logic [ADDR_WIDTH-1:0] start_addr
  );
    int num_bytes = 1 << sz;
    logic [ADDR_WIDTH-1:0] mask = ~((1 << sz) - 1);
    logic [ADDR_WIDTH-1:0] aligned = cur & mask;

    if (brst == 2'b00) return cur; // FIXED

    if (brst == 2'b10) begin // WRAP
      int burst_bytes = num_bytes * (len + 1);
      logic [ADDR_WIDTH-1:0] wrap_mask = ~(burst_bytes - 1);
      if (((aligned + num_bytes) & wrap_mask) != (aligned & wrap_mask)) begin
        return (aligned + num_bytes) - burst_bytes;
      end
      return aligned + num_bytes;
    end

    return aligned + num_bytes; // INCR
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCB_SUMMARY", $sformatf("\n==========================================\n AXI IN-ORDER SCOREBOARD REPORT\n==========================================\n Data Beats Passed   : %0d\n Data Beats Failed   : %0d\n Protocol Resps OK   : %0d\n Protocol Resps Err  : %0d\n==========================================", pass_count, fail_count, resp_pass_count, resp_fail_count), UVM_LOW)
  endfunction
endclass
