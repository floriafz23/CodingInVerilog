module RateDivider(Speed, ClockIn, Clear_b, Out);
	input [1:0]Speed;
	input	ClockIn, Clear_b;
	output reg [10:0] Out;
	reg [10:0] d;
	
	always @(Speed)
	begin
	case (Speed)
		2'b00: d <= 11'b00000000000;
		2'b01: d <= 11'b00111110011;
		2'b10: d <= 11'b01111100111;
		2'b11: d <= 11'b11111001111;
		default: d <= 11'b00000000000;
	endcase
	end
	
	always@ (posedge ClockIn)
	begin
		if(Clear_b)
			Out <= 11'b00000000000;
		else if (Out == 11'b00000000000)				
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
	wire [10:0] RateDividerCounter;		
	
	RateDivider u0(Speed, ClockIn, Reset, RateDividerCounter);

	assign Enable = (RateDividerCounter == 11'b00000000000) ? 1 : 0;
	
	counter c1 (ClockIn, ~Reset, Enable, CounterValue);
	
endmodule



