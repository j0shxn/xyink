clc; clear all; close all;
warning off all;
pkg load symbolic

function vect = spherical2cartesian(sp)
    % Map horizontal coordinates to cartesian coordinates
    % Warning: In a ned system elevation=-theta
    % Spherical coordinates to cartesian
    % sp = [azimuthal ccw + , elevation, distance]
    vect = [[ sp(3)*cos(sp(2))*cos(sp(1)) ];
            [ sp(3)*cos(sp(2))*sin(sp(1)) ];
            [ sp(3)*sin(sp(2)) ]];
end

function Rv = Rodri(k, ang)
    K = [ 0, -k(3), k(2) ;
                k(3), 0, -k(1) ;
                -k(2), k(1), 0 ; ];
    Rv = eye(3) + sin(ang)*K + (1-cos(ang))*K^2;
end

function plotV(v)
    quiver3(0,0,0,v(1),v(2),v(3), 'LineWidth',2,...
        'AutoScale', 'off', 'ShowArrowHead', 'on', 'MaxHeadSize', 0.1);
end

% --- Euler forms of trigonometric functions ---
euler_sin = @(x) (exp(1j*x) - exp(-1j*x))/(1j*2);
euler_cos = @(x) (exp(1j*x) + exp(-1j*x))/2;

% --------------------------------------------------------- Symbolic Variables
syms alpha beta 
syms lambda gamma
syms psi phi
assume alpha beta lambda gamma psi phi real
assume lambda gamma positive

x = [ 1 ; 0 ; 0 ];
p = spherical2cartesian([lambda gamma 1])
w = [ cos(lambda) ; sin(lambda) ; 0 ]
l = spherical2cartesian([- alpha beta 1])

%%% --------------------------- Y -> X Calculation ----------------------------

% ------------------------------------------------------------------- Find PHI 
Rw = Rodri(w,phi);
y_eq = dot(Rw*p,x) == dot(l,x);
y_eq = simplify(y_eq)

PHI = solve(y_eq, phi)(2)
pause

% -------------------------------------------- Find PSI - Cross Product Method


Rx = Rodri(x, -psi)
x_eq1 = dot(Rx*l, w) == cos(gamma)
x_eq11 = subs(x_eq1, cos(psi), euler_cos(psi))
x_eq12 = subs(x_eq11, sin(psi), euler_sin(psi))
p
x_eq2 = dot(Rx*l,Rw*p) == 1

x_eq = simplify(x_eq12)
solve(x_eq,psi)

pause

numer = dot(cross(p,x),cross(los,x))
norm_numer = sqrt(transpose(numer)*numer)
PSI = acos( numer/norm_numer )
pause

% ------------------------------------------------------------------- Find PSI 
Rx = Rodri(x, psi)
%p = sym('p', [3,1])
p = [1;0;0]
eq2 = dot(Rx*p,los) == 1

eq2_1 = subs(eq2, cos(psi), euler_cos(psi))
eq2_2 = subs(eq2_1, sin(psi), euler_sin(psi))

PSI = solve(eq2_2, psi)

pause
%%% --------------------------- X & Y Calculation -----------------------------
% ------------------------------------------------------------------- Find PHI 
Rk0 = Rodri(k0,phi);
eq1 = dot(Rk0*p0,x) == dot(los,x)
solve(eq1, phi)

% ------------------------------------------------------------------- Find PSI 
Rx = Rodri(x, -psi)
eq2 = dot(Rx*los,k0) == dot(p0,k0)

eq2_1 = subs(eq2, cos(psi), euler_cos(psi))
eq2_2 = subs(eq2_1, sin(psi), euler_sin(psi))

PSI = solve(eq2_2, psi) % Not applicable, gotta change to Euler form.
% If it's still too complicated go with the cross product method but find a way
% to not create singularities while normalizing it
