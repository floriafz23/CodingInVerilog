module part1(Clock, Enable, Clear_b, CounterValue);
	input Clock, Enable, Clear_b;
	output [7:0]CounterValue;
	wire c1, c2, c3, c4, c5, c6, c7;
	
	assign c1 = Enable & CounterValue[0];
	assign c2 = c1 & CounterValue[1];
	assign c3 = c2 & CounterValue[2];
	assign c4 = c3 & CounterValue[3];
	assign c5 = c4 & CounterValue[4];
	assign c6 = c5 & CounterValue[5];
	assign c7 = c6 & CounterValue[6];

	tff u0(Enable, Clock, Clear_b, CounterValue[0]);
	tff u1(c1, Clock, Clear_b, CounterValue[1]);
	tff u2(c2, Clock, Clear_b, CounterValue[2]);
	tff u3(c3, Clock, Clear_b, CounterValue[3]);
	tff u4(c4, Clock, Clear_b, CounterValue[4]);
	tff u5(c5, Clock, Clear_b, CounterValue[5]);
	tff u6(c6, Clock, Clear_b, CounterValue[6]);
	tff u7(c7, Clock, Clear_b, CounterValue[7]);
	
endmodule
	

module tff(T, Clock, Clear_b, Q);
	input T, Clock, Clear_b;
	output reg Q;
	
	always @(posedge Clock, negedge Clear_b)
		begin
			if(Clear_b == 0)
				Q <=0;
			else
				begin
					if(T == 0)
						Q <= Q;
					else
						Q <= ~Q;
				end
		end
endmodule 
			
