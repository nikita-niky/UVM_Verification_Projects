# Asynchronous FIFO UVM Verification Environment

## Project Overview

This repository contains a comprehensive **UVM (Universal Verification Methodology)** environment designed to verify a dual-clock (asynchronous) FIFO. The project focuses on handling Clock Domain Crossing (CDC) challenges, pointer synchronization using Gray coding, and robust reset recovery.

## Key Features:

* **Dual-Clock Domain:** Supports independent `wclk` (Write) and `rclk` (Read) frequencies.

* **CDC Synchronization:** 2-FF Synchronizers for pointer crossing.

* **Gray Coding:** Implemented to prevent multi-bit synchronization errors.

* **UVM Architecture:** Fully layered environment including Agents, Monitors and Scoreboard.

## Testbench Architecture

The testbench follows standard UVM hierarchy to ensure reusability and scalability.

## Key Components:

* **Driver:** Seperate Write and Read Driver for independent driving of signals.

* **Monitor:** Seperate Write and Read Monitor for Independent Monitoring of the signals and it also includes condition for sending the data to scoreboard to check.

* **Agents:** Separate Write and Read agents for independent domain control.

* **Scoreboard:** A custom-built shadow model that tracks FIFO transactions across clock domains.
---

## ## Verification Features

## 1. SystemVerilog Assertions (SVA)

This project implements a comprehensive **Assertion-Based Verification (ABV)** strategy to validate Gray code pointer transitions, multi-flip-flop synchronization settling, and data integrity across asynchronous boundaries.

### 1. CDC & Pointer Integrity

The core of an Asynchronous FIFO's reliability lies in its Gray code pointers. If a pointer transitions by more than one bit, it can lead to catastrophic meta-stability issues in the synchronization chain.

* **Gray Code Validation (`a_wptr_gray / a_rptr_gray`):** Uses `$countones` to verify that for every clock edge where a pointer changes, the Hamming distance is exactly **1**. This guarantees that the 2-FF synchronizers always sample a valid (albeit potentially slightly delayed) value.

* **Synchronizer Settling Check (`a_sync_settle`):** A specialized property that ensures if a pointer remains stable for 3 cycles, the synchronized output in the destination domain must match the input. This validates the "eventual consistency" required for correct full/empty flag generation.

### 2. Status Flag & Boundary Logic

Since `wfull` is generated in the `wclk` domain and `rempty` in the `rclk` domain, the logic for comparing pointers is complex (MSB inversion for Full).

* **Overflow/Underflow Protection:** Asserts that `winc` (write increment) and `rinc` (read increment) are ignored if the FIFO is `wfull` or `rempty`, preventing pointer corruption.

* **Full Flag Logic (`a_full_logic`):** Formally verifies the MSB comparison logic. This ensures the `wfull` flag is only asserted when the write pointer has wrapped around exactly once.

### 3. Memory & Data Stability 

Even with correct pointers, the data path must be verified for stability.

* **Address/Data Stability:** Asserts that `waddr`, `raddr`, and `rdata` remain perfectly stable unless a valid operation (increment) is occurring. This catches "glitchy" logic or timing violations in the memory read/write control.

* **X-Check (Unknown Propagation):** Uses `!$isunknown` to ensure that control signals and data never propagate an 'X' state during active operations, which is critical for Gate-Level Simulations (GLS).

## 2. Functional Coverage 

### 1. Coverage Strategy

The primary goal of this coverage model is to ensure that the Asynchronous FIFO's control logic is exercised across all boundary conditions and that the independent clock domains are verified both in isolation and in transition.

## Key Objectives:

### 1. Coverage Strategy

* **Asynchronous Reset Verification:** Verify that the FIFO behaves correctly when either the write or read domains are reset independently.

* **Data Integrity Patterns:** Ensure the data path handles "boundary" values like toggling bits (0x55, 0xAA) and single-bit "walking ones" to catch bit-stuck faults.

* **Protocol Violation Detection:** Used illegal_bins to ensure that if a reset occurs, the FIFO status flags immediately reflect a "Clean/Empty" state.

### 2. Coverage Components & Crosses

#### Control Port Coverage

* **Write & Read Increments:** Monitors `winc` and `rinc` to ensure both single-access and burst-access scenarios are covered.

* **Flag States:** Dedicated coverpoints for `wfull` and `rempty` to guarantee that the testbench successfully filled and emptied the FIFO across the CDC boundary.

#### Advanced Cross Coverage

* **rst_x_full:** A cross between write-reset (`wrst_n`) and the full flag. It includes an illegal bin that triggers if the FIFO reports "Full" while the write reset is active. This validates the hardware's reset-settling logic.

* **rd_empty:** A cross between read-reset (`rrst_n`) and the empty flag. The illegal bin ensures that a read-reset always results in an "Empty" state, verifying that the read pointer and status logic are properly cleared.

#### Data Path Coverage

The wdata and rdata coverpoints are binned for high-value test patterns:

* **walking_1:** Validates each individual bit in the 8-bit bus.

* **alt_5 / alt_A:** Toggles every adjacent bit (`01010101` and `10101010`) to check for cross-talk or coupling issues in the memory array.


## Test Sequences & Stimulus Strategy

| Sequence Name | Test Type | Objective | Scenario Targeted | Verification Goal|
| :---: | :---: | :---: | :---: | :---: |
|`fifo_directed_sequence`|**Sanity & Full-to-Empty Test**|Performs a clean "Fill then Drain" operation.|Writes 50 consecutive packets to the FIFO until the `wfull` flag is asserted, followed by 50 consecutive reads until the `rempty` flag is triggered.|Ensures the basic RTL path and status flags work correctly under steady-state conditions.|
|`fifo_ovfl_seq` |**Boundary Protection test**|Stress-test the protection logic at the FIFO limits.|**Overflow:** Attempts to write 20 items into a 16-deep FIFO.|Validates that internal pointers do not increment when the FIFO is at its boundary, preventing memory corruption.|
|`fifo_udfl_seq` |**Boundary Protection test**|Stress-test the protection logic at the FIFO limits.|**Underflow:** Attempts to read 20 items from an empty FIFO.|Validates that internal pointers do not increment when the FIFO is at its boundary, preventing memory corruption.|
|`fifo_stress_seq` |**Synchronization Latency Test**|Test the "settling time" of the 2-FF synchronizers.|Rapidly switches between "Burst-Fill" and "Burst-Drain" phases.|Ensures that the `wfull` and `rempty` flags—which depend on synchronized pointers from the opposite domain—react accurately despite the CDC latency.|
|`fifo_reset_op_seq` |**Stability & Recovery Test**| Mimics a system-level brownout or emergency reset|While traffic is flowing, the sequence randomly injects a reset (`wrst_n` or `rrst_n`) with a 5% probability.|Proves the FIFO can recover and re-synchronize its pointers without getting stuck in a deadlock or an unknown 'X' state.|
|`fifo_random_seq` |**Constrained Random Stress**|To explore the state space of the Asynchronous FIFO by generating unpredictable traffic patterns across both clock domains.|Operates the FIFO with randomized winc and rinc toggles over 400 cycles. It creates varying "pressure" on the memory—switching between long bursts of writes that fill the FIFO and staggered reads that test the synchronization latency of the rempty flag.|To ensure the Gray code pointer logic and the 2-FF synchronizers remain functionally correct under "illegal-looking" but valid asynchronous timing. It specifically targets the internal full/empty logic to ensure no data is dropped or duplicated during high-frequency switching.|

---


## Tools Used

* **Language:** SystemVerilog, UVM
* **Simulator:** Aldec Riviera Pro 2025.04 / EDA Playground
* **Methodology:** Constrained Random Verification (CRV), Assertion Based Verification (ABV), Coverage Driven Verification (CDV) 

## Technical Insight for Recruiters

To provide a deeper dive into my design and verification choices, here are the key technical considerations addressed in this project:

* **CDC & Gray Code Integrity:** In this project, I addressed the challenges of metastability by implementing Gray code conversion for pointers and verifying them with SVA Hamming distance checks. This ensures that only one bit transitions per clock cycle, guaranteeing that 2-FF synchronizers sample valid values and preventing pointer corruption.

* **Verification of 'Eventual Consistency':** Asynchronous FIFOs rely on conservative flags. I verified this by writing a custom SVA property that checks if a stable pointer in the source domain correctly settles in the destination domain within 3 cycles. This proves the synchronizer's latency and ensures we never overflow due to delayed "Full" propagation.

* **Reset Recovery:** My strategy focused on a common point of silicon failure: Asynchronous Reset Recovery. Using `fifo_reset_op_seq`, I injected resets into the write and read domains independently during active traffic. This confirmed that the CDC logic re-synchronizes without deadlocks or 'X' propagation—skills I refined during my internship at Intel.