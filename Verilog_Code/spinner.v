`timescale 1 ns / 1 ps

module spinner
  (
  input  wire        sync_rot_a,
  input  wire        sync_rot_b,
  input  wire        clk,
  output reg         event_rot_l,
  output reg         event_rot_r 
  );

  reg                rotary_q1;
  reg                rotary_q2;
  reg                rotary_q1_dly;
  reg                rotary_q2_dly;

  always @(posedge clk)
  begin : filter
    case ({sync_rot_b, sync_rot_a})
      0: rotary_q1 <= 1'b0;
      1: rotary_q2 <= 1'b0;
      2: rotary_q2 <= 1'b1;
      3: rotary_q1 <= 1'b1;
    endcase
    rotary_q1_dly <= rotary_q1;
    rotary_q2_dly <= rotary_q2;
    event_rot_l <=  rotary_q2_dly && !rotary_q1_dly && rotary_q1;
    event_rot_r <= !rotary_q2_dly && !rotary_q1_dly && rotary_q1;
  end

endmodule