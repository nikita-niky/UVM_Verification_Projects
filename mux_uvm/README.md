# 4:1 Multiplexer UVM Verification Environment

## Project Overview
This repository contains a production-grade **UVM (Universal Verification Methodology)** testbench used to verify a **32-bit 4:1 Multiplexer**. The goal of this project was to move beyond simple directed testing and implement a scalable, constrained-random verification environment.

## Design Specifications
**Data Width:** 32-bit ($[31:0]$)
**Inputs:** Four data inputs (`d0`, `d1`, `d2`, `d3`) and a 2-bit select line (`sel`).
**Output:** Single 32-bit output (`y`).
**Logic:** Combinational logic based on the select lines.

## Truth Table
_________________________________
| Select($S1​,S0$​) | Output ($Y$) |
| :---: | :---: |
|  00  | D0 |
|  01  | D1 | 
|  10  | D2 |
|  11  | D3 |
__________________________
---
## Testbench Architecture
The verification environment is built using a layered UVM approach to ensure reusability and modularity.

## Key Components:
* **UVM Agent:** Encapsulates the Sequencer, Driver, and Monitor.
* **Driver:** Drives constrained-random stimulus into the virtual interface.
* **Monitor:** Observes the interface signals and converts them into transaction objects.
* **Scoreboard:** Implements the reference model to compare actual RTL output against expected results.
* **Functional Coverage:** Tracks which input combinations and select transitions have been exercised.
---

## Verification Features

### 1. Constrained Random Stimulus
Used SystemVerilog constraints to ensure all input ports received a wide range of values, including corner cases like:

* **Extreme Values:** All inputs set to `0x00000000` or `0xFFFFFFFF`.
* **Switching:** Rapid switching of the select line.
* **Data Patterns:** Walking bit patterns.

## 2. Assertions (SVA)
Implemented **SystemVerilog Assertions** to verify timing-independent behavior:

* **Output Match:** Ensures that when sel is `2'b00`, `y` exactly matches `d0` without lag.
* **X_propogation checks:**  Critical for catching initialization issues or undriven signals. These assertions trigger if the output or select lines enter an unknown state.
* **Assertion-Based Coverage :** Used to track if all possible selection paths have been exercised during the simulation run.


## 3. Functional Coverage
Defined a covergroup to ensure **100% coverage** of:

* All 4 select combinations.
* Cross coverage between sel and data input ranges.

## Test Sequences & Stimulus Strategy

To achieve high functional and toggle coverage, the following sequences were implemented:

| Sequence Name | Objective | Scenario Targeted |
| :--- | :--- | :--- |

| `mux_base_seq` | **Stress Test** | 500 iterations ofconstrained random data to find unexpected RTL bugs.|
| `mux_all_ones_seq` | **Corner Case** | Verifies the 32-bit bus can hold and transition `0xFFFF_FFFF` across all ports.|
| `mux_all_zeros_seq` | **Corner Case** | Verifies the output correctly pulls to `0` for each select combination.|
| `mux_select_unknown` | **Error Handling** | Injects `2'bx` into the select line to verify how the RTL/Scoreboard handles "X" propagation.|
| `mux_pattern_seq` | **Toggle Coverage** | Uses walking 1s and alternating patterns (55/AA) to ensure every bit of the 32-bit bus toggles.|
---


## Tools Used

* **Language:** SystemVerilog, UVM
* **Simulator:** Aldec Riviera Pro 2025.04 / EDA Playground
* **Methodology:** Constrained Random Verification (CRV)


