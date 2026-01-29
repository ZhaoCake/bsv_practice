# Bluespec SystemVerilog Practice (HDLBits)

This repository is set up for practicing Bluespec SystemVerilog (BSV) by solving problems from HDLBits.

## Quick Start

1. **Activate Environment** (if using Nix/direnv):
   ```bash
   direnv allow
   ```

2. **Navigate to a Problem**:
   ```bash
   cd hdlbits/01_Verilog_Language/01_Basics
   ```

3. **Build and Simulate** (Bluesim):
   ```bash
   make Zero
   # Compiles Zero.bsv (module mkZero) and runs the simulation
   ```

4. **Generate Verilog** (for HDLBits submission):
   ```bash
   make Zero.v
   # Generates Verilog in verilog/mkZero.v
   ```

## Project Structure

- **hdlbits/**: Contains subdirectories for each problem chapter.
  - Each subdirectory has a minimal `Makefile` that includes the root `makebase.mk`.
  - Create a new `.bsv` file for each problem (e.g., `Wire.bsv`).
- **makebase.mk**: The core build script covering compilation and simulation rules.
- **Makefile**: Root makefile for global cleanup (`make clean`).

## Adding New Problems

1. Create a directory (e.g., `hdlbits/02_Vectors`).
2. Add a `Makefile` pointing to `makebase.mk`.
3. Create your `.bsv` file (e.g. `Vector0.bsv`) with a matching top module (`module mkVector0`).
4. Run `make Vector0`.
