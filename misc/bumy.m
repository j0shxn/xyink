clc; clear all; close all;
format long g
pkg load symbolic

syms r1 r2 r3 l1 l2 l3 k1 k2 k3

r = [ r1 ; r2 ; r3 ];
l = [ l1 ; l2 ; l3 ];
k = [ k1 ; k2 ; k3 ];

rxl = cross(r,l)
crxl = dot ( (rxl / norm(rxl)), k )
norp = simplify(crxl / norm(crxl))
