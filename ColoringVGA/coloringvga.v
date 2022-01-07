
//connecting the datapath and control path

module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot);
   
	parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;
   
   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;
   
   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;  // Pixel draw enable
	
	wire X_enable, Y_enable, Color_enable, Counter_enable;

   controlpath C0(iClock,iResetn,iLoadX, iPlotBox, X_enable, Y_enable, Color_enable, Counter_enable, oPlot);	
	datapath d0(iClock, iResetn, iXY_Coord, iColour, oPlot, iBlack, X_enable, Y_enable, oX, oY, Counter_enable, Color_enable, oColour);
   
endmodule


// fsm datapath
module datapath(Clock, Resetn, XYCoordinates, Color, Plot, Black, X_enable, Y_enable, X_Coordinates, Y_Coordinates, Counter_enable, Color_enable, Color_Out);
	
	input Clock, Resetn, Plot, Black, X_enable, Y_enable, Color_enable, Counter_enable;
	input [6:0] XYCoordinates;
	input [2:0] Color;
	
	reg [3:0] Counter;
	reg [2:0] temp_color;
	reg [7:0] temp_x; 
	reg [6:0] temp_y;
	
	output reg [7:0] X_Coordinates;
	output reg [6:0] Y_Coordinates;
	output reg [2:0] Color_Out;

	always@(posedge Clock)
	begin
		if(Resetn == 1'b0)
			Counter <= 4'b0;
		else if(Counter == 4'b1111)
			Counter <= 4'b0;
		else if(Counter_enable == 1'b1)
			Counter <= Counter + 1; 
	end
	
	always@(posedge Clock)
	begin
		if(Resetn == 1'b0)
			temp_x <= 8'b0;	
		else if (X_enable == 1'b1)
			temp_x <= {1'b0, XYCoordinates};
	end
	

	always@(posedge Clock)
	begin
		if(Resetn == 1'b0)
			temp_y <= 7'b0;
		else if (Y_enable == 1'b1)
			temp_y <= XYCoordinates;
	end	

	always@(posedge Clock)
	begin
		if(Resetn == 1'b0)
			temp_color <= 3'b0;
		else if(Black == 1)
			temp_color <= 3'b0;
		else if (Color_enable == 1'b1)
			temp_color <= Color;
	end	
		
	always @(posedge Clock)
	begin
		if(Resetn == 1'b0)
			begin
				X_Coordinates <= 0;
				Y_Coordinates <= 0;
				Color_Out <= 0;
			end
		else if(Plot == 1'b1)
			begin
				X_Coordinates <= temp_x + Counter[1:0];
				Y_Coordinates <= temp_y + Counter[3:2];
				Color_Out <= temp_color;
			end
	end

endmodule


// control path
module controlpath(Clock, Resetn, LoadX, PlotBox, X_enable, Y_enable, Color_enable, Counter_enable, Plot);

	localparam S_LOAD_X = 3'd0, S_LOAD_X_WAIT = 3'd1, S_LOAD_Y_COLOUR = 3'd2, S_LOAD_Y_WAIT = 3'd3, S_DRAW = 3'd4;
	
	input Clock, Resetn, LoadX, PlotBox;
	
	output reg X_enable, Y_enable, Color_enable;
	output reg Counter_enable;
	output reg Plot;
	
	reg [3:0] now, next;
	
	
	always@(*)
	begin: state_table
		case(now)
			S_LOAD_X: next = LoadX ? S_LOAD_X_WAIT : S_LOAD_X;
			S_LOAD_X_WAIT: next = LoadX ? S_LOAD_X_WAIT : S_LOAD_Y_COLOUR;
			S_LOAD_Y_COLOUR: next = PlotBox ? S_LOAD_Y_WAIT : S_LOAD_Y_COLOUR;
			S_LOAD_Y_WAIT: next = PlotBox ? S_LOAD_Y_WAIT : S_DRAW;
			S_DRAW: next = LoadX ? S_LOAD_X : S_DRAW;
			default next = S_LOAD_X;
		endcase
	end
	
	always@(posedge Clock)
	begin
		if(Resetn == 1'b0)
			now <= S_LOAD_X;
		else 
			now <= next;
	end
	
	always @(*)
   begin: enable_signals
       X_enable = 0;
		 Y_enable = 0;
		 Color_enable = 0;
		 Plot = 0;

       case (now)
           S_LOAD_X_WAIT: 
					begin
						X_enable = 1'b1;
               end
           S_LOAD_Y_COLOUR: 
					begin
						Y_enable = 1'b1;
						Color_enable = 1'b1;
               end
           S_DRAW: 
					begin 
						Plot = 1'b1;
						Counter_enable = 1'b1;
					end
        endcase
    end 
	
	

endmodule
