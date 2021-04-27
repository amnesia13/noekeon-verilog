/*==========================================================================*/
/*--------------------------------------------------------------------------*/
/* NONLINEAR - gamma, involution
/*--------------------------------------------------------------------------*/
/* Input of i_th s-box = (i3)(i2)(i1)(i0), with (i3) = i_th bit of a[3]
 *                                              (i2) = i_th bit of a[2]
 *                                              (i1) = i_th bit of a[1]
 *                                              (i0) = i_th bit of a[0]
 *
 * gamma = NLIN o LIN o NLIN : (i3)(i2)(i1)(i0) --> (o3)(o2)(o1)(o0)
 *
 * NLIN ((i3) = (o3) = (i3)                     NLIN is an involution
 *       (i2)   (o2)   (i2)                      i.e. evaluation order of i1 & i0
 *       (i1)   (o1)   (i1+(~i3.~i2))                 can be swapped
 *       (i0))  (o0)   (i0+(i2.i1))
 *
 *  LIN ((i3) = (o3) = (0.i3+0.i2+0.i1+  i0)    LIN is an involution
 *       (i2)   (o2)   (  i3+  i2+  i1+  i0)
 *       (i1)   (o1)   (0.i3+0.i2+  i1+0.i0)
 *       (i0))  (o0)   (  i3+0.i2+0.i1+0.i0)
 *
/*==========================================================================*/

module gamma 
         #( parameter BLOCK_SIZE=128) (
  input wire [BLOCK_SIZE-1:0] a_in,
  output wire [BLOCK_SIZE-1:0] a_out
);

reg [BLOCK_SIZE/4-1:0] a [3:0];
reg [BLOCK_SIZE/4-1:0] tmp;

always @(*)
begin

  a[0] = a_in[BLOCK_SIZE/4-1:0];
  a[1] = a_in[BLOCK_SIZE/2-1:BLOCK_SIZE/4];
  a[2] = a_in[BLOCK_SIZE*3/4-1:BLOCK_SIZE/2];
  a[3] = a_in[BLOCK_SIZE-1:BLOCK_SIZE*3/4];

  /* first non-linear step in gamma */
  a[1] = a[1] ^ ~a[3] & ~a[2];
  a[0] = a[0] ^ a[2] & a[1];

  /* linear step in gamma */
  tmp   = a[3];
  a[3]  = a[0];
  a[0]  = tmp;
  a[2] = a[2] ^ a[0] ^ a[1] ^ a[3];

  /* last non-linear step in gamma */
  a[1] = a[1] ^ ~a[3] & ~a[2];
  a[0] = a[0] ^ a[2] & a[1];

end

assign a_out = {a[3], a[2], a[1], a[0]};

endmodule
