module SCORE_Display
	(
		input iVGA_CLK,
		input iRST_n,
		input [9:0]iVGA_X,
		input [9:0]iVGA_Y,
		input [9:0]STRING_START,
		input [9:0]STRING_START_, 
		output reg [2:0]oRGB		
	);
parameter STRING_START_X = 350;
parameter STRING_START_Y = 300;
parameter STRING_WDITH   = 120;
parameter STRING_HEIGHT  = 48; 

wire [12:0] Addr;
reg  [12:0] Addr_Res;
assign Addr = Addr_Res;

wire Pixel_Out;

always@(posedge iVGA_CLK)
begin
	if(!iRST_n)
		begin
			oRGB <= 3'b000;
			Addr_Res <= 0;
		end
	else
		begin
			if((iVGA_X >= STRING_START_X && iVGA_X <= STRING_START_X + STRING_WDITH -1) 
			&&(iVGA_Y >= STRING_START_Y && iVGA_Y <= STRING_START_Y + STRING_HEIGHT - 1))
				begin
					Addr_Res <= (iVGA_X - STRING_START_X) + (iVGA_Y - STRING_START_Y) * STRING_WDITH;
					if(Pixel_Out) 
						oRGB <= 3'b001;
					else 
						oRGB <= 3'b000;
				end
			else
				begin
					Addr_Res <= 0;
					oRGB <= 3'b000;
				end	
		end
end
SCORE_Rom SCORE_Rom_Display
	(
		.address(Addr),
		.clock(iVGA_CLK),
		.q(Pixel_Out)
	);	               

endmodule