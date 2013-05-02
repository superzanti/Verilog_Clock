module rtc(
    input ROT_A,
    input ROT_B,
    input ROT_CENTER,
    input minute_set,
    input hour_set,
    input day_set,
    input alarm_set,
    input clk,
	 input reset,
	 output reg alarm_on,
	 output reg [5:0] alarm_led,
    output lcd_rs,
    output lcd_rw,
    output lcd_7,
    output lcd_6,
    output lcd_5,
    output lcd_4,
    output lcd_e
  );

  wire [87:0] lcd_value;
  wire hundred_clk;
  
  wire event_rot_l;
  wire event_rot_r;
  
  reg second_clk;
  reg minute_clk;
  reg hour_clk;
  reg day_clk;
  reg [1:0] mode = 2'b00;
  reg [5:0] sec_count = 6'b000000;
  reg alarm_start = 1'b0;
  reg [6:0] alarm_count = 7'b0000000;
  
  reg        [2:0] m_seconds = 3'b000;
  reg        [3:0] l_seconds = 4'b0000;
  reg        [2:0] m_minutes = 3'b000;
  reg        [3:0] l_minutes = 4'b0000;
  reg        [1:0] m_hours = 2'b00;
  reg        [3:0] l_hours = 4'b0000;
  reg        [1:0] m_days = 2'b00;
  reg        [3:0] l_days = 4'b0001;
  reg        [3:0] months = 4'b0001;
  
  reg        [2:0] sm_seconds = 3'b000;
  reg        [3:0] sl_seconds = 4'b0000;
  reg        [2:0] sm_minutes = 3'b000;
  reg        [3:0] sl_minutes = 4'b0000;
  reg        [1:0] sm_hours = 2'b00;
  reg        [3:0] sl_hours = 4'b0000;
  reg        [1:0] sm_days = 2'b00;
  reg        [3:0] sl_days = 4'b0001;
  reg        [3:0] smonths = 4'b0001;
  
  reg        [2:0] am_seconds = 3'b000;
  reg        [3:0] al_seconds = 4'b0000;
  reg        [2:0] am_minutes = 3'b000;
  reg        [3:0] al_minutes = 4'b0000;
  reg        [1:0] am_hours = 2'b00;
  reg        [3:0] al_hours = 4'b0000;
  reg        [1:0] am_days = 2'b00;
  reg        [3:0] al_days = 4'b0001;
  reg        [3:0] amonths = 4'b0001;
  
  reg        [2:0] cm_seconds = 3'b000;
  reg        [3:0] cl_seconds = 4'b0000;
  reg        [2:0] cm_minutes = 3'b000;
  reg        [3:0] cl_minutes = 4'b0000;
  reg        [1:0] cm_hours = 2'b00;
  reg        [3:0] cl_hours = 4'b0000;
  reg        [1:0] cm_days = 2'b00;
  reg        [3:0] cl_days = 4'b0001;
  reg              cm_months = 1'b0;
  reg        [3:0] cl_months = 4'b0001;
  
  spinner knob(ROT_A,ROT_B,clk,event_rot_l,event_rot_r);
  
  always @(posedge second_clk) begin
    if (ROT_CENTER) begin
      mode <= mode + 1;
      if (mode == 2'b10)
	     mode <= mode + 2;
    end
  end

  Clock100 timer(clk,reset,hundred_clk);
  
  always @(posedge hundred_clk or posedge reset) begin
    if (reset) begin
	   sec_count <= 6'b000000;
	 end else begin
      if (reset | sec_count == 6'b110001) begin
	     sec_count <= 6'b000000;
		  second_clk <= ~second_clk;
  	   end
	   else
	     sec_count <= sec_count + 1;
	 end
  end

// Normal Clock
  always @ (posedge second_clk or posedge reset)
  begin
    l_seconds <= l_seconds + 1;
	 minute_clk <= 1'b0;
	 if (reset) begin
	   l_seconds <= sl_seconds;
		m_seconds <= sm_seconds;
	 end else begin
	   if (l_seconds == 4'b1001 && m_seconds == 3'b101) begin
	     l_seconds <= 4'b0000;
	  	  m_seconds <= 3'b000;
		  minute_clk <= 1'b1;
	   end else if (l_seconds == 4'b1001) begin
		  l_seconds <= 4'b0000;
		  m_seconds <= m_seconds + 1;
	   end
	 end
  end
  

  always @ (posedge minute_clk or posedge reset)
  begin
    l_minutes <= l_minutes + 1;
	 hour_clk <= 1'b0;
	 if (reset) begin
	   l_minutes <= sl_minutes;
		m_minutes <= sm_minutes;
	 end else begin
	   if (l_minutes == 4'b1001 && m_minutes == 3'b101) begin
	     l_minutes <= 4'b0000;
	  	  m_minutes <= 3'b000;
		  hour_clk <= 1'b1;
	   end else if (l_minutes == 4'b1001) begin
		  l_minutes <= 4'b0000;
		  m_minutes <= m_minutes + 1;
	   end
	 end
  end
  
 
  always @ (posedge hour_clk or posedge reset)
  begin
    l_hours <= l_hours + 1;
	 day_clk <= 1'b0;
	 if (reset) begin
	   l_hours <= sl_hours;
		m_hours <= sm_hours;
	 end else begin
	   if (l_hours == 4'b0011 && m_hours == 3'b010) begin
	     l_hours <= 4'b0000;
	  	  m_hours <= 3'b000;
		  day_clk <= 1'b1;
	   end else if (l_hours == 4'b1001) begin
		  l_hours <= 4'b0000;
		  m_hours <= m_hours + 1;
	   end
	 end
  end
  
  always @ (posedge day_clk or posedge reset)
  begin
    l_days <= l_days + 4'b1;
	 if (reset) begin
	   l_days <= sl_days;
		m_days <= sm_days;
		months <= smonths;
	 end else begin
      case (months)
		  1,3,5,7,8,10: begin
	         if (l_days == 4'b0001 && m_days == 2'b11) begin
	           l_days <= 4'b0001;
	        	  m_days <= 2'b00;
				  months <= months + 1;
	         end else if (l_days == 4'b1010) begin
		        l_days <= 4'b0000;
		        m_days <= m_days + 1;
	         end
		    end
		  4,6,9,11: begin
	         if (m_days == 2'b11) begin
	           l_days <= 4'b0001;
	        	  m_days <= 2'b00;
				  months <= months + 1;
	         end else if (l_days == 4'b1010) begin
		        l_days <= 4'b0000;
		        m_days <= m_days + 1;
	         end
		    end
		  2: begin
	         if (l_days == 4'b1000 && m_days == 2'b10) begin
	           l_days <= 4'b0001;
	        	  m_days <= 2'b00;
				  months <= months + 1;
	         end else if (l_days == 4'b1010) begin
		        l_days <= 4'b0000;
		        m_days <= m_days + 1;
	         end
		    end
		  12: begin
	         if (l_days == 4'b0001 && m_days == 2'b11) begin
	           l_days <= 4'b0001;
	        	  m_days <= 2'b00;
				  months <= 4'b0001;
	         end else if (l_days == 4'b1010) begin
		        l_days <= 4'b0000;
		        m_days <= m_days + 1;
	         end
		    end
		endcase
	 end
  end
  
// Set Clock
  always @ (negedge clk)
  begin
    if (mode == 2'b01) begin
    case ({day_set,hour_set,minute_set})
	   3'b000: begin
		    if (event_rot_l) begin
			   sl_seconds <= sl_seconds + 1;
 			   if (sl_seconds == 4'b1001 && sm_seconds == 3'b101) begin
			     sl_seconds <= 4'b0000;
			     sm_seconds <= 3'b000;
			   end else if (sl_seconds == 4'b1001) begin
			     sl_seconds <= 4'b0000;
			     sm_seconds <= sm_seconds + 1;
			   end
		    end else if (event_rot_r) begin
				    sl_seconds <= sl_seconds - 1;
			   if (sl_seconds == 4'b0000 && sm_seconds == 3'b000) begin
			     sl_seconds <= 4'b1001;
			     sm_seconds <= 3'b101;
			   end else if (sl_seconds == 4'b0000) begin
			     sl_seconds <= 4'b1001;
			     sm_seconds <= sm_seconds - 1;
			   end
		    end
	     end
	   3'b001: begin
		    if (event_rot_l) begin
			   sl_minutes <= sl_minutes + 1;
 			   if (sl_minutes == 4'b1001 && sm_minutes == 3'b101) begin
			     sl_minutes <= 4'b0000;
			     sm_minutes <= 3'b000;
			   end else if (sl_minutes == 4'b1001) begin
			     sl_minutes <= 4'b0000;
			     sm_minutes <= sm_minutes + 1;
			   end
		    end else if (event_rot_r) begin
				    sl_minutes <= sl_minutes - 1;
			   if (sl_minutes == 4'b0000 && sm_minutes == 3'b000) begin
			     sl_minutes <= 4'b1001;
			     sm_minutes <= 3'b101;
			   end else if (sl_minutes == 4'b0000) begin
			     sl_minutes <= 4'b1001;
			     sm_minutes <= sm_minutes - 1;
			   end
		    end
		  end
		3'b010,3'b011: begin
		    if (event_rot_l) begin
			   sl_hours <= sl_hours + 1;
 			   if (sl_hours == 4'b0011 && sm_hours == 2'b10) begin
			     sl_hours <= 4'b0000;
			     sm_hours <= 2'b00;
			   end else if (sl_hours == 4'b1001) begin
			     sl_hours <= 4'b0000;
			     sm_hours <= sm_hours + 1;
			   end
		    end else if (event_rot_r) begin
				    sl_hours <= sl_hours - 1;
			   if (sl_hours == 4'b0000 && sm_hours == 2'b00) begin
			     sl_hours <= 4'b0011;
			     sm_hours <= 2'b10;
			   end else if (sl_hours == 4'b0000) begin
			     sl_hours <= 4'b1001;
			     sm_hours <= sm_hours - 1;
			   end
		    end
		  end
		3'b100,3'b101,3'b110,3'b111: begin
		    if (event_rot_l) begin
			 sl_days <= sl_days + 4'b1;
			 case (smonths)
			   1,3,5,7,8,10: begin
				 	 if (sl_days == 4'b0001 && sm_days == 2'b11) begin
					   sl_days <= 4'b0001;
					   sm_days <= 2'b00;
					   smonths <= smonths + 1;
					 end else if (sl_days == 4'b1001) begin
					   sl_days <= 4'b0000;
					   sm_days <= sm_days + 1;
					 end
				  end
			   4,6,9,11: begin
					 if (sm_days == 2'b11) begin
					   sl_days <= 4'b0001;
					   sm_days <= 2'b00;
					   smonths <= smonths + 1;
					 end else if (sl_days == 4'b1001) begin
					   sl_days <= 4'b0000;
					   sm_days <= sm_days + 1;
					 end
				  end
			   2: begin
					 if (sl_days == 4'b1000 && sm_days == 2'b10) begin
					   sl_days <= 4'b0001;
					   sm_days <= 2'b00;
					   smonths <= smonths + 1;
					 end else if (sl_days == 4'b1001) begin
					   sl_days <= 4'b0000;
					   sm_days <= sm_days + 1;
					 end
				  end
			   12: begin
					 if (sl_days == 4'b0001 && sm_days == 2'b11) begin
					   sl_days <= 4'b0001;
					   sm_days <= 2'b00;
					   smonths <= 4'b0001;
					 end else if (sl_days == 4'b1001) begin
					   sl_days <= 4'b0000;
					   sm_days <= sm_days + 1;
					 end
				  end
			 endcase
		    end
		    if (event_rot_r) begin
			 sl_days <= sl_days - 4'b1;
			 case (smonths)
			   2,4,6,8,9,11: begin
				 	 if (sl_days == 4'b0001 && sm_days == 2'b00) begin
					   sl_days <= 4'b0001;
					   sm_days <= 2'b11;
					   smonths <= smonths - 1;
					 end else if (sl_days == 4'b0000) begin
					   sl_days <= 4'b1001;
					   sm_days <= sm_days - 1;
					 end
				  end
			   5,7,10,12: begin
					 if (sm_days == 2'b00 && sl_days == 4'b0001) begin
					   sl_days <= 4'b0001;
					   sm_days <= 2'b11;
					   smonths <= smonths - 1;
					 end else if (sl_days == 4'b0000) begin
					   sl_days <= 4'b1001;
					   sm_days <= sm_days - 1;
					 end
				  end
			   3: begin
					 if (sl_days == 4'b0001 && sm_days == 2'b00) begin
					   sl_days <= 4'b1000;
					   sm_days <= 2'b10;
					   smonths <= smonths - 1;
					 end else if (sl_days == 4'b0000) begin
					   sl_days <= 4'b1001;
					   sm_days <= sm_days - 1;
					 end
				  end
			   1: begin
					 if (sl_days == 4'b0001 && sm_days == 2'b00) begin
					   sl_days <= 4'b0001;
					   sm_days <= 2'b11;
					   smonths <= 4'b1100;
					 end else if (sl_days == 4'b0000) begin
					   sl_days <= 4'b1001;
					   sm_days <= sm_days - 1;
					 end
				  end
			 endcase
		    end
		  end
	 endcase
	 end
  end
  
// Set Alarm
  always @ (negedge clk)
  begin
    if (mode == 2'b10) begin
    case ({day_set,hour_set,minute_set})
	   3'b000: begin
		    if (event_rot_l) begin
			   al_seconds <= al_seconds + 1;
 			   if (al_seconds == 4'b1001 && am_seconds == 3'b101) begin
			     al_seconds <= 4'b0000;
			     am_seconds <= 3'b000;
			   end else if (al_seconds == 4'b1001) begin
			     al_seconds <= 4'b0000;
			     am_seconds <= am_seconds + 1;
			   end
		    end else if (event_rot_r) begin
				    al_seconds <= al_seconds - 1;
			   if (al_seconds == 4'b0000 && am_seconds == 3'b000) begin
			     al_seconds <= 4'b1001;
			     am_seconds <= 3'b101;
			   end else if (al_seconds == 4'b0000) begin
			     al_seconds <= 4'b1001;
			     am_seconds <= am_seconds - 1;
			   end
		    end
	     end
	   3'b001: begin
		    if (event_rot_l) begin
			   al_minutes <= al_minutes + 1;
 			   if (al_minutes == 4'b1001 && am_minutes == 3'b101) begin
			     al_minutes <= 4'b0000;
			     am_minutes <= 3'b000;
			   end else if (al_minutes == 4'b1001) begin
			     al_minutes <= 4'b0000;
			     am_minutes <= am_minutes + 1;
			   end
		    end else if (event_rot_r) begin
				    al_minutes <= al_minutes - 1;
			   if (al_minutes == 4'b0000 && am_minutes == 3'b000) begin
			     al_minutes <= 4'b1001;
			     am_minutes <= 3'b101;
			   end else if (al_minutes == 4'b0000) begin
			     al_minutes <= 4'b1001;
			     am_minutes <= am_minutes - 1;
			   end
		    end
		  end
		3'b010,3'b011: begin
		    if (event_rot_l) begin
			   al_hours <= al_hours + 1;
 			   if (al_hours == 4'b0011 && am_hours == 2'b10) begin
			     al_hours <= 4'b0000;
			     am_hours <= 2'b00;
			   end else if (al_hours == 4'b1001) begin
			     al_hours <= 4'b0000;
			     am_hours <= am_hours + 1;
			   end
		    end else if (event_rot_r) begin
				    al_hours <= al_hours - 1;
			   if (al_hours == 4'b0000 && am_hours == 2'b00) begin
			     al_hours <= 4'b0011;
			     am_hours <= 2'b10;
			   end else if (al_hours == 4'b0000) begin
			     al_hours <= 4'b1001;
			     am_hours <= am_hours - 1;
			   end
		    end
		  end
		3'b100,3'b101,3'b110,3'b111: begin
		    if (event_rot_l) begin
			 al_days <= al_days + 4'b1;
			 case (amonths)
			   1,3,5,7,8,10: begin
				 	 if (al_days == 4'b0001 && am_days == 2'b11) begin
					   al_days <= 4'b0001;
					   am_days <= 2'b00;
					   amonths <= amonths + 1;
					 end else if (al_days == 4'b1001) begin
					   al_days <= 4'b0000;
					   am_days <= am_days + 1;
					 end
				  end
			   4,6,9,11: begin
					 if (am_days == 2'b11) begin
					   al_days <= 4'b0001;
					   am_days <= 2'b00;
					   amonths <= amonths + 1;
					 end else if (al_days == 4'b1001) begin
					   al_days <= 4'b0000;
					   am_days <= am_days + 1;
					 end
				  end
			   2: begin
					 if (al_days == 4'b1000 && am_days == 2'b10) begin
					   al_days <= 4'b0001;
					   am_days <= 2'b00;
					   amonths <= amonths + 1;
					 end else if (al_days == 4'b1001) begin
					   al_days <= 4'b0000;
					   am_days <= am_days + 1;
					 end
				  end
			   12: begin
					 if (al_days == 4'b0001 && am_days == 2'b11) begin
					   al_days <= 4'b0001;
					   am_days <= 2'b00;
					   amonths <= 4'b0001;
					 end else if (al_days == 4'b1001) begin
					   al_days <= 4'b0000;
					   am_days <= am_days + 1;
					 end
				  end
			 endcase
		    end
		    if (event_rot_r) begin
			 al_days <= al_days - 4'b1;
			 case (amonths)
			   2,4,6,8,9,11: begin
				 	 if (al_days == 4'b0001 && am_days == 2'b00) begin
					   al_days <= 4'b0001;
					   am_days <= 2'b11;
					   amonths <= amonths - 1;
					 end else if (al_days == 4'b0000) begin
					   al_days <= 4'b1001;
					   am_days <= am_days - 1;
					 end
				  end
			   5,7,10,12: begin
					 if (am_days == 2'b00 && al_days == 4'b0001) begin
					   al_days <= 4'b0001;
					   am_days <= 2'b11;
					   amonths <= amonths - 1;
					 end else if (al_days == 4'b0000) begin
					   al_days <= 4'b1001;
					   am_days <= am_days - 1;
					 end
				  end
			   3: begin
					 if (al_days == 4'b0001 && am_days == 2'b00) begin
					   al_days <= 4'b1000;
					   am_days <= 2'b10;
					   amonths <= amonths - 1;
					 end else if (al_days == 4'b0000) begin
					   al_days <= 4'b1001;
					   am_days <= am_days - 1;
					 end
				  end
			   1: begin
					 if (al_days == 4'b0001 && am_days == 2'b00) begin
					   al_days <= 4'b0001;
					   am_days <= 2'b11;
					   amonths <= 4'b1100;
					 end else if (al_days == 4'b0000) begin
					   al_days <= 4'b1001;
					   am_days <= am_days - 1;
					 end
				  end
			 endcase
		    end
		  end
	 endcase
	 end
  end
  
// Alarm Function

  always @(posedge clk) begin
    if(al_minutes == l_minutes && am_minutes == m_minutes && al_hours == l_hours && am_minutes == m_minutes && alarm_set)
	   alarm_start <= 1'b1;
	 else
	   alarm_start <= 1'b0;
  end
  
  always @(posedge hundred_clk) begin
    alarm_on <= alarm_set;
    if (alarm_start == 1'b1) begin
	   alarm_count <= alarm_count + 1;
	   alarm_led <= {alarm_count[6:4],alarm_count[6:4]};
	 end else begin
	   alarm_count <= 7'b0000000;
	   alarm_led <= 6'b000000;
    end		
  end

// Which gets displayed?  
  always @(posedge clk) begin
    case (mode)
	   2'b00: begin
		    cl_seconds <= l_seconds;
			 cm_seconds <= m_seconds;
			 cl_minutes <= l_minutes;
			 cm_minutes <= m_minutes;
			 cl_hours <= l_hours;
			 cm_hours <= m_hours;
			 cl_days <= l_days;
			 cm_days <= m_days;
          if (months >= 10) begin
	         cl_months <= months - 10;
		      cm_months <= 1'b1;
	       end else begin
	         cl_months <= months;
		      cm_months <= 1'b0;
	       end
		  end
		2'b01: begin
		    cl_seconds <= sl_seconds;
			 cm_seconds <= sm_seconds;
			 cl_minutes <= sl_minutes;
			 cm_minutes <= sm_minutes;
			 cl_hours <= sl_hours;
			 cm_hours <= sm_hours;
			 cl_days <= sl_days;
			 cm_days <= sm_days;
          if (smonths >= 10) begin
	         cl_months <= smonths - 10;
		      cm_months <= 1'b1;
	       end else begin
	         cl_months <= smonths;
		      cm_months <= 1'b0;
	       end
		  end
		2'b10: begin
		    cl_seconds <= al_seconds;
			 cm_seconds <= am_seconds;
			 cl_minutes <= al_minutes;
			 cm_minutes <= am_minutes;
			 cl_hours <= al_hours;
			 cm_hours <= am_hours;
			 cl_days <= al_days;
			 cm_days <= am_days;
          if (amonths >= 10) begin
	         cl_months <= amonths - 10;
		      cm_months <= 1'b1;
	       end else begin
	         cl_months <= amonths;
		      cm_months <= 1'b0;
	       end
		  end
	   default: begin
		    cl_seconds <= l_seconds;
			 cm_seconds <= m_seconds;
			 cl_minutes <= l_minutes;
			 cm_minutes <= m_minutes;
			 cl_hours <= l_hours;
			 cm_hours <= m_hours;
			 cl_days <= l_days;
			 cm_days <= m_days;
          if (months >= 10) begin
	         cl_months <= months - 10;
		      cm_months <= 1'b1;
	       end else begin
	         cl_months <= months;
		      cm_months <= 1'b0;
	       end
		  end
    endcase
  end
  
  lcd_decoder decoder(clk,mode,cm_seconds,cl_seconds,cm_minutes,cl_minutes,cm_hours,cl_hours,cm_days,cl_days,cm_months,cl_months,lcd_value[87:0]);
  lcd_display display(clk,lcd_value[87:0],lcd_rs,lcd_rw,lcd_e,lcd_4,lcd_5,lcd_6,lcd_7);

endmodule
