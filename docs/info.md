<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Explain how your project works
- In this project, we have made a sequence detector using finite state machine (FSM)
- This is made using verilog, and detects sequence '1001'
- The logic is made using cases, and it makes sure to detect the sequence while covering overlapping case as well

## How to test

Explain how to use your project
- If the sequence is detected, the output is set to logic 1 that displays '8' on 7-segment display
- If the sequence is not detected or the output is 0, 7-segment display shows '-'

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
- We need to use LED display for 7-segment display output so that the output can be confirmed
- In addition to this, we need to use an input source from which we can manipulate input logic onto the input register
