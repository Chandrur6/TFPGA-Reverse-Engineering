# T-FPGA Reverse Engineering

## Project Overview

This project focuses on the reverse engineering and schematic analysis of a T-FPGA board using KiCad.

As part of the internship work, the existing hardware design was studied and recreated as a KiCad schematic. The AXP2101 power management IC was analyzed in detail, including its 40-pin connections, power rails, capacitors, inductors, resistors, and related signals.

## Objectives

- Understand the T-FPGA hardware architecture.
- Study the existing circuit and reference schematic.
- Identify the functions of the AXP2101 PMIC pins.
- Recreate the schematic using KiCad.
- Connect power, ground, capacitors, inductors, resistors, and signal nets correctly.
- Perform Electrical Rules Check (ERC).
- Identify and troubleshoot schematic connectivity errors.
- Maintain the project files using GitHub.

## Tools Used

- KiCad 9.0
- KiCad Schematic Editor
- GitHub
- Reference hardware schematic
- AXP2101 PMIC datasheet/reference information

## Work Completed

### Week 1

During Week 1, the T-FPGA hardware and schematic were studied.

The main activities included:

- Understanding the T-FPGA board and its major sections.
- Studying the existing/reference schematic.
- Identifying important components and their connections.
- Understanding the role of the AXP2101 power management IC.
- Learning the KiCad schematic environment.
- Starting the schematic recreation process.
- Identifying power and ground connections.

### Week 2

During Week 2, the AXP2101 schematic connections were continued and completed.

#### AXP2101 Pins 11–20

The LDO/output-related pins were connected along with their corresponding capacitors and ground connections.

- Pin 11 – DLDO2/DC4SW
- Pin 12 – BLDO4
- Pin 13 – BLDO1IN
- Pin 14 – BLDO2
- Pin 15 – ALDO4
- Pin 16 – ALDO3
- Pin 17 – ALDO1IN
- Pin 18 – ALDO1
- Pin 19 – ALDO2
- Pin 20 – DLDO1/DC1SW

#### AXP2101 Pins 21–30

The following pins and their associated external components/connections were worked on:

- Pin 21 – FB1
- Pin 22 – LX1
- Pin 23 – VIN1
- Pin 24 – VIN2
- Pin 25 – LX2
- Pin 26 – FB2
- Pin 27 – VBbackup
- Pin 28 – VRTC
- Pin 29 – PWROK
- Pin 30 – PWRON

The RTC_BAT 1.8 V connection was also studied from the reference schematic.

#### AXP2101 Pins 31–40

The remaining AXP2101 pins were connected:

- Pin 31 – TS
- Pin 32 – GPIO1
- Pin 33 – BAT
- Pin 34 – VSYS
- Pin 35 – SW
- Pin 36 – VIND
- Pin 37 – VBUS
- Pin 38 – IRQ
- Pin 39 – SDA
- Pin 40 – SCK

## ERC Checking

After completing the AXP2101 40-pin connections, the KiCad Electrical Rules Checker (ERC) was executed.

The initial ERC check reported:

- **96 Errors**
- **35 Warnings**

The errors were then investigated to identify connectivity issues such as:

- Pins not electrically connected.
- Wires not properly snapped to component/pin endpoints.
- Labels not connected to the intended nets.
- Power input pins without appropriate power-source indications.

ERC debugging and correction is part of the ongoing schematic verification process.

## Repository Contents

The repository currently contains the main KiCad project files:

- `T-FPGA_Reverse_Engineering.kicad_pro`
- `T-FPGA_Reverse_Engineering.kicad_sch`
- `T-FPGA_Custom_.kicad_sym`

These files contain the KiCad project configuration, schematic design, and custom symbol information used for the project.

## Current Status

- T-FPGA schematic study – Completed
- AXP2101 pin identification – Completed
- AXP2101 40-pin connections – Completed
- Supporting component connections – Completed
- Initial ERC check – Completed
- ERC error investigation – In progress
- Schematic verification and cleanup – In progress

## Future Work

- Resolve remaining ERC errors and warnings.
- Verify all electrical connections against the reference schematic.
- Check power and ground nets.
- Verify component values and connections.
- Improve schematic organization and readability.
- Perform final schematic validation.
- Document the completed reverse-engineering work.

## Author

**Kaluva Chandrashekar**

GitHub: `Chandru6`

## Project Type

**T-FPGA Reverse Engineering and AXP2101 Schematic Analysis**
