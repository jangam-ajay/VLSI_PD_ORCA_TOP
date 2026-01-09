✋ Hi, My name is AJAY JANGAM

🎓 Electronics & Communication Engineering Student | VLSI & Physical Design Enthusiast  

💡 Passionate about backend VLSI, RTL to GDSII, and physical design automation

🚀 Hands-on with Synopsys ICC2, Design Compiler, PrimeTime, Cadence Innovus for 28nm PnR flows

# PD_ORCA_TOP_28nm


**Block-level multi-voltage ASIC physical design** at **28nm** with **52K std cells** & **40 macros**. Full RTL-to-signoff flow for **multi-power domains** & **5 clocks**, with **TCL automation** showcasing senior PD skills.

## 🎯 Project Overview
**PD_ORCA_TOP_28nm** implements complete physical design for a multi-voltage ASIC block in **28nm node**:
- **52K std cells**, **40 macros**
- **2 power domains** 
- **4 clocks**: Propagated CLK , Generated clocks - 3 ,Virtual clocks - 2
- **75% utilization**, zero DRC/LVS/timing violations

**Theory**: Block-level PD targets 65-80% util for routability (congestion <10% overflow). Multi-voltage uses `create_voltage_area` for isolation. CTS exceptions (nonstop/exclude/stop) ensure skew <50ps on generated clocks.[web:14][web:17]

## 🛠️ Tools Stack
| Tool | Purpose |
|------|---------|
| **ICC2** | PnR/CTS/Routing | 
| **DC** | Synthesis | 
| **STARRC** | Spef | 
| **PrimeTime** | STA/DMSA |

## 📋 PD Flow & Theory

### 1. Floorplanning **(Core Sizing & Macro Placement)**
- **Theory**: Aspect ratio 1:1~1.5; util 70-80% leaves routing halo. Macro abutting reduces white-space congestion by 30-40%.
- **TCL**: Auto voltage areas aligned to rows.

### 2. Placement **(Global/Detailed Opt)**
- **Theory**: Path grouping fixes high-depth logic (e.g., I_BLENDER ~40 gates → setup violations via OCV derating).
- Iterations via fly-lines → zero hotspots.

### 3. CTS **(Clock Tree Synthesis)**
- **Theory**: Balance propagated/generated clocks; nonstop pins trace thru dividers, exclude test sinks. Target: Balancing the skew
- Exceptions: don't_touch spines, float pre-routed nets.

### 4. Routing & ECO
- **Theory**: NDR (2x width/spacing) for CLK; track-aware routing at 28nm avoids via shorts.

### 5. Signoff **(STA/TPA)**
- **Theory**: DMSA models multi-scenario (RC-corner, OCV/AOCV); hold fixes via sizing/del-insert.

## 🚀 Challenges Solved
- **Voltage Planning**: TCL calc w/ margin → no area shortage.
- **Congestion**: Macro iters + fly-analysis → routable.
- **Timing**: Grouping + opt → clean slacks.

## ✅ Results Highlights
- **Utilization**: **75%** (optimal density)
- **Timing**: Setup/hold closure
- **Power**: Met targets per domain
- **Congestion**: Zero overflow

## About me
Trained Physical Design Engineer in VLSI , Seeeking opportunity in semiconductor industry to contribute my knowlege and skills.

