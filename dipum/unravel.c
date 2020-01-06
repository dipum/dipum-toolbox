/*===================================================================
* unravel.c
* Decodes a variable length coded bit sequence (a vector of
* 16-bit integers) using a binary sort from the MSB to the LSB
* (across word boundaries) based on a transition table.
*==================================================================*/
#include "mex.h"
void unravel(uint16_T *hx, double *link, double *x,
    double xsz, int hxsz)
{
   int i = 15, j = 0, k = 0, n = 0;     /* Start at root node, 1st */
                                        /* hx bit and x element */
   while (xsz - k)   {                  /* Do until x is filled */
   if (*(link + n) > 0)   {             /* Is there a link? */
      if ((*(hx + j) >> i) & 0x0001)    /* Is bit a 1? */
         n = *(link + n);               /* Yes, get new node */
      else n = *(link + n) - 1;         /* It's 0 so get new node */
      if (i) i--; else {j++; i = 15;}   /* Set i, j to next bit */
      if (j > hxsz)                     /* Bits left to decode? */
         mexErrMsgIdAndTxt("DIPUM:TooFewBits","Out of code bits ???");
   }
   else    {                            /* It must be a leaf node */
      *(x + k++) = - *(link + n);       /* Output value */
       n = 0;    }                      /* Start over at root */
   }
   if (k == xsz - 1)                    /* Is one left over? */
      *(x + k++) = - *(link + n);
}
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
   double *link, *x, xsz;
   uint16_T *hx;
   int hxsz;
   
   /* Check inputs for reasonableness */
   if (nrhs != 3)
      mexErrMsgIdAndTxt("DIPUM:ThreeInputs","Three inputs required.");
   else if (nlhs > 1)
      mexErrMsgIdAndTxt("DIPUM:TooManyOutputs",
              "Too many output arguments.");
   
   /* Is last input argument a scalar? */
   if(!mxIsDouble(prhs[2])  || mxIsComplex(prhs[2])  ||
         mxGetN(prhs[2]) * mxGetM(prhs[2]) != 1)
      mexErrMsgIdAndTxt("DIPUM:NonscalarXSize",
              "Input XSIZE must be a scalar.");
   
   /* Create input matrix pointers and get scalar */
   hx = mxGetUint16s(prhs[0]);
   link = mxGetDoubles(prhs[1]);
   xsz = mxGetScalar(prhs[2]);          /* returns DOUBLE */
   
   /* Get the number of elements in hx */
   hxsz = mxGetM(prhs[0]);
   
   /* Create 'xsz' x 1 output matrix */
   plhs[0] = mxCreateDoubleMatrix(xsz, 1, mxREAL);
   
   /* Get C pointer to a copy of the output matrix */
   x = mxGetDoubles(plhs[0]);
   
   /* Call the C subroutine */
   unravel(hx, link, x, xsz, hxsz);
}

