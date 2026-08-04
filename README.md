# SystemVerilog & UVM Design Verification Portfolio

Welcome to my hardware verification repository! This portfolio showcases end-to-end UVM (Universal Verification Methodology) environments, SystemVerilog Assertions (SVA) suites, and functional coverage models for a variety of digital designs—ranging from foundational combinational/sequential logic blocks to complex memory components and standard AMBA bus protocols.

---

##  Repository Overview

All projects adhere to modular, industry-standard UVM directory structures (`rtl/`, `tb/`, `results/`) and apply Constrained Random Verification (CRV), Assertion-Based Verification (ABV), and Coverage-Driven Verification (CDV) methodologies.

### Verification Index

| *Category* | *Component / Protocol* | *Key Features Verified* | *Directory Link* |
| :---: | :---: | :--- | :---: |
| **Protocols** | **AMBA AXI4 Full** | Multi-beat burst support (FIXED, INCR, WRAP), dynamic data masking (`wstrb`), memory limit DECERR tracking, and strictly in-order transaction processing | [`AXI4`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/AMBA%20Protocols/axi_uvm) |
| | **AMBA APB** | Non-pipelined two-cycle protocol compliance, wait-state extension (`PREADY`), slave error handling (`PSLVERR`), and SVA timing checks | [`APB`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/AMBA%20Protocols/apb_uvm) |
|  |  |  |  |
| **FIFO** | **Asynchronous FIFO** | Dual-clock Clock Domain Crossing (CDC), Gray-coded pointer synchronization using 2-FF synchronizers, and cross-domain reset recovery | [`Async FIFO`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/FIFO/async_fifo_uvm) |
| | **Synchronous FIFO** | Pointer-based circular buffer memory, full/empty status flags, and overflow/underflow protection | [`Sync FIFO`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/FIFO/sync_fifo_uvm) |
|  |  |  |  |
| **Digital Blocks**| **4:1 Multiplexer (32-bit)** | Scalable constrained-random stimulus generation across select lines to prevent output line floating/X-states | [`MUX`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/Digital%20Blocks/mux_uvm) | 
| | **1:4 Demultiplexer (32-bit)** | Single-input to multi-output routing accuracy and unselected output default state checks | [`De-MUX`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/Digital%20Blocks/dmux_uvm) |
| | **Priority Encoder (4:2)** | Multi-bit request prioritizations (`req[3]` highest) and valid signal assertion checks | [`Encoder`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/Digital%20Blocks/encoder_uvm) | 
| | **2-to-4 Decoder** | Enable signal (`en`) gating, one-hot output validation, transition coverage, and input X-propagation testing | [`Decoder`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/Digital%20Blocks/decoder_uvm) |
| | **ALU (4-bit)** | 8 operational modes (arithmetic, bitwise, shifts) and status flag verification (Carry, Zero, Negative, Overflow) via SVA | [`ALU`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/Digital%20Blocks/alu_uvm) |
| | **Up/Down Counter** | Synchronous load logic, dynamic counting direction, and boundary condition flags (`max_tick`, `min_tick`) | [`Counter`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/Digital%20Blocks/up_down_counter_uvm) |
| | **Universal Shift Register** | 4-bit multi-mode operation (Hold, Shift Left, Shift Right, Parallel Load) and synchronous reset validation | [`Shift Register`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/Digital%20Blocks/universal_shift_reg_uvm) |
| | **Mealy FSM (1011)** | Overlapping "1011" sequence detection, combinational output generation, and 4-state transition mapping | [`FSM Mealy`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/Digital%20Blocks/fsm_mealy_uvm) |
| | **Moore FSM (1011)** | Non-overlapping "1011" sequence detection, synchronized glitch-free outputs, reset recovery, and SVA liveness checks | [`FSM Moore`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/Digital%20Blocks/fsm_moore_uvm) |
| | **Fixed-Priority Arbiter** | Static 4-channel request hierarchy (`req[0]` highest), single-cycle latency, and grant mutual-exclusion assertions | [`Fixed Priority Arbiter`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/Digital%20Blocks/arbiter_fp_uvm) |
| | **Round-Robin Arbiter** | Circular priority rotation using mask logic to eliminate request starvation, single-cycle grant generation | [`Round Robin Arbiter`](https://github.com/nikita-niky/UVM_Verification_Projects/tree/main/Digital%20Blocks/arbiter_round_robin_uvm) |


---

##  General UVM Testbench Architecture

Each project is structured around an OOP-based UVM testbench environment:

```text
                  +---------------------------------------------------+
                  |                   UVM Environment                 |
                  |                                                   |
+--------------+  |  +--------------------+   +--------------------+  |
| Virtual      |  |  |     UVM Agent      |   |   UVM Scoreboard   |  |
| Sequence     |  |  |                    |   |                    |  |
+-------+------+  |  | +----------------+ |   |  (Data Integrity & |  |
        |         |  | |  UVM Driver    | |   |   Golden Model)    |  |
        v         |  | +-------+--------+ |   +---------^----------+  |
+-------+------+  |  |         |          |             |             |
| Transaction  |  |  +---------|----------+             | TLM FIFO    |
| (uvm_sequence|  |            |                        |             |
|    _item)    |  |  +---------v----------+             |             |
+--------------+  |  |    UVM Monitor     +-------------+             |
                  |  +---------+----------+                           |
                  |            | SVA / Functional Coverage            |
                  +------------|--------------------------------------+
                               |
                   +-----------v-----------+
                   |  SystemVerilog IF /   |
                   |       DUT (RTL)       |
                   +-----------------------+