# 1:4 Demultiplexer UVM Verification Environment

## Project Overview

This repository features a **UVM-based verification environment** for a **32-bit 1:4 Demultiplexer**. This project demonstrates the ability to verify data routing logic where a single input is directed to one of four outputs based on a select signal.

## Design Specifications

* **Data Width:** 32-bit ($[31:0]$)
* **Input:** Single 32-bit data input (`din`) and a 2-bit select line (`sel`).
* **Outputs:** Four 32-bit outputs (`y0`, `y1`, `y2`, `y3`).
* **Logic:** The selected output reflects `din`, while non-selected outputs remain at `0` (or a default state).

### Truth Table

| Select ($S_1, S_0$) | $Y_0$ | $Y_1$ | $Y_2$ | $Y_3$ |
| :---: | :---: | :---: | :---: | :---: |
| 00 | Din | 0 | 0 | 0 |
| 01 | 0 | Din | 0 | 0 |
| 10 | 0 | 0 | Din | 0 |
| 11 | 0 | 0 | 0 | Din |

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

Used SystemVerilog constraints and distribution weights to ensure robust verification of the data routing paths:

* **Balanced Port Distribution:** Used dist constraints (`{[0:3]:=25}`) to ensure each of the four output ports received an equal amount of traffic.
* **Extreme Values:** Injected `0x00000000` and `0xFFFFFFFF` across different ports to verify the 32-bit bus integrity.
* **Toggle Patterns:** Implemented walking 1s and alternating patterns (`55/AA`) to verify that every bit in every output port toggles correctly.

### 2. Assertions (SVA)

Implemented SystemVerilog Assertions to verify the structural and protocol-level behavior of the Demux:

* **Routing Correctness:** Uses `$past(d)` to ensure that the input data appears at the correctly selected output port on the following clock edge.
* **Zero-Leakage (Isolation):** Verified that all inactive ports remain at `32'h0` and do not "leak" data from the input bus.
* **Stability Checks:** Monitors the `sel` and `d` lines to ensure no `X or Z` values are propagated during active simulation.
* **Reset Integrity:** A dedicated check to ensure all outputs are immediately cleared when `rst_n` is asserted.

## 3. Functional Coverage

Defined a comprehensive covergroup to ensure **100% coverage** of the distribution logic:

* **Select Line Bins:** Verified that all four output paths were activated.
* **Select Transitions:** Tracked the movement between ports (e.g., $0 \rightarrow 3, 2 \rightarrow 1$) to ensure the routing logic handles rapid select changes.
* **Cross Coverage:** Verified the intersection of data patterns (All ones, All zeros) with each of the four select combinations.

## Test Sequences & Stimulus Strategy

To achieve high functional and toggle coverage for the data distribution paths, the following sequences were implemented:

|     Sequence Name       |    Objective     | Scenario Targeted |
| :---: | :---: | :---: |
| `demux_base_seq`	      | **Stress Test**	     |50 iterations of unconstrained random data.                                                     |
| `demux_all_ones_seq`	  |**Bus Integrity**	 |Uses dist {[0:3]:=25} to evenly distribute 0xFFFFFFFF across all four output ports.             |
| `demux_all_zeros_seq`	  | **Reset/Clear State**|Verifies that all ports can be cleared to 32'h0 without logic glitches.                         |
| `demux_select_unknown`  | **Error Injection**	 |Forces 2'bx on sel to verify that the Scoreboard and Assertions catch illegal routing.          |
| `demux_pattern_seq`	  | **Toggle Coverage**	 |Iterates through walking 1s and 55/AA patterns to ensure every bit in every output port toggles.|

---

## Tools Used

* **Language:** SystemVerilog, UVM
* **Simulator:** Aldec Riviera Pro 2025.04 / EDA Playground
* **Methodology:** Constrained Random Verification (CRV)