clc; clear all; close all;
format shorte;
warning off all;

pkg load symbolic

syms psi phi lambda lr1 lr2 lr3

%lambda = pi/2;

k = [ cos(lambda) ; sin(lambda) ; 0 ];

K = [ [ 0 , - k(3) , k(2) ];
      [ k(3) , 0 ,  -k(1) ];
      [ -k(2) , k(1) , 0  ] ];


s = @(x) x - x^3/6 + x^5/120 - x^7/5040 + x^9/362880 - x^11/39916800 + \
    x^13/6227020800 - x^15/1307674368000 + x^17/355687428096000 - \
    x^19/121645100408832000;

c = @(x) 1 - x^2/2 + x^4/24 - x^6/720 + x^8/40320 - x^10/3628800 + \
    x^12/479001600 - x^14/87178291200 + x^16/20922789888000 - \
    x^18/6402373705728000;


Rp = eye(3) + s(psi) * K + (1 - c(psi)) * K^2;
Rx = [ [ 1 0 0 ] ; [ 0 c(phi) s(phi) ] ; [ 0 -s(phi) c(phi) ] ];

simplify((Rp*Rx*[0;0;1]))
