module fulladder(a,b,cin,s,cout);

	input a,b,cin;
	output s,cout;
	
	assign s = cin^a^b;
	assign cout = (a&b)|(cin&a)|(cin&b);
	
endmodule

module rippleadder(a, b, c_in, s, c_out);
	
	input [3:0]a,b;
	input c_in;
	output [3:0]s;
	output [3:0]c_out;
	
	fulladder u0(a[0],b[0],c_in,s[0],c_out[0]);
	fulladder u1(a[1],b[1],c_out[0],s[1],c_out[1]);
	fulladder u2(a[2],b[2],c_out[1],s[2],c_out[2]);
	fulladder u3(a[3],b[3],c_out[2],s[3],c_out[3]);

endmodule

module part2(Clock, Reset_b, Data, Function, ALUout);

	input [3:0] Data;
	input Reset_b, Clock;
	input [2:0] Function;
	
	output reg[7:0]ALUout;
	reg [7:0]ALUtemp;
	
	wire [3:0]Data_b;
	assign Data_b = ALUout[3:0];

	wire [3:0]sum, c_out;
	rippleadder u0(Data,Data_b,0, sum, c_out);
	
	wire[4:0]sum2;
	assign sum2 = Data + Data_b; 
		
	
	always @(*)
	begin
		case(Function[2:0])
			3'b000: ALUtemp = {3'b0, c_out[3], sum};
			3'b001: ALUtemp = {3'b0, sum2};
			3'b010: ALUtemp = {{4{Data_b[3]}}, Data_b};
			3'b011: ALUtemp = (Data|Data_b) ? 8'b00000001 : 8'b0;
			3'b100: ALUtemp = ((&Data) & (&Data_b)) ? 8'b00000001 : 8'b0;
			3'b101: ALUtemp = {4'b0000,Data_b} << Data;	
			3'b110: ALUtemp = Data * Data_b;
			3'b111: ALUtemp = ALUout;
			default: ALUtemp = 8'b0;
		endcase
	end	


	always @(posedge Clock)
	begin
		if(Reset_b == 1'b0)
		
			ALUout <= 8'b00000000;
		else
			ALUout <= ALUtemp;
	end


endmodule
		
		
