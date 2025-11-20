This repository contains a *clean minimal version* of the SoC used for RTL simulation, verification, and pre–RTL-to-GDS checks.

## Included
- `rtl/` — All synthesizable Verilog/SystemVerilog
- `verif/tb/` — Cocotb smoke tests for APB, AXI2WB, GPIO, I2C, SPI, PWM, SRAM, Wishbone bridges
- `scripts/` — Utilities to run all tests, clean environments, generate GTKWave save files
- `.github/workflows/ci-tests.yml` — Optional CI smoke test job

## Run all tests
```bash
./scripts/run_all_tests.sh --clean --gtkw
