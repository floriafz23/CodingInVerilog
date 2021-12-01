`timescale 1ns / 1ps
`default_nettype none

module main	(
	input wire CLOCK_50,            //On Board 50 MHz
	input wire [9:0] SW,            // On board Switches
	input wire [3:0] KEY,           // On board push buttons
	output wire [6:0] HEX0,         // HEX displays
	output wire [6:0] HEX1,         
	output wire [6:0] HEX2,         
	output wire [6:0] HEX3,         
	output wire [6:0] HEX4,         
	output wire [6:0] HEX5,         
	output wire [9:0] LEDR,         // LEDs
	output wire [7:0] x,            // VGA pixel coordinates
	output wire [6:0] y,
	output wire [2:0] colour,       // VGA pixel colour (0-7)
	output wire plot,               // Pixel drawn when this is pulsed
	output wire vga_resetn          // VGA resets to black when this is pulsed (NOT CURRENTLY AVAILABLE)
);    
	
	wire [3:0] CounterValue;
	
	part2 u0(CLOCK_50, SW[9], SW[1:0], CounterValue);
	hex_decoder u1(CounterValue, HEX1);

	

endmodule

module RateDivider(Speed, ClockIn, Clear_b, Out);
	input [1:0]Speed;
	input	ClockIn, Clear_b;
	output reg [26:0] Out;
	reg [26:0] d;
	
	always @(Speed)
	begin
	case (Speed)
		2'b00: d <= 27'b0;
		2'b01: d <= 27'b001011111010111100000111111;
		2'b10: d <= 27'b010111110101111000001111111;
		2'b11: d <= 27'b101111101011110000011111111;
		default: d <= 27'b0;
	endcase
	end
	
	always@ (posedge ClockIn)
	begin
		if(Clear_b)
			Out <= 0;
		else if (Out == 0)				
			Out <= d;
		else  
			Out <= Out - 1;
		end
	
endmodule

module counter(Clock, Clear_b, Enable, q);
	input Clock, Clear_b, Enable;
	output reg[3:0] q;
	
	always@(posedge Clock)
		begin
			if(Clear_b  == 0)
				q <= 0;
			else if(Enable)
				q <= q + 1;
		end

endmodule 


module part2(ClockIn, Reset, Speed, CounterValue);
	input ClockIn, Reset;
	input [1:0] Speed;
	output [3:0] CounterValue;
	
	wire Enable;
	wire [26:0] RateDividerCounter;		
	
	RateDivider u0(Speed, ClockIn, Reset, RateDividerCounter);

	assign Enable = (RateDividerCounter == 0) ? 1 : 0;
	
	counter c1 (ClockIn, ~Reset, Enable, CounterValue);
	
endmodule

module hex_decoder(c, display);
	input [3:0] c;
	output reg [6:0] display;
	
	always @*
		begin
			case(c)
				4'b0000: display = 7'b1000000;
				4'b0001: display = 7'b1111001;
				4'b0010: display = 7'b0100100;
				4'b0011: display = 7'b0110000;
				4'b0100: display = 7'b0011001;
				4'b0101: display = 7'b0010010;
				4'b0110: display = 7'b0000010;
				4'b0111: display = 7'b1111000;
				4'b1000: display = 7'b0000000;
				4'b1001: display = 7'b0010000;
				4'b1010: display = 7'b0001000;
				4'b1011: display = 7'b0000011;
				4'b1100: display = 7'b1000110;
				4'b1101: display = 7'b0100001;
				4'b1110: display = 7'b0000110;
				4'b1111: display = 7'b0001110;
			endcase
		end
	
endmodule
	



