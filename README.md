# Traffic-Light-FSM
This repository contains the implementation of a Timed Traffic Light Controller using a Finite State Machine (FSM) in SystemVerilog. This project was developed as part of the ELE432 Advanced Digital Design course.

//Project Overview

The system controls traffic lights for two streets (Street A and Street B) based on traffic sensor input (TAORB) and internal timers for yellow light transitions.

//FSM States

The controller operates using a 4-state Moore Machine:

S0 (Green A / Red B): Street A has a green light. Transitions to S1 when traffic is detected on Street B (~TAORB).

S1 (Yellow A / Red B): Transition state for Street A. Holds for 5 time units using an internal counter.

S2 (Red A / Green B): Street B has a green light. Transitions to S3 when traffic returns to Street A (TAORB).

S3 (Red A / Yellow B): Transition state for Street B. Holds for 5 time units before returning to S0.

//Features

Moore FSM Design: Outputs are strictly dependent on the current state.

Internal Timer: A 3-bit counter manages the 5-cycle delay required for yellow lights.

Synchronous Reset: The system initializes to S0 upon reset.

Synthesizable Code: Fully compatible with Intel Quartus Prime for FPGA implementation.

//Implementation Details

Language: SystemVerilog

Tools: Intel Quartus Prime Lite Edition

Target: Generic FPGA / Simulation
