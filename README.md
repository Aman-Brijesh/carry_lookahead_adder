# Carry Lookahead Adder (CLA)

This repository contains a parameterizable SystemVerilog implementation of a Carry Lookahead Adder and its corresponding testbench.

## Project Structure

- **`CLA.sv`**: The primary hardware module. It features a configurable `WIDTH` (default 32) and implements the CLA logic using generate/propagate signals to compute sums and carries.
  - **Inputs**: `A`, `B` (operands), `Cin` (carry-in).
  - **Outputs**: `sum`, `Cout` (carry-out), and `V` (overflow flag).
- **`tb_CLA.sv`**: A randomized testbench that validates the adder against a behavioral model.
  - Executes 1,000 iterations of random 32-bit additions.
  - Uses a `$fatal` check to ensure the computed sum matches the expected hardware model.

## Logic Overview

The design calculates the Carry ($C$) based on Generate ($G$) and Propagate ($P$) logic:

- $G_i = A_i \cdot B_i$
- $P_i = A_i \oplus B_i$
- $C_{i+1} = G_i + (P_i \cdot C_i)$

## How to Run

1.  **Simulation**: I used Icarus Verilog
2.  **Execution**: Run the testbench file (`tb_CLA.sv`) along with the design file (`CLA.sv`).
3.  **Verification**: The simulation will display "PASS" for each successful addition and "ALL TESTS COMPLETED!" upon successful conclusion. In case of failure it will exit saying "FAIL" and give a b cin expected and sum
