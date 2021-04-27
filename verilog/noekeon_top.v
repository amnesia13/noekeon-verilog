module noekeon_top
#( parameter KEY_SIZE=128,
	parameter BLOCK_SIZE=128,
	parameter NROUND=16) (
  input mode, //-- crypto mode 0=enc, 1=dec
  input [BLOCK_SIZE-1:0] plaintext, //-- 128-bit plaintext block
  input [KEY_SIZE-1:0] key, //-- 128-bit key
  output wire [BLOCK_SIZE-1:0] ciphertext //-- 128-bit ciphered block
);

`include "functions.v"

wire [BLOCK_SIZE-1:0] a_in;
wire [KEY_SIZE-1:0] k_in;
wire [BLOCK_SIZE-1:0] a_out;

reg [BLOCK_SIZE/16-1:0] rc1;
reg [BLOCK_SIZE/16-1:0] rc2;

assign a_in = {
  plaintext[BLOCK_SIZE/4-1:0],
  plaintext[BLOCK_SIZE/2-1:BLOCK_SIZE/4],
  plaintext[BLOCK_SIZE*3/4-1:BLOCK_SIZE/2],
  plaintext[BLOCK_SIZE-1:BLOCK_SIZE*3/4]
	};


assign k_in = {
  key[BLOCK_SIZE/4-1:0],
  key[BLOCK_SIZE/2-1:BLOCK_SIZE/4],
  key[BLOCK_SIZE*3/4-1:BLOCK_SIZE/2],
  key[BLOCK_SIZE-1:BLOCK_SIZE*3/4]
	};


always @(*)
	begin
	rc1 = ~mode ? 8'h80 : 8'h00;
	rc2 = ~mode ? 8'h00 : 8'hD4;
	end

commonloop #( .KEY_SIZE(KEY_SIZE),
	.BLOCK_SIZE(BLOCK_SIZE),
	.NROUND(NROUND)) i_commonloop (
    .a_in(a_in),
    .rc1_in(rc1),
    .rc2_in(rc2),
    .k_in(k_in),
    .mode(mode),
    .a_out(a_out)
    );

assign ciphertext = {
 a_out[BLOCK_SIZE/4-1:0],
 a_out[BLOCK_SIZE/2-1:BLOCK_SIZE/4],
 a_out[BLOCK_SIZE*3/4-1:BLOCK_SIZE/2],
 a_out[BLOCK_SIZE-1:BLOCK_SIZE*3/4]
	};

endmodule
