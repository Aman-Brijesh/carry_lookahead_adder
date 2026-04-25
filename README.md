# Carry Lookahead Adder (CLA) Implementation

This project provides a hierarchical implementation of a 32-bit Carry Lookahead Adder (CLA) in SystemVerilog. The design is built using modular 4-bit and 16-bit CLA blocks to optimize carry propagation speed.

## Project Structure

- **`CLA.sv`**: Contains the hardware logic for the adder modules:
  - **`CLA`**: A parameterizable 4-bit base module that calculates Generate ($G$) and Propagate ($P$) signals to derive carries.
  - **`CLA16`**: A 16-bit adder composed of four 4-bit `CLA` blocks.
  - **`CLA32`**: A 32-bit adder composed of two 16-bit `CLA16` blocks.
- **`tb_CLA.sv`**: A comprehensive testbench that validates the 32-bit adder using randomized stimulus and a behavioral model.

## Hardware Logic Overview

The CLA logic minimizes the delay caused by carry rippling by calculating all carry bits in parallel based on the input operands.

- **Generate ($G$):** $G_i = A_i \cdot B_i$ (Carry is generated at bit $i$).
- **Propagate ($P$):** $P_i = A_i \oplus B_i$ (Carry is propagated through bit $i$).
- **Carry ($C$):** Calculated using the formula $C_{i+1} = G_i + (P_i \cdot C_i)$.
- **Group Signals:** The modules also output Group Propagate (`Pg`) and Group Generate (`Gg`) to facilitate higher-level hierarchical connections.

## Verification

The testbench (`tb_CLA.sv`) performs the following verification steps:

1.  **Directed Tests**: Validates specific edge cases such as all-zeros, all-ones, and carry-in transitions.
2.  **Randomized Testing**: Executes 1,000 iterations of random 32-bit additions using `$urandom`.
3.  **Self-Checking**: Compares the hardware output (`actual`) against a golden behavioral model (`expected`).
4.  **Error Handling**: If a mismatch occurs, the simulation terminates with a `$fatal` message detailing the failing inputs and results.

## How to Run

1.  **Requirements**: Use a SystemVerilog simulator (e.g., Icarus Verilog, Vivado, or VCS). I used Icarus Verilog
2.  **Simulation**: Compile both files and run the testbench:
    ```
    iverilog -g2012 CLA.sv tb_CLA.sv
    vvp a.out
    ```
