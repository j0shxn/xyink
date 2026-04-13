clc; clear all; close all;
warning off all;
format long g

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

alpha = deg2rad(45);
beta = deg2rad (45);
lambda = deg2rad(85);
gamma = deg2rad(85);

x = [ 1 ; 0 ; 0 ];
p = spherical2cartesian([lambda gamma 1])
w = [ cos(lambda) ; sin(lambda) ; 0 ]
l = spherical2cartesian([-alpha beta 1])

% ---------------------------------------------------------- Inverse Kinematics

% PHI
phi = asin( (cos(alpha) * cos(beta) - cos(gamma)*cos(lambda)) / ...
    (sin(gamma)*sin(lambda) ) )

% PSI
psi = asin((-(sin(gamma)*sin(phi)*cos(lambda) -...
    sin(lambda)*cos(gamma))*sin(beta) +...
    sin(alpha)*sin(gamma)*cos(beta)*cos(phi))/...
    (sqrt(-cos(alpha)^2*cos(beta)^2 + 1)*...
    sqrt((sin(gamma)*sin(phi)*cos(lambda) -...
    sin(lambda)*cos(gamma))^2 +...
    sin(gamma)^2*cos(phi)^2)))

psi_comp = 1j*log((-sqrt(cos(alpha)^2*cos(beta)^2 - ...
    2*cos(alpha)*cos(beta)*cos(gamma)*cos(lambda) + ...
    cos(gamma)^2 + cos(lambda)^2 - 1) + ...
    cos(alpha)*cos(beta)*cos(lambda) - ...
    cos(gamma))/((sin(alpha)*cos(beta) - ...
    1j*sin(beta))*sin(lambda)))

% DEGREES
phi_deg = rad2deg(phi)
psi_deg = rad2deg(psi)
psi_comp_deg = rad2deg(real(psi_comp))

% ---------------------------------------------------------- Forward Kinematics

RxR = Rodri(x, psi);
RxC = Rodri(x, psi_comp);
Rw = Rodri(w, phi);

err_R = l - RxR*Rw*p
err_C = l - RxC*Rw*p



