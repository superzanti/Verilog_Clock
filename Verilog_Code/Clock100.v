module Clock100(ClkIn,Clr_,Clk100);
  input ClkIn; // 50 MHz input
  input Clr_; // Clear all registers
  output reg Clk100; // Clock frequency

  reg [3:0] clk_div; // Set up a divider for the clock
  reg [13:0] clk_div100; // Set up the 100 Hz buffer counter

  always @(posedge ClkIn) // Pre-Scaler
  begin
    clk_div <= clk_div + 4'b1;
  end

  always @(posedge clk_div[3]) // Generate 100 Hz clock
  begin
    if (Clr_ == 1'b1 | clk_div100 == 14'b11110100001001)
      begin
        clk_div100 <= 14'b0;
        Clk100 <= ~Clk100;
      end
    else
      clk_div100 <= clk_div100 + 19'b1;
  end

endmodule