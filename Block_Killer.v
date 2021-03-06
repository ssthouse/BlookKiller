module Block_Killer
(
	//clock & reset
	input CLK_50M,
	input RSTn,
	
	//keyboard clk & data
	input ps2k_clk,
	input ps2k_data,

	//vga horizontal syn & vertical syn
	output hsync,
	output vsync,
	//vga data output
	output [2:0] color_out,//RGB
	
	//********************no use***************
	//output [7:0] seg_out,//数码管段选
	//output [3:0] sel,//数码管位选
	
	//led
	output [2:0] led_out,
	//BCD
	output  [6:0] data2,
	output   [6:0] data1,
	output beep
	
);


//****************************out code *****************************

	//game signal
	wire game_over;
	wire left;
	wire right;
	
	//btns
	wire left_key_down;
	wire right_key_down;
	wire down_key_down;
	//keyboard: p & r
	wire play_key_down;
	wire restart_key_down;

	//game state
	wire [1:0] game_state;
	
	//color data
	wire [23:0] column_0;
	wire [23:0] column_1;
	wire [23:0] column_2;
	wire [23:0] column_3;

	//SCORE
	wire [7:0] cube_num_b;
	wire  cube_num_t;
	//todo: test
	wire [2:0] temp_led;
	
	State_Ctrl state_ctrl
	(
		//clk ret_n
		.CLK_50M(CLK_50M),
		.RST_N(RSTn),
		//input that affecs state
		.game_start(play_key_down),
		.game_over(game_over),
		.game_reset(restart_key_down),
		// game signal
		.game_state(game_state),
		//todo test
		.led(temp_led)
	);


	Keyboard_Ctrl keyboard_ctrl
	(
		.CLK_50M(CLK_50M),
		.RST_N(RSTn),
		//data & state,
		.ps2_byte(ps2_byte),
		.ps2_state(ps2_state),
		//左 右 下  回车
		.left_key_press(left_key_down),
		.right_key_press(right_key_down),
		.down_key_press(down_key_down),
		.play_key_press(play_key_down),
		.restart_key_press(restart_key_down)
	);

	//score
	wire [11:0] score;

	Display_Ctrl display_ctrl
	(
		.CLK_50M(CLK_50M),
		.RST_N(RSTn),
		//state & score
		.game_state(game_state),
		.score(score),
		//color data
		.column_0(column_0),
		.column_1(column_1),
		.column_2(column_2),
		.column_3(column_3),
		//score
		.Score(cube_num_b),
		//vga out
		.hsync(hsync),
		.vsync(vsync),
		.vga_rgb(color_out)
	);

	//game core module
	Game_Ctrl game_ctrl
	(
		.led(led_out),
		.CLK_50M(CLK_50M),
		.RST_N(RSTn),
		//game state
		.game_state(game_state),
		//key control
		.left_key_press(left_key_down),
		.right_key_press(right_key_down),
		.down_key_press(down_key_down),
		//output color data
		.column_0(column_0),
		.column_1(column_1),
		.column_2(column_2),
		.column_3(column_3),
		//game signal
		.game_over(game_over),
		//score
		.cube_num_O(cube_num_b),
		.cube_num_k(cube_num_k),
		.cube_num_h(cube_num_h),
		.score(score)
	);
	
	//BCD
	
	 Score_Disp  score_disp 
	(
		.CLK_50M(CLK_50M),
		.RSTn(RSTn),
		.score_k(cube_num_k),
		.score_h(cube_num_h),
		.game_state(game_state),
		 .data1(data1),
		 .data2(data2)
	);
	wire [1:0] voice;
   Beep music
  (
  .clk(CLK_50M),
  .beep(beep),
  .game_state(game_state),
  .voice(voice)
  );
	
//****************************our code *****************************

	
	
/***************************************************************************/


wire [7:0]ps2_byte;
wire ps2_state;
wire led;
wire [3:0]wei;
wire [7:0]seg;

ps2_top U7
	(
		.clk(CLK_50M),
		.rst(RSTn),
		.ps2k_clk(ps2k_clk),
		.ps2k_data(ps2k_data),
		.ps2_byte(ps2_byte),
		.ps2_state(ps2_state),
		.led(led),
		.wei(wei),
		.seg(seg)
	);

	
endmodule
