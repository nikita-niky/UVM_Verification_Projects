## 4-bit Up/Down Loadable Counter UVM Verification Environment

## Project Overview

This repository contains a production-grade **UVM (Universal Verification Methodology)** environment for verifying a **4-bit Up/Down Counter**. The design features synchronous load capabilities and combinational status flags for boundary detection. The verification strategy focuses on ensuring functional correctness during state transitions, wrap-around scenarios, and control signal priority (Reset > Load > Count).

## Design Specifications

* **Word Size:** 4-bit (`count`).

* **Control Signals:**
* * **up_down:** High ($1$) for Increment, Low ($0$) for Decrement.
* * **load:** Synchronous load of `count_in` value.
* * **rst:** Active-high synchronous reset.

* **Status Flags:**
* * **max_tick:** Asserted when `count == 15`.
* * **min_tick:** Asserted when `count == 0`.

## Verification Features

## 1. SystemVerilog Assertions (SVA)

Assertions are bound to the RTL to provide real-time monitoring of control logic and flag accuracy:

* **Priority Assertion:** Asserts that if `rst` and `load` are both high, the `count` must go to `0`.

* **Counting Logic:** Verified using `$past` to ensure `count == $past(count) +/- 1` based on the `up_down` signal.

* **Wrap-Around Logic:** Specifically monitors the transition from `15 -> 0` (Up) and `0 -> 15` (Down).

* **Flag Integrity:** Combinational assertions ensure `max_tick` and `min_tick` are strictly tied to the current `count` value without latency.

* **Unknown State Check:** Uses `$isunknown(count)` to ensure the counter never enters a metastable or unknown state after reset.

## 2. Functional Coverage

The counter_coverage subscriber tracks a variety of metrics to reach 100% verification closure:

* **Wrap-Around Bins:** Uses transition bins (`15 => 0`) and (`0 => 15`) to confirm the counter has successfully rolled over in both directions.

* **Control Crosses:** 
* * **cross_rst_during_load:** Confirms the testbench verified the reset-over-load priority.
* * **cross_max_15 / cross_min_0:** Ensures that the `max_tick` and `min_tick` flags were exercised exactly when the counter hit its limits.

* **Illegal Bins:** Automatically flags a failure if `max_tick` is high when the count is not `15`, or if `rst` is high but the count is non-zero.

## Test Sequences & Stimulus Strategy

The environment utilizes directed and random sequences to ensure all counting modes and priority logic are fully exercised:

|     Sequence Name       |    Objective     | Scenario Targeted |
| :---: | :---: | :---: |
| `counter_base_seq`	 | **Stress Test**      | 100 iterations of constrained-random control signals to explore general state transitions.|
| `counter_directed_seq` | **Boundary Testing** |Up-Wrap: Loads `15` and counts up to verify wrap-around to `0`.                                |
|                        |                      |Down-Wrap: Loads `0` and counts down to verify wrap-around to `15`.	                        |
|                        |                  |Priority Check: Asserts `rst` and `load` simultaneously to ensure `rst` takes priority.          |	
|                        |                      |Toggle Stress: Rapidly switches `up_down` to verify internal state stability.                |

---

## Tools Used

* **Language:** SystemVerilog, UVM
* **Simulator:** Aldec Riviera Pro 2025.04 / EDA Playground
* **Methodology:** Constrained Random Verification (CRV), Assertion Based Verification (ABV), Coverage Driven Verification (CDV)

## Technical Insight for Recruiters

"A common bug in counters is the 'off-by-one' error during wrap-around or a priority conflict between Load and Reset signals. My environment uses **transition coverage** and **temporal assertions** to prove that the counter handles boundary conditions and control priorities exactly as specified, even under randomized stress testing."
