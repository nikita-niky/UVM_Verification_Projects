/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class axi_item extends uvm_sequence_item;

  // --- Random Properties ---
  rand op_e                     op;
  rand logic                    rst;
  rand logic [ID_WIDTH-1:0]     id;
  rand logic [ADDR_WIDTH-1:0]   addr;
  rand logic [7:0]              len;
  rand logic [2:0]              size;
  rand logic [1:0]              burst;
  rand logic [DATA_WIDTH-1:0]   data[];
  rand logic [STRB_WIDTH-1:0]   strb[];

  // --- State Tracking Registers ---
  logic [1:0]              resp[]; 
  int                      current_beat_idx = 0;
  //   bit force_watchdog_freeze = 1'b0; 

  // ==========================================================================
  // FAST DECLARATIVE SPECIFICATION CONSTRAINTS
  // ==========================================================================
  constraint c_array_sizes { 
    data.size() == (len + 1); 
    strb.size() == (len + 1); 
  }

  constraint c_valid_size { 
    (1 << size) <= (DATA_WIDTH / 8); 
  }

  constraint c_aligned_addr { 
    soft addr % (1 << size) == 0; 
  }

  constraint burst_len_con { 
    (burst == 2'b10) -> (len inside {1, 3, 7, 15}); 
  }

  constraint c_wrap_align { 
    (burst == 2'b10) -> (addr == (addr & ~((1 << size) - 1))); 
  }

  // ==========================================================================
  // UVM FIELD UTILITY MACROS
  // ==========================================================================
  `uvm_object_utils_begin(axi_item)
  `uvm_field_enum(op_e, op, UVM_ALL_ON)
  `uvm_field_int(rst, UVM_ALL_ON)
  `uvm_field_int(id, UVM_ALL_ON)
  `uvm_field_int(addr, UVM_ALL_ON)
  `uvm_field_int(len, UVM_ALL_ON)
  `uvm_field_int(size, UVM_ALL_ON)
  `uvm_field_int(burst, UVM_ALL_ON)
  `uvm_field_array_int(data, UVM_ALL_ON)
  `uvm_field_array_int(strb, UVM_ALL_ON)
  `uvm_field_array_int(resp, UVM_ALL_ON)
  `uvm_object_utils_end

  // --- Constructor ---
  function new(string name = "axi_item");
    super.new(name);
  endfunction

  // ==========================================================================
  // PROCEDURAL LOOKAHEAD MATH GENERATOR
  // ==========================================================================
  // Resolves in microseconds by taking the heavy modulus calculations 
  // entirely out of the constraint solver's solver matrix.

  function void post_randomize();
    int bytes_per_beat = 1 << this.size;
    logic [ADDR_WIDTH-1:0] running_addr = this.addr;

    this.data = new[this.len + 1];
    this.strb = new[this.len + 1];
    this.resp = new[this.len + 1]; 

    for (int i = 0; i <= this.len; i++) begin

      logic [ADDR_WIDTH-1:0] aligned_address = running_addr & ~(STRB_WIDTH - 1);
      logic [ADDR_WIDTH-1:0] beat_start_addr = running_addr & ~((1<< this.size)-1);
      logic [ADDR_WIDTH-1:0] beat_end_addr = beat_start_addr + bytes_per_beat;

      logic [STRB_WIDTH-1:0] computed_strb = '0;
      logic [DATA_WIDTH-1:0] masked_payload = '0;
      logic [DATA_WIDTH-1:0] rand_payload = $urandom();

      // 1. Calculate active byte lane masks for this exact address step
      for (int b = 0; b < STRB_WIDTH; b++) begin

        logic [ADDR_WIDTH-1:0] byte_addr = aligned_address + b;

        if ((byte_addr >= beat_start_addr) && (byte_addr < beat_end_addr)) begin
          computed_strb[b] = 1'b1;
        end
      end
      this.strb[i] = computed_strb;

      // 2. Position payload bytes on active bus channels, zeroing inactive channels
      for (int b = 0; b < STRB_WIDTH; b++) begin
        if (computed_strb[b])
          masked_payload[(b*8) +: 8] = rand_payload[(b*8) +: 8];
        else               
          masked_payload[(b*8) +: 8] = 8'h00;
      end
      this.data[i] = masked_payload;

      this.resp[i] = 2'b00; 

      running_addr = internal_get_next_addr(running_addr, this.size, this.burst, this.len, this.addr);
    end
  endfunction


  // --- Auxiliary Internal Address Generator ---
  function automatic logic [ADDR_WIDTH-1:0] internal_get_next_addr(
    logic [ADDR_WIDTH-1:0] cur, bit [2:0] sz, bit [1:0] brst, bit [7:0] ln, logic [ADDR_WIDTH-1:0] start
  );
    int num_bytes = 1 << sz;
    logic [ADDR_WIDTH-1:0] mask = ~((1 << sz) - 1);
    logic [ADDR_WIDTH-1:0] aligned = cur & mask;

    if (brst == 2'b00) return cur; // FIXED

    if (brst == 2'b10) begin // WRAP
      int burst_bytes = num_bytes * (ln + 1);
      logic [ADDR_WIDTH-1:0] wrap_mask = ~(burst_bytes - 1);
      if (((aligned + num_bytes) & wrap_mask) != (aligned & wrap_mask)) begin
        return (aligned + num_bytes) - burst_bytes;
      end
      return aligned + num_bytes;
    end

    return aligned + num_bytes; // INCR
  endfunction

endclass

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
