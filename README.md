# FPGA System Design — Artix-7

**Collection of RTL designs implemented on the Artix-7 FPGA (Basys3 development board).**

<div align="center">

[![VHDL](https://img.shields.io/badge/VHDL-RTL-blue?style=for-the-badge)](https://en.wikipedia.org/wiki/VHDL)
[![Artix-7](https://img.shields.io/badge/Artix--7-FPGA-red?style=for-the-badge)](https://www.xilinx.com/products/silicon-devices/fpga/artix-7.html)
[![Basys3](https://img.shields.io/badge/Basys3-Development_Board-green?style=for-the-badge)](https://digilent.com/reference/programmable-logic/basys-3/start)
[![Vivado](https://img.shields.io/badge/Vivado-Design_Suite-orange?style=for-the-badge)](https://www.xilinx.com/products/design-tools/vivado.html)

**May 2026 | Jin Yuan Chen**

</div>

---

## Projects

### HP 5004A Signature Analyzer

<div align="center">

| | |
|:---:|:---:|
| <img src="hp5004_full.jpg" alt="HP 5004A Instrument" width="380"/> | <img src="hp5004_fpga.jpg" alt="FPGA Implementation" width="380"/> |
| *Original HP 5004A Signature Analyzer* | *Basys3 FPGA Implementation* |

</div>

An FPGA-based digital replica of the **HP 5004A Signature Analyzer** — a classic test instrument used in field-level digital circuit debugging. The design computes a 16-bit signature of a serial data stream captured between configurable **START** and **STOP** boundary conditions, then displays the result as a 4-digit hexadecimal value on the Basys3 on-board 7-segment display.

---

## Architecture

<div align="center">
<img src="hp5004a-signature-analyzer/src/multiplexed_display/block_diagram.png" alt="Block Diagram" style="max-width:80%; height:auto;"/>
</div>

The design is a fully structural VHDL hierarchy composed of six functional blocks:

```
hp5004a (top)
├── edge_selecter × 3     — Configurable pos/neg edge detector (START, STOP, CLOCK)
├── gate_gen              — 3-state FSM measurement window controller
├── hp5004a_lfsr          — 16-bit LFSR signature engine
├── buff_register         — 16-bit output capture register
├── prescalar             — Clock divider for display multiplexing
└── multiplexed_display   — 4-digit 7-segment structural subsystem
    ├── mux_4_to_1        — 4-to-1 nibble multiplexer
    ├── funnyhex_seven    — Hex-to-7-segment decoder
    ├── decoder_2_to_4    — 2-to-4 digit enable decoder
    └── digit_counter     — Display scan counter
```

---

## Module Descriptions

### `gate_gen` — Measurement Window FSM

Controls the LFSR acquisition window via a 3-state Moore FSM:

| State | `gate_out` | `reg_en` | Description |
|-------|-----------|---------|-------------|
| `IDLE` | `0` | `0` | Waiting for START edge |
| `GATE_H` | `1` | `0` | Acquiring — LFSR actively clocked |
| `GATE_L` | `0` | `1` | STOP edge received — latch result |

<div align="center">
<img src="hp5004a-signature-analyzer/waveform/fsm_IDLE_GATE_H.png" alt="FSM IDLE to GATE_H" width="600"/>
<br/><em>Figure 1: FSM transition waveform — IDLE → GATE_H on START edge</em>
</div>

<div align="center">
<img src="hp5004a-signature-analyzer/waveform/fsm_GATE_H_L.png" alt="FSM GATE_H to GATE_L" width="600"/>
<br/><em>Figure 2: FSM transition waveform — GATE_H → GATE_L on STOP edge (reg_en pulse)</em>
</div>

---

### `edge_selecter` — Configurable Edge Detector

A two-flop synchronizer that selects either the **rising** or **falling** edge of an input signal based on the `pos_neg` control input. Used on START, STOP, and CLOCK inputs to allow runtime edge polarity selection via on-board switches.

| `pos_neg` | Detected Edge |
|-----------|--------------|
| `1` | Rising edge |
| `0` | Falling edge |

---

### `hp5004a_lfsr` — 16-bit LFSR Signature Engine

Implements the HP 5004A signature polynomial. On each enabled clock edge while the gate is open, the LFSR shifts and incorporates the serial `data` input via XOR feedback:

```
feedback = lfsr[15] XOR lfsr[11] XOR lfsr[8] XOR lfsr[6] XOR data
```

The register clears on reset or when `reg_en` is asserted (new acquisition cycle).

<div align="center">
<img src="hp5004a-signature-analyzer/waveform/lfsr_data_wave.png" alt="LFSR Waveform" width="600"/>
<br/><em>Figure 3: LFSR accumulation waveform during active gate window</em>
</div>

---

### `buff_register` — Output Capture Register

A 16-bit register that latches the LFSR state on the falling edge of the gate window (`reg_en` pulse). Holds the computed signature stable for display until the next acquisition cycle.

<div align="center">
<img src="hp5004a-signature-analyzer/waveform/buff_register_wave.png" alt="Buffer Register Waveform" width="600"/>
<br/><em>Figure 4: Buffer register latching the 16-bit signature on reg_en</em>
</div>

---

### `multiplexed_display` — 4-Digit 7-Segment Output

Displays the 16-bit signature as four hex digits on the Basys3 7-segment display. A `prescalar` divides the system clock to generate the display scan enable signal, and a `digit_counter` cycles through the four nibbles. The `funnyhex_seven` decoder maps hex values to a custom HP-style segment alphabet:

| Hex | Symbol | Hex | Symbol |
|-----|--------|-----|--------|
| `0`–`9` | 0–9 | `A` | A |
| `B` | C | `C` | H |
| `D` | F | `E` | P |
| `F` | U | | |

<div align="center">
<img src="hp5004a-signature-analyzer/waveform/prescaled_digs_wave.png" alt="Prescaled Display Waveform" width="600"/>
<br/><em>Figure 5: Prescaled display digit scan waveform</em>
</div>

---

## Pin Assignment (Basys3)

| Signal | Pin | Source |
|--------|-----|--------|
| `clk` (100 MHz) | W5 | Onboard oscillator |
| `rst_bar` | V17 | SW0 |
| `starte` (START edge sel) | V16 | SW1 |
| `stope` (STOP edge sel) | W16 | SW2 |
| `clocke` (CLOCK edge sel) | W17 | SW3 |
| `start` | J1 | Pmod JB pin 1 |
| `stop` | L2 | Pmod JB pin 3 |
| `clock` | J2 | Pmod JB pin 2 |
| `data` | G2 | Pmod JB pin 4 |
| `segs[6:0]` | W7–U7 | 7-segment segments |
| `digs[3:0]` | U2–W4 | 7-segment digit anodes |

---

## Source Structure

```
hp5004a-signature-analyzer/
├── src/
│   ├── top/
│   │   ├── hp5004a.vhd             # Top-level structural entity
│   │   └── tb/
│   │       └── hp5004a_TB.vhd      # Behavioral testbench
│   ├── core/
│   │   ├── edge_selecter.vhd
│   │   ├── prescalar.vhd
│   │   └── register.vhd
│   ├── gate_gen/
│   │   └── gate_gen.vhd
│   ├── hp5004a_lfsr/
│   │   └── hp5004a_lfsr.vhd
│   └── multiplexed_display/
│       ├── multiplexed_display.vhd
│       ├── mux_4_to_1.vhd
│       ├── funnyhex_seven.vhd
│       ├── decoder_2_to_4.vhd
│       └── digit_counter.vhd
├── pin_assign.xdc                  # Vivado constraint file
├── waveform/                       # Simulation waveform screenshots
├── diagram/                        # Schematic PDF
└── hp5004a.bit                     # Compiled bitstream
```

---

## Simulation

The testbench (`hp5004a_TB.vhd`) drives a 16-bit data stream through four repeated acquisition cycles using:

| Parameter | Value |
|-----------|-------|
| System clock period | 250 ns (4 MHz) |
| DUT clock period | 2.5 µs (400 kHz) |
| Test data stream | Configurable `std_logic_vector(15 downto 0)` |

Each cycle asserts START, shifts 16 bits of data synchronous to the DUT clock, then asserts STOP — verifying the full FSM → LFSR → register → display pipeline.

---

## Tools & References

| Resource | Description |
|----------|-------------|
| `Artix7_FPGAs_data_sheet.pdf` | Artix-7 FPGA datasheet |
| `basys3_board_reference.pdf` | Basys3 board reference manual |
| `diagram/schematic.pdf` | HP 5004A circuit schematic reference |
| `Lab10s26`–`Lab12s26` PDFs | Lab specifications (I, II, III) |
| Xilinx Vivado | Synthesis, implementation, bitstream generation |
