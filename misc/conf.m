clc; clear all; close all;
format shorte;
warning off all;

pkg load symbolic
syms psi lambda lr1 lr2 lr3


lr = [lr1 ; lr2 ; lr3];

k = [ cos(lambda) ; sin(lambda) ; 0 ];

K = [ [ 0 , - k(3) , k(2) ];
      [ k(3) , 0 ,  -k(1) ];
      [ -k(2) , k(1) , 0  ] ];

Rx = [ [ 1 0 0 ] ; [ 0 cos(psi) sin(psi) ] ; [ 0 -sin(psi) cos(psi) ] ];

% This is the first equation for finding the first motor position
eq1 = dot(lr, Rx * k) == 0
function_handle(eq1)
eq2 = eq1

