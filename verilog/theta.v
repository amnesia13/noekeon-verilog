/*==========================================================================*/
/* DIFFUSION - Linear step THETA, involution
/*==========================================================================*/

module theta
	 #( parameter KEY_SIZE=128,
            parameter BLOCK_SIZE=128) (
  input wire [KEY_SIZE-1:0] k_in,
  input wire [BLOCK_SIZE-1:0] a_in,
  output wire [BLOCK_SIZE-1:0] a_out
);
 
`include "functions.v"

reg [BLOCK_SIZE/4-1:0] k [3:0];
reg [BLOCK_SIZE/4-1:0] a [3:0];
reg [BLOCK_SIZE/4-1:0] tmp;

always @(*)
begin
	a[0] = a_in[BLOCK_SIZE/4-1:0];
	a[1] = a_in[BLOCK_SIZE/2-1:BLOCK_SIZE/4];
	a[2] = a_in[BLOCK_SIZE*3/4-1:BLOCK_SIZE/2];
	a[3] = a_in[BLOCK_SIZE-1:BLOCK_SIZE*3/4];

	k[0] = k_in[BLOCK_SIZE/4-1:0];
        k[1] = k_in[BLOCK_SIZE/2-1:BLOCK_SIZE/4];
        k[2] = k_in[BLOCK_SIZE*3/4-1:BLOCK_SIZE/2];
        k[3] = k_in[BLOCK_SIZE-1:BLOCK_SIZE*3/4];

	tmp = a[0] ^ a[2];
	tmp = tmp ^ ROTL32(tmp, 8) ^ ROTL32(tmp, 24);

	a[1] = a[1] ^ tmp;
	a[3] = a[3] ^ tmp;

	a[0] = a[0] ^ k[0];
	a[1] = a[1] ^ k[1];
	a[2] = a[2] ^ k[2];
	a[3] = a[3] ^ k[3];

	tmp = a[1] ^ a[3];
	tmp = tmp ^ ROTL32(tmp, 8) ^ ROTL32(tmp, 24);

	a[0] = a[0] ^ tmp;
	a[2] = a[2] ^ tmp;
end

assign a_out = {a[3], a[2], a[1], a[0]};

endmodule
