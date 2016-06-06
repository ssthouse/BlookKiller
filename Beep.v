module Beep
( 
input [1:0] game_state,
input [1:0] voice,
input clk,
input RST_N,
output reg beep
);

reg [31:0] count;
reg [31:0] count1;
reg [20:0] n=40000;
reg [20:0] k=0;

   always@(posedge clk )  
   begin 
   case(game_state)     
    00:begin
   if ( count < n/2 ) 
   begin 
   count <= count + 1; 
   end 
    else if(n < 170000 && count == n/2) 
       begin 
        count <= 0; 
        n <=n+500;
       beep <= ~beep; 
       end  
    else
    begin 
         count <= 0; 
       beep <= ~beep; 
       n <= 40000;
        
      end 
   end 
   01:begin
   if ( count == 31'd40000 && voice == 3 )
		 begin 
			 count <= 0;
			 beep <= ~beep; 
		 end 
    else  
		   begin 
		  count <= count + 1; 
		  if(count > 31'd40000) 
		  begin
		  count <= 0; 
		  end 
        end 
    end
   10:begin
   if ( count < 31'd30000) 
   begin 
   count <= count + 1; 
   end 
    else  
       begin 
        count <= 0; 
       beep <= ~beep; 
       end  
   end        
  endcase 
  end
endmodule 
