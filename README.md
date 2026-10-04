# 🚀 APB UVM Verification Environment

A complete **UVM-based verification environment** for an **AMBA APB memory slave**, developed in **SystemVerilog + UVM 1.2** and verified using **Synopsys VCS**.

This project focuses on functional verification of APB read/write operations, address handling, protocol behavior, reset scenarios, byte strobes, slave errors, scoreboard checking, random testing, stress testing, code coverage, and functional coverage.

---

## 📌 Project Overview

The goal of this project is to verify an APB-based memory slave using a reusable UVM verification architecture.

The environment includes:

- ✅ Transaction-level stimulus
- ✅ Directed sequences
- ✅ Randomized sequences
- ✅ APB driver
- ✅ APB monitor
- ✅ UVM agent
- ✅ Reference-model-based scoreboard
- ✅ Functional coverage collector
- ✅ Error checking
- ✅ Reset verification
- ✅ Protocol violation testing
- ✅ Random stress testing
- ✅ Code coverage
- ✅ Functional coverage
- ✅ DVE waveform debugging

---

# 🧩 APB Configuration

The DUT uses the following APB configuration:

| Parameter | Value |
|---|---:|
| Address Width | 32 bits |
| Data Width | 64 bits |
| Strobe Width | 8 bits |
| Memory Size | 64 KB |
| Word Size | 8 bytes |
| Number of Memory Words | 8192 |
| Lowest Valid Address | `0x00000000` |
| Highest Valid Aligned Address | `0x0000FFF8` |
| First Out-of-Range Address | `0x00010000` |

Because the data bus is 64 bits wide, each APB word contains:

```text
64 bits = 8 bytes
