/*==========================================================================*/
/*==========================================================================*/

module commonloop
	#( parameter KEY_SIZE=128,
	parameter BLOCK_SIZE=128,
	parameter NROUND=16) (
  input wire [BLOCK_SIZE-1:0] a_in,
  input wire [BLOCK_SIZE/16-1:0] rc1_in,
  input wire [BLOCK_SIZE/16-1:0] rc2_in,
  input wire [KEY_SIZE-1:0] k_in,
  input mode,
  output wire [BLOCK_SIZE-1:0] a_out
);

`include "functions.v"

genvar j;

wire [BLOCK_SIZE-1:0] a [NROUND+2:0];
wire [BLOCK_SIZE/16-1:0] rc1 [NROUND:0];
wire [BLOCK_SIZE/16-1:0] rc2 [NROUND:0];

wire [KEY_SIZE-1:0] k_dec;
wire [KEY_SIZE-1:0] k_round;

assign a[0] = a_in;
assign rc1[0] = rc1_in;
assign rc2[0] = rc2_in;

//-- for decryption only: Encrypt k_in with NullVector working key

theta #(.KEY_SIZE(KEY_SIZE),
        .BLOCK_SIZE(BLOCK_SIZE)) i1_theta (
	.k_in({BLOCK_SIZE{1'b0}}),
	.a_in(k_in),
	.a_out(k_dec)
	);

assign k_round = ~mode ? k_in : k_dec;

generate
  for (j = 1 ; j <= NROUND ; j = j + 1) begin
    assign rc1[j] = ~mode ? RCSHIFTREGFWD(rc1[j-1]) : {BLOCK_SIZE/16{1'b0}};
    assign rc2[j] = ~mode ? {BLOCK_SIZE/16{1'b0}} : RCSHIFTREGBWD(rc2[j-1]);
  end
endgenerate

//-- Round 0 to Round NROUND-1
generate
  for (j = 0 ; j < NROUND ; j = j + 1) begin

round #(.KEY_SIZE(KEY_SIZE),
        .BLOCK_SIZE(BLOCK_SIZE)) i_round (
	.k_in(k_round),
	.rc1(rc1[j]),
	.rc2(rc2[j]),
	.a_in(a[j]),
	.a_out(a[j+1])
	);

  end
endgenerate

//-- /!\ rc1 has an effect at encryption only

assign a[NROUND+1] = a[NROUND] ^ {{BLOCK_SIZE*15/16{1'b0}}, rc1[NROUND]};

theta #(.KEY_SIZE(KEY_SIZE),
        .BLOCK_SIZE(BLOCK_SIZE)) i0_theta (
	.k_in(k_round),
	.a_in(a[NROUND+1]),
	.a_out(a[NROUND+2])
	);

//-- /!\ rc2 has an effect at decryption only

assign a_out = a[NROUND+2] ^ {{BLOCK_SIZE*15/16{1'b0}}, rc2[NROUND]};

endmodule
