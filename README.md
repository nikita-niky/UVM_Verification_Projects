# SystemVerilog & UVM Design Verification Portfolio

Welcome to my hardware verification repository! This portfolio showcases end-to-end UVM (Universal Verification Methodology) environments, SystemVerilog Assertions (SVA) suites, and functional coverage models for a variety of digital designs—ranging from foundational combinational/sequential logic blocks to complex memory components and standard AMBA bus protocols.

---

## 📌 Repository Overview

All projects adhere to modular, industry-standard UVM directory structures (`rtl/`, `tb/`, `sim/`, `results/`) and apply Constrained Random Verification (CRV), Assertion-Based Verification (ABV), and Coverage-Driven Verification (CDV) methodologies.

### 🛠️ Verification Index

| Category | Component / Protocol | Key Features Verified | Directory Link |
| :--- | :--- | :--- | :--- |
| **Protocols** | **AMBA AXI4 Full** | Multi-beat burst support (FIXED, INCR, WRAP), dynamic data masking (`wstrb`), memory limit DECERR tracking, and strictly in-order transaction processing | [`AMBA Protocols/axi_uvm`](./AMBA Protocols/apb_uvm) |
| | **AMBA APB** | Non-pipelined two-cycle protocol compliance, wait-state extension (`PREADY`), slave error handling (`PSLVERR`), and SVA timing checks | [`protocols/apb_uvm`](./protocols/apb_uvm) |
| **FIFO** | **Asynchronous FIFO** | Dual-clock Clock Domain Crossing (CDC), Gray-coded pointer synchronization using 2-FF synchronizers, and cross-domain reset recovery | [`cdc_and_storage/async_fifo_uvm`](./cdc_and_storage/async_fifo_uvm) |
| | **Synchronous FIFO** | Pointer-based circular buffer memory, full/empty status flags, and overflow/underflow protection | [`cdc_and_storage/sync_fifo_uvm`](./cdc_and_storage/sync_fifo_uvm) |
| **Digital Blocks** | **Fixed-Priority Arbiter** | Static 4-channel request hierarchy (`req[0]` highest), single-cycle latency, and grant mutual-exclusion assertions | [`digital_blocks/fixed_priority_arbiter_uvm`](./digital_blocks/fixed_priority_arbiter_uvm) |
| | **Round-Robin Arbiter** | Circular priority rotation using mask logic to eliminate request starvation, single-cycle grant generation | [`digital_blocks/round_robin_arbiter_uvm`](./digital_blocks/round_robin_arbiter_uvm) |
| | **ALU (4-bit)** | 8 operational modes (arithmetic, bitwise, shifts) and status flag verification (Carry, Zero, Negative, Overflow) via SVA | [`digital_blocks/alu_uvm`](./digital_blocks/alu_uvm) |
| | **Mealy FSM (1011)** | Overlapping "1011" sequence detection, combinational output generation, and 4-state transition mapping | [`digital_blocks/mealy_fsm_uvm`](./digital_blocks/mealy_fsm_uvm) |
| | **Moore FSM (1011)** | Non-overlapping "1011" sequence detection, synchronized glitch-free outputs, reset recovery, and SVA liveness checks | [`digital_blocks/moore_fsm_uvm`](./digital_blocks/moore_fsm_uvm) |
| | **Universal Shift Register** | 4-bit multi-mode operation (Hold, Shift Left, Shift Right, Parallel Load) and synchronous reset validation | [`digital_blocks/universal_shift_reg_uvm`](./digital_blocks/universal_shift_reg_uvm) |
| | **Up/Down Counter** | Synchronous load logic, dynamic counting direction, and boundary condition flags (`max_tick`, `min_tick`) | [`digital_blocks/up_down_counter_uvm`](./digital_blocks/up_down_counter_uvm) |
| | **Priority Encoder (4:2)** | Multi-bit request prioritizations (`req[3]` highest) and valid signal assertion checks | [`digital_blocks/priority_encoder_4to2_uvm`](./digital_blocks/priority_encoder_4to2_uvm) |
| | **4:1 Multiplexer (32-bit)** | Scalable constrained-random stimulus generation across select lines to prevent output line floating/X-states | [`digital_blocks/mux_uvm`](./digital_blocks/mux_uvm) |
| | **1:4 Demultiplexer (32-bit)** | Single-input to multi-output routing accuracy and unselected output default state checks | [`digital_blocks/dmux_uvm`](./digital_blocks/dmux_uvm) |
| | **2-to-4 Decoder** | Enable signal (`en`) gating, one-hot output validation, transition coverage, and input X-propagation testing | [`digital_blocks/decoder_2to4_uvm`](./digital_blocks/decoder_2to4_uvm) |

---

## 🏗️ General UVM Testbench Architecture

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