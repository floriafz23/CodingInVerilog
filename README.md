# CodingInVerilog

This repository contains projects written in Verilog (Hardware Design Language) from September 2021 to December 2021. 


### ArithmeticLogicUnit

This Arithmetic Logic Unit (ALU) takes in input and performs a variety of functions, including addition, sign extension, comparison, and multiplication. This ALU features a ripple-carry adder, and its output is stored in an 8-bit register. 

### BouncingVGA

This Finite State Machine (FSM) takes in inputs for color (in terms of RGB) and animates a 4 x 4 pixel square in a VGA adapter to bounce around the screen. 

### ColoringVGA

This Finite State Machine (FSM) takes in inputs for color (in terms of RGB), X-location, and Y-location in order to change the color of a 4 x 4 pixel square in a VGA adapter. 

### MorseCode

Using the RateDivider, this circuit implements a Morse code encoder using a lookup table (LUT) to store codes and a shift register. It takes user input as an alphabetic letter from A to H and flashes it in Morse on the seven-segment display. 

### PolynomialFSM

This Finite State Machine (FSM) implements ALUs, multiplexers, and registers in its datapath in order to load the polynomial expression AX^2 + BX + C into the final register. 

### RateDivider

This circuit repeatedly cycles through outputting the hexademical values 0 through F in a 7-segment display. Based on user input, the speed at which the circuit cycles through varies. Using a rate divider, the circuit can count once every clock period (either 500 Hz or 50 MHz), once a second, once every two seconds, or once every four seconds. 

### SynchronousCounter

Using T-type flip-flops, this is a 40bit synchronous counter, with the value of the counter comprised of the outputs of the flip flops. The least significant bit is placed on the left-most flip-flop, nd the counter increments its value on each positive edge of the clock if Enable is high. 


