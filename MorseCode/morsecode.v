module mux2to1(x, y, s, m);
    input x, y, s; 
    output m; 
  
    assign m = s ? y : x;

endmodule

module RateDivider(ClockIn, Reset, Enable); 
	input ClockIn, Reset;
	output reg Enable;
	reg [10:0]counter;
	
	always @(posedge ClockIn, negedge Reset)
		begin
			if(Reset == 1'b0)
				begin 
					Enable <= 1'b0; 
					counter <= 11'b00011111001; 
				end
			else if(Enable == 1'b1)
				begin 
					Enable <= ~Enable; 
					counter <= 11'b00011111001; 
				end 
			else if(counter == 11'b00000000001)
				Enable <= 1'b1;
			else 
				counter <= counter-1;
	end
	
endmodule 

module dff(D, Clock, Resetn, Q); 
	input D, Clock, Resetn;
	output reg Q;
	always @(posedge Clock, negedge Resetn)
		begin
			if(Resetn == 1'b1)
				Q <= 0;
			else
				Q <= D;
		end
endmodule 

module dffWithMux(D, Loadn, LoadLeft, Right, Left, Resetn, Clock, Q);
	input D, Loadn, LoadLeft, Right, Left, Resetn, Clock;
	output Q;
	wire c1, c2; 
	
	mux2to1 M1(Right, Left, LoadLeft, c1);
	mux2to1 M2(D, c1,Loadn, c2);
	dff ff0(c2, Clock, Resetn, Q);
	
endmodule

module shiftReg(Clock, Reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q, Enable);
	input Clock, Reset, ParallelLoadn, RotateRight, ASRight, Enable;
	input [11:0]Data_IN;
	output [11:0]Q;
	
	dffWithMux u0(Data_IN[0], ParallelLoadn, RotateRight, Q[11], Q[0], Reset, Clock, Q[0]);
	dffWithMux u1(Data_IN[1], ParallelLoadn, RotateRight, Q[0], Q[1], Reset, Clock, Q[1]);
	dffWithMux u2(Data_IN[2], ParallelLoadn, RotateRight, Q[1], Q[2], Reset, Clock, Q[2]);
	dffWithMux u3(Data_IN[3], ParallelLoadn, RotateRight, Q[2], Q[3], Reset, Clock, Q[3]);
	dffWithMux u4(Data_IN[4], ParallelLoadn, RotateRight, Q[3], Q[4], Reset, Clock, Q[4]);
	dffWithMux u5(Data_IN[5], ParallelLoadn, RotateRight, Q[4], Q[5], Reset, Clock, Q[5]);
	dffWithMux u6(Data_IN[6], ParallelLoadn, RotateRight, Q[5], Q[6], Reset, Clock, Q[6]);
	dffWithMux u7(Data_IN[7], ParallelLoadn, RotateRight, Q[6], Q[7], Reset, Clock, Q[7]);
	dffWithMux u8(Data_IN[8], ParallelLoadn, RotateRight, Q[7], Q[8], Reset, Clock, Q[8]);
	dffWithMux u9(Data_IN[9], ParallelLoadn, RotateRight, Q[8], Q[9], Reset, Clock, Q[9]);
	dffWithMux u10(Data_IN[10], ParallelLoadn, RotateRight, Q[9], Q[10], Reset, Clock, Q[10]);
	dffWithMux u11(Data_IN[11], ParallelLoadn, RotateRight, Q[10], Q[11], Reset, Clock, Q[11]);
	
endmodule


module part3(ClockIn, Resetn, Start, Letter, DotDashOut);
	input ClockIn, Resetn, Start;
	input [2:0]Letter;
	output DotDashOut;
	reg [11:0]alphabet;

	wire Enable;
	wire [11:0]shift;
	reg rotationToLeft;

	
	always @(*)
		begin
			case (Letter[2:0])
				3'b000: alphabet = 12'b010111000000;
				3'b001: alphabet = 12'b011101010100;
				3'b010: alphabet = 12'b011101011101;
				3'b011: alphabet = 12'b011101010000;
				3'b100: alphabet = 12'b010000000000;
				3'b101: alphabet = 12'b010101110100;
				3'b110: alphabet = 12'b011101110100;
				3'b111: alphabet = 12'b010101010000;
				default: alphabet = 12'b010111000000;
			endcase
		end
	
	RateDivider u0(ClockIn, Resetn, Enable);
	
	always @(posedge ClockIn, negedge Resetn)
		begin 
			if(Resetn == 1'b0)
				rotationToLeft <= 1'b0;
			else if(Enable == 1'b1)
				rotationToLeft <= 1'b1;
			else
				rotationToLeft <= 1'b0;
		end
	
	shiftReg u1(ClockIn, ~Resetn, ~Start, ~rotationToLeft, 0, alphabet, shift, Enable);
	
	assign DotDashOut = shift[11];

endmodule


