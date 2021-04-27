/*==========================================================================*/
/*==========================================================================*/

module round
        #( parameter KEY_SIZE=128,
        parameter BLOCK_SIZE=128) (
  input wire [KEY_SIZE-1:0] k_in,
  input wire [BLOCK_SIZE/16-1:0] rc1,
  input wire [BLOCK_SIZE/16-1:0] rc2,
  input wire [BLOCK_SIZE-1:0] a_in,
  output wire [BLOCK_SIZE-1:0] a_out
);

`include "functions.v"

wire [BLOCK_SIZE-1:0] a1;
wire [BLOCK_SIZE-1:0] a2;

theta #(.KEY_SIZE(KEY_SIZE),
        .BLOCK_SIZE(BLOCK_SIZE)) i_theta (
	.k_in(k_in),
	.a_in(a_in ^ {{BLOCK_SIZE*15/16{1'b0}}, rc1}),
	.a_out(a1)
);

gamma #(.BLOCK_SIZE(BLOCK_SIZE)) i_gamma (
	.a_in(PI1(a1 ^ {{BLOCK_SIZE*15/16{1'b0}}, rc2})),
	.a_out(a2)
);

assign a_out = PI2(a2);

endmodule
