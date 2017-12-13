function [ y, e ] = mask_laplace( s, theta )


e = larnd( size(s,1), size(s,2), theta );

y = s + e;

e = abs(e./s);