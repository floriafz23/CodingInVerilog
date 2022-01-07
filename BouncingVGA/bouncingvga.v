
// part 3
module part3(iColour,iResetn,iClock,oX,oY,oColour,oPlot);
	
	input wire [2:0] iColour;
	input wire iResetn, iClock;
	
	output wire [7:0] oX;
	output wire [6:0] oY;
	output wire [2:0] oColour;
	output wire oPlot;
	
	parameter X_SCREENSIZE = 160, Y_SCREENSIZE = 120, CLOCKS_PER_SECOND = 5000, X_BOXSIZE = 8'd4, Y_BOXSIZE = 7'd4, X_MAX = X_SCREENSIZE - 1 - X_BOXSIZE, Y_MAX = Y_SCREENSIZE - 1 - Y_BOXSIZE, PULSES_PER_SIXTIETH_SECOND = CLOCKS_PER_SECOND / 60;
	
	wire Frame_next_ld, Create_enable, Black_enable, Move_enable, Count_enable;
	wire [3:0] Counter;
	
	RateDivider u0(iClock, iResetn, PULSES_PER_SIXTIETH_SECOND, Count_enable);
	FrameCounter u1(iClock, iResetn, Count_enable, Frame_next_ld);
	datapath u2(iClock, iResetn, iColour, X_MAX, Y_MAX, oX, oY, oColour, Counter, Create_enable, Black_enable, Move_enable);
	controlpath u3(iClock, iResetn, Counter, Frame_next_ld, oPlot, Create_enable, Black_enable, Move_enable);

endmodule


// rate divider
module RateDivider(Clock, Resetn, Frame_num, Enable);
	
	input Clock, Resetn;
	input [31:0] Frame_num; 
	
	output reg Enable;
	
	reg [6:0] Divider;
	
	
	always @(posedge Clock)
		if(!Resetn)
			Divider = 0;
		else if(Divider == (Frame_num - 1))
			Divider = 0;
		else 
			Divider = Divider + 1;
		
		
	always @(posedge Clock)
		if(!Resetn)
			Enable = 0;
		else if(Divider == (Frame_num - 1))
			Enable = 1;
		else 
			Enable = 0;

endmodule


// frame counter
module FrameCounter(Clock, Resetn, Enable, Frame_next_enable);
	input Clock, Resetn, Enable;
	
	output reg Frame_next_enable;
	
	reg [3:0] Counter;
	
	always @(posedge Clock)
		if(!Resetn)
			Counter = 4'b0000;
		else if(Counter == 4'b1111)
			Counter = 0;
		else if(Enable)
			Counter = Counter + 1;
			
	always @(posedge Clock)
		if(!Resetn)
			Frame_next_enable = 0;
		else if(Counter == 4'b1111)
			Frame_next_enable = 1;
		else if(Enable)
			Frame_next_enable = 0;

endmodule 


// datapath
module datapath(Clock, Resetn, Color, Width_max, Height_max, X_out, Y_out, Color_out, Counter, Create_enable, Black_enable, Move_enable);
	
	input Clock, Resetn, Create_enable, Black_enable, Move_enable;
	input [2:0] Color;
	input [6:0] Height_max;
	input [7:0] Width_max;
	
	output reg [2:0] Color_out;	
	output reg [3:0] Counter;
	output reg [6:0] Y_out;
	output reg [7:0] X_out;

	reg [1:0] Direction;
	reg [14:0] Location;
	
	
	always @ (posedge Clock)
	begin
		if (Resetn == 0)
			Location <= 0;
		else if (Create_enable == 1)
			begin
				X_out <= Location[7:0] + Counter[1:0];
				Y_out <= Location[14:8] + Counter[3:2];
				Color_out <= Color;
			end
		else if (Black_enable == 1)
			begin
				X_out <= Location[7:0] + Counter[1:0];
				Y_out <= Location[14:8] + Counter[3:2];
				Color_out <= 0;
			end
		else if (Move_enable == 1)
			begin
				if(Direction[0] == 1'b1)
					Location[7:0] <= Location[7:0] + 1;
				else
					Location[7:0] <= Location[7:0] - 1;
				if(Direction[1] == 1'b1)
					Location[14:8] <= Location[14:8] + 1;
				else
					Location[14:8] <= Location[14:8] - 1;
			end
	end

	
	always @ (posedge Clock)
		begin
			if (Resetn == 1'b0)
				Direction <= 2'b11;
			else
				begin
					if (Location[7:0] == 0)
						Direction[0] <= 1'b1;
					if (Location[7:0] == Width_max)
						Direction[0] <= 1'b0;
					if (Location[14:8] == 0)
						Direction[1] <= 1'b1;
					if (Location[14:8] == Height_max)
						Direction[1] <= 1'b0;
				end
		end
    
	
	always @ (posedge Clock)
		begin
			if (Resetn == 0)
				Counter <= 4'b0000;
			else if (Counter == 4'b1111)
				Counter <= 4'b0000;
			else if (Create_enable == 1 || Black_enable == 1)
				Counter <= Counter + 1;
		end

endmodule


//control path
module controlpath(Clock, Resetn, Counter, Frame_next, Plot_enable, Create_enable, Black_enable, Move_enable);
	
	input Clock, Resetn, Frame_next;
	input [3:0] Counter;
	
	output reg  Plot_enable, Create_enable, Black_enable, Move_enable;
	
	parameter S_DRAW = 2'd0, S_WAIT = 2'd1, S_DELETE = 2'd2, S_MOVE = 2'd3;
	
	reg [1:0]   now, next;
	
	
	always @(*)
		begin
			case (now)
				S_DRAW: next = Counter == 4'b1111 ? S_WAIT : now;
				S_WAIT: next = Frame_next ? S_DELETE : now;
				S_DELETE: next = Counter == 4'b1111 ? S_MOVE : now;
				S_MOVE: next = S_DRAW;
				default: next = S_DRAW;
			endcase
		end
	
	
	always @(*)
		begin
			Create_enable = 0;
			Black_enable = 0;
			Move_enable = 0;
			
			case (now)
				S_DRAW: 
					begin
						Create_enable = 1;
						Plot_enable = 1;
					end   
				S_DELETE: 
					begin
						Black_enable = 1;
						Plot_enable = 1;
					end
				S_MOVE: 
					begin
						Move_enable = 1;
						Plot_enable = 0;
					end
			endcase
		end
	
	
	always @ (posedge Clock)
		begin
			if (Resetn == 0) 
				now <= S_DRAW;
			else
				now <= next;
		end

endmodule


