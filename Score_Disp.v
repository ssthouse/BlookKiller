module Score_Disp
(
	input CLK_50M,
	input RSTn,
	input score_h,
	input score_k,
	//input btn_start,
	input [1:0] game_state,
	
	output reg [6:0] data1,
	output reg [6:0] data2
);

localparam STATE_OVER =  2'b10;
localparam STATE_START = 2'b00;

reg [4:0] units;
reg [4:0] tens;
reg [6:0] temp;
reg [31:0] clk_cnt;

//seg 为0的时候会亮
always@(posedge CLK_50M or negedge RSTn)
begin
    if (!RSTn)    
		begin
		   clk_cnt <= 0;
			data1 <= 7'b1111111;
			data2 <= 7'b1111111;
			units <= 0;
			tens <= 0;
			temp <= 0;
		end
	else if(game_state == STATE_START || game_state == STATE_OVER)
		begin
		   clk_cnt <= 0;
			data1 <= 7'b1111111;
			data2 <= 7'b1111111;
			units <= 0;
			tens <= 0;
			temp <= 0;			
		end
	else
		begin
			clk_cnt <= clk_cnt + 1;
			if(clk_cnt == 32'd30_000_000)
			begin
				clk_cnt <= 0;
				if(score_k == 1)
					begin
						temp <= temp + 1;
					end
				if(score_h == 1)
					begin
						temp <= temp + 4;
					end
				units <= (temp % 10);
				if(temp >= 10)
					begin
						tens <= (temp - temp % 10) / 10;
					end
				else
					begin
						tens <= 0;
					end
			case(units)
			
				10'd0:	data1 <= 7'b1000000;    //0-亮  1-灭
				10'd1:	data1 <= 7'b1111001;
				10'd2:	data1 <= 7'b0100100;
				10'd3:	data1 <= 7'b0110000;
				10'd4:	data1 <= 7'b0011001;
				10'd5:	data1 <= 7'b0010010;
				10'd6:	data1 <= 7'b0000010;
				10'd7:	data1 <= 7'b1111000;
				10'd8:	data1 <= 7'b0000000;
				10'd9:	data1 <= 7'b0010000;
				default: data1 <= 7'b1000000;  //0
				
			endcase
			
			case(tens)
			
				10'd0:	data2 <= 7'b1000000;    //0-亮  1-灭
				10'd1:	data2 <= 7'b1111001;
				10'd2:	data2 <= 7'b0100100;
				10'd3:	data2 <= 7'b0110000;
				10'd4:	data2 <= 7'b0011001;
				10'd5:	data2 <= 7'b0010010;
				10'd6:	data2 <= 7'b0000010;
				10'd7:	data2 <= 7'b1111000;
				10'd8:	data2 <= 7'b0000000;
				10'd9:	data2 <= 7'b0010000;
				default: data2 <= 7'b1000000;  //0
				
			endcase
		end
	end
end


endmodule


