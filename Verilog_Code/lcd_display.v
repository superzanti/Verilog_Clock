// synthesis attribute STEPPING top "ES"
module lcd_display (clk, value, lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7);
parameter       n = 26;
parameter       k = 17;
input           clk;
input           [87:0] value;
reg             [n-1:0] count = 0;
reg             lcd_busy = 1'b1;
reg             lcd_stb;
reg             [5:0] lcd_code = 6'b000000;
//reg             [87:0] value = 88'b0010000000100000001000000010000000100000001000000010000000100000001000000010000000100000;
output reg      lcd_rs;
output reg      lcd_rw;
output reg      lcd_7;
output reg      lcd_6;
output reg      lcd_5;
output reg      lcd_4;
output reg      lcd_e;


  always @ (posedge clk) begin
    count <= count + 1;
    case (count[k+8:k+2])
       0: lcd_code <= 6'b000010;           // function set
       1: lcd_code <= 6'b000010;
       2: lcd_code <= 6'b001100;
       3: lcd_code <= 6'b000000;           // display on/off control
       4: lcd_code <= 6'b001100;
       5: lcd_code <= 6'b000000;           // display clear
       6: lcd_code <= 6'b000001;
       7: lcd_code <= 6'b000000;           // entry mode set
       8: lcd_code <= 6'b000110;
		 9: lcd_code <= 6'b000000;           //clear display
		10: lcd_code <= 6'b000001;
      11: lcd_code <= 6'b001000;           //cursor position
      12: lcd_code <= 6'b000000;
      13: lcd_code <= {2'b10,value[87:84]};        // 1 Set or Space
      14: lcd_code <= {2'b10,value[83:80]};
      15: lcd_code <= 6'b100010;           // 2 Space
      16: lcd_code <= 6'b100000;
      17: lcd_code <= {2'b10,value[79:76]};        // 3 most month
      18: lcd_code <= {2'b10,value[75:72]};
      19: lcd_code <= {2'b10,value[71:68]};        // 4 least month
      20: lcd_code <= {2'b10,value[67:64]};
		21: lcd_code <= 6'b100010;           // 5 hyphen
      22: lcd_code <= 6'b101101;
      23: lcd_code <= {2'b10,value[63:60]};        // 6 most day
      24: lcd_code <= {2'b10,value[59:56]};
      25: lcd_code <= {2'b10,value[55:52]};        // 7 least day
      26: lcd_code <= {2'b10,value[51:48]};
      27: lcd_code <= 6'b100010;           // 8 space
      28: lcd_code <= 6'b100000;
		29: lcd_code <= {2'b10,value[47:44]};        // 9 most hour
      30: lcd_code <= {2'b10,value[43:40]};
      31: lcd_code <= {2'b10,value[39:36]};        // 10 least hour
      32: lcd_code <= {2'b10,value[35:32]};
      33: lcd_code <= 6'b100011;           // l1 collon
      34: lcd_code <= 6'b101010;
      35: lcd_code <= {2'b10,value[31:28]};        // 12 most minute
      36: lcd_code <= {2'b10,value[27:24]};
		37: lcd_code <= {2'b10,value[23:20]};        // 13 least minute
      38: lcd_code <= {2'b10,value[19:16]};
      39: lcd_code <= 6'b100011;           // 14 collon
      40: lcd_code <= 6'b101010;
      41: lcd_code <= {2'b10,value[15:12]};        // 15 most second
      42: lcd_code <= {2'b10,value[11:8]};
      43: lcd_code <= {2'b10,value[7:4]};          // 16 least second
      44: lcd_code <= {2'b10,value[3:0]};
		45: count[k+8:k+2] <= 7'b0001011;
      default: begin
		  count[k+8:k+2] <= 7'b0001011;
		  //value <= lcd_value;
		end
    endcase
    if (lcd_rw)
      lcd_busy <= 0;
    lcd_stb <= ^count[k+1:k+0] & ~lcd_rw & lcd_busy;  // clkrate / 2^(k+2)
    {lcd_e,lcd_rs,lcd_rw,lcd_7,lcd_6,lcd_5,lcd_4} <= {lcd_stb,lcd_code};
  end
endmodule