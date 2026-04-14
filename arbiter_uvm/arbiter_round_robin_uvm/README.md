## Round Robin Arbiter UVM Verification Environment

## Project Overview

This repository contains the complete verification suite for a **4-channel Round Robin Arbiter**. Unlike static priority, this design ensures that no master is starved by rotating the priority after every successful grant. The RTL utilizes a **Mask Logic** approach to keep track of the last granted master and determine the next starting point for the priority search.

## Design Specifications

* **Channels:** 4 Request/Grant pairs.

* **Fairness Policy:** Round Robin (Circular).

* **Architecture:** Mask-based priority logic with immediate wraparound.

* **Latency:** Single-cycle Grant generation.

## Round Robin Logic Table (Under Constant Load)

When all requests are active (`4'b1111`), the arbiter must follow this rotation:

|Cycle | req | mask (Current) | gnt (Next) | mask (Next)|
| :---: | :---: | :---: | :---: | :---: |
|**T1**	|1111	|1111	|0001	|1110|
|**T2**	|1111	|1110	|0010	|1100|
|**T3**	|1111	|1100	|0100	|1000|
|**T4**	|1111	|1000	|1000	|0000|
|**T5**	|1111	|0000	|0001   |1110|

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

## 1. SystemVerilog Assertions (SVA)

This environment includes critical safety and fairness properties:

* **Mutual Exclusion:** `$onehot0(gnt)` ensures the bus is never shared by two masters simultaneously.

* **Stability Check:** `p_gnt_stable` ensures that once a grant is given, it remains valid as long as the request is active, preventing bus glitches.

* **No Starvation:** `p_no_starvation` is the most important check here. It ensures that if `req[0]` is asserted, it **must** eventually receive a grant within a bounded time (10 cycles), proving the fairness of the Round Robin algorithm.

* **Ghost Grant Prevention:** Checks that every grant issued was actually requested by a master in the previous cycle.

## 2. Functional Coverage

* **Grant Rotation:** Tracks which masters received grants to ensure 100% "Fairness Coverage."

* **Request/Grant Cross:** A cross between `cp_req` and `cp_gnt` to prove that the arbiter handled every possible request combination.

* **Reset Recovery Cross:** Ensures the arbiter was reset while under heavy load (`4'b1111`).


## Test Sequences & Stimulus Strategy

I designed these sequences to specifically test the "Round Robin" nature of the RTL:

|     Sequence Name       |    Objective     | Scenario Targeted |
| :---: | :---: | :---: |
|`arb_all_high_sequence`    | **Fairness Test**     | Holds all requests (`4'b1111`) high for 8 consecutive cycles. This validates that the grant signal rotates correctly (`0001 → 0010 → 0100 → 1000 → 0001`), proving the circular logic.|
|`arb_walking_ones_sequence`|**Walking Ones Test**  | Sweeps requests one-by-one to ensure the "Raw Grant" logic works when no masks are active.|
|`arb_random_sequence`      |**Random Stress test** | Drives 500 cycles of random traffic to hit complex corner cases where requests drop and reappear in different rotation phases.|
|`arb_directed_sequence`    |**Directed Test**     | Manually forces specific transitions and injects resets mid-stream to verify state recovery.|

---

## Tools Used

* **Language:** SystemVerilog, UVM
* **Simulator:** Aldec Riviera Pro 2025.04 / EDA Playground
* **Methodology:** Constrained Random Verification (CRV), Assertion Based Verification (ABV), Coverage Driven Verification (CDV).



## Technical Insight for Recruiters

"A Round Robin arbiter is only as good as its fairness. In this project, I used **SVA liveness properties** to guarantee that no master can be starved of the bus. I specifically implemented an **all-high sequence** to demonstrate the circular shift of the priority mask, proving that the RTL correctly 'remembers' the last winner and gives the next master a fair chance."


