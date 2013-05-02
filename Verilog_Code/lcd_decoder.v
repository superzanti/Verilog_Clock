module lcd_decoder(
    input        clk,
	 input        [1:0] set,
	 input        [2:0] m_seconds,
	 input        [3:0] l_seconds,
	 input        [2:0] m_minutes,
	 input        [3:0] l_minutes,
	 input        [1:0] m_hours,
	 input        [3:0] l_hours,
	 input        [1:0] m_days,
	 input        [3:0] l_days,
	 input              m_months,
	 input        [3:0] l_months,
	 output reg   [87:0] lcd_value
  );

  always @(posedge clk) begin
    case (l_seconds)
	   4'b0000: lcd_value[7:0] <= 8'b00110000;
		4'b0001: lcd_value[7:0] <= 8'b00110001;
		4'b0010: lcd_value[7:0] <= 8'b00110010;
		4'b0011: lcd_value[7:0] <= 8'b00110011;
		4'b0100: lcd_value[7:0] <= 8'b00110100;
		4'b0101: lcd_value[7:0] <= 8'b00110101;
		4'b0110: lcd_value[7:0] <= 8'b00110110;
		4'b0111: lcd_value[7:0] <= 8'b00110111;
		4'b1000: lcd_value[7:0] <= 8'b00111000;
		4'b1001: lcd_value[7:0] <= 8'b00111001;
		default: lcd_value[7:0] <= 8'b00110000;
	 endcase
    case (m_seconds)
	   3'b000: lcd_value[15:8] <= 8'b00110000;
		3'b001: lcd_value[15:8] <= 8'b00110001;
		3'b010: lcd_value[15:8] <= 8'b00110010;
		3'b011: lcd_value[15:8] <= 8'b00110011;
		3'b100: lcd_value[15:8] <= 8'b00110100;
		3'b101: lcd_value[15:8] <= 8'b00110101;
		default: lcd_value[15:8] <= 8'b00110000;
	 endcase
	 case (l_minutes)
	   4'b0000: lcd_value[23:16] <= 8'b00110000;
		4'b0001: lcd_value[23:16] <= 8'b00110001;
		4'b0010: lcd_value[23:16] <= 8'b00110010;
		4'b0011: lcd_value[23:16] <= 8'b00110011;
		4'b0100: lcd_value[23:16] <= 8'b00110100;
		4'b0101: lcd_value[23:16] <= 8'b00110101;
		4'b0110: lcd_value[23:16] <= 8'b00110110;
		4'b0111: lcd_value[23:16] <= 8'b00110111;
		4'b1000: lcd_value[23:16] <= 8'b00111000;
		4'b1001: lcd_value[23:16] <= 8'b00111001;
		default: lcd_value[23:16] <= 8'b00110000;
	 endcase
	 case (m_minutes)
	   3'b000: lcd_value[31:24] <= 8'b00110000;
		3'b001: lcd_value[31:24] <= 8'b00110001;
		3'b010: lcd_value[31:24] <= 8'b00110010;
		3'b011: lcd_value[31:24] <= 8'b00110011;
		3'b100: lcd_value[31:24] <= 8'b00110100;
		3'b101: lcd_value[31:24] <= 8'b00110101;
		default: lcd_value[31:24] <= 8'b00110000;
	 endcase
	 case (l_hours)
	   4'b0000: lcd_value[39:32] <= 8'b00110000;
		4'b0001: lcd_value[39:32] <= 8'b00110001;
		4'b0010: lcd_value[39:32] <= 8'b00110010;
		4'b0011: lcd_value[39:32] <= 8'b00110011;
		4'b0100: lcd_value[39:32] <= 8'b00110100;
		4'b0101: lcd_value[39:32] <= 8'b00110101;
		4'b0110: lcd_value[39:32] <= 8'b00110110;
		4'b0111: lcd_value[39:32] <= 8'b00110111;
		4'b1000: lcd_value[39:32] <= 8'b00111000;
		4'b1001: lcd_value[39:32] <= 8'b00111001;
		default: lcd_value[39:32] <= 8'b00110000;
	 endcase
	 case (m_hours)
	   2'b00: lcd_value[47:40] <= 8'b00100000;
		2'b01: lcd_value[47:40] <= 8'b00110001;
		2'b10: lcd_value[47:40] <= 8'b00110010;
		default: lcd_value[47:40] <= 8'b00100000;
	 endcase
	 case (l_days)
	   4'b0000: lcd_value[55:48] <= 8'b00110000;
		4'b0001: lcd_value[55:48] <= 8'b00110001;
		4'b0010: lcd_value[55:48] <= 8'b00110010;
		4'b0011: lcd_value[55:48] <= 8'b00110011;
		4'b0100: lcd_value[55:48] <= 8'b00110100;
		4'b0101: lcd_value[55:48] <= 8'b00110101;
		4'b0110: lcd_value[55:48] <= 8'b00110110;
		4'b0111: lcd_value[55:48] <= 8'b00110111;
		4'b1000: lcd_value[55:48] <= 8'b00111000;
		4'b1001: lcd_value[55:48] <= 8'b00111001;
		default: lcd_value[55:48] <= 8'b00110000;
	 endcase
	 case (m_days)
	   2'b00: lcd_value[63:56] <= 8'b00110000;
		2'b01: lcd_value[63:56] <= 8'b00110001;
		2'b10: lcd_value[63:56] <= 8'b00110010;
		2'b11: lcd_value[63:56] <= 8'b00110011;
		default: lcd_value[63:56] <= 8'b00110000;
	 endcase
	 case (l_months)
	   4'b0000: lcd_value[71:64] <= 8'b00110000;
		4'b0001: lcd_value[71:64] <= 8'b00110001;
		4'b0010: lcd_value[71:64] <= 8'b00110010;
		4'b0011: lcd_value[71:64] <= 8'b00110011;
		4'b0100: lcd_value[71:64] <= 8'b00110100;
		4'b0101: lcd_value[71:64] <= 8'b00110101;
		4'b0110: lcd_value[71:64] <= 8'b00110110;
		4'b0111: lcd_value[71:64] <= 8'b00110111;
		4'b1000: lcd_value[71:64] <= 8'b00111000;
		4'b1001: lcd_value[71:64] <= 8'b00111001;
		default: lcd_value[71:64] <= 8'b00110000;
	 endcase
	 case (m_months)
      1'b0: lcd_value[79:72] <= 8'b00100000;
		1'b1: lcd_value[79:72] <= 8'b00110001;
		default: lcd_value[79:72] <= 8'b00100000;
	 endcase
	 case (set)
	   2'b00: lcd_value[87:80] <= 8'b01010100;
		2'b01: lcd_value[87:80] <= 8'b01010011;
		2'b10: lcd_value[87:80] <= 8'b01000001;
		default: lcd_value[87:80] <= 8'b00100000;
	 endcase
  end


endmodule
