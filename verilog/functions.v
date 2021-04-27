//-- List of functions

/*
 * ROTL32(v, n) returns the value of the 32-bit unsigned value v after
 * a rotation of n bits to the left.
 * /!\ When compared to the refenrece C implementation, mask on 32 bit was
 * removed
 */

function [31:0] ROTL32;

//-- INPUTS
input  [31:0] v;
input  [4:0] n;

begin
  ROTL32 = (v << n) | (v  >> (32 - n));
end

endfunction

/*==========================================================================*/
/* DISPERSION - Rotations Pi1
/*==========================================================================*/

function [127:0] PI1;

//-- INPUTS
input [127:0] a;

begin
PI1 = {
	ROTL32(a[127:96], 2),
	ROTL32(a[95:64], 5),
	ROTL32(a[63:32], 1), 
	a[31:0]
	}; 
end

endfunction

/*==========================================================================*/
/* DISPERSION - Rotations Pi2
/*==========================================================================*/

function [127:0] PI2;

//-- INPUTS
input [127:0] a;

begin
PI2 = {
	ROTL32(a[127:96], 30),
	ROTL32(a[95:64], 27),
	ROTL32(a[63:32], 31), 
	a[31:0]
	}; 
end

endfunction

/*==========================================================================*/
/* The shift register that computes round constants - Forward Shift
/*   if ((*RC)&0x80) (*RC)=((*RC)<<1) ^ 0x1B; else (*RC)<<=1;
/*==========================================================================*/
function [7:0] RCSHIFTREGFWD;

//-- INPUTS
input [7:0] rc;

begin
	if ((rc & 8'h80) != 8'h00)
	RCSHIFTREGFWD = (rc << 1) ^ 8'h1B;
	else
	RCSHIFTREGFWD = (rc << 1);
end

endfunction

/*==========================================================================*/
/* The shift register that computes round constants - Backward Shift
/*==========================================================================*/
function [7:0] RCSHIFTREGBWD;

//-- INPUTS
input [7:0] rc;

begin
	if ((rc & 8'h01) != 8'h00)
	RCSHIFTREGBWD = (rc >> 1) ^ 8'h8D;
	else
	RCSHIFTREGBWD = (rc >> 1);
end

endfunction
