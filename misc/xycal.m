% XY axis orthogonality error compensated inverse kinematic program
% Bugra Coskun - bugra.coskun@profen.com

% clc; clear all; close all;
format long g;

lambda = pi/2
phi = deg2rad(45)
psi = deg2rad(45)
hz = [0;0;1];

function vect = sp2ca(sp)
    % Map horizontal coordinates to cartesian coordinates
    % Warning: In a ned system elevation=-theta
    % Spherical coordinates to cartesian
    % sp = azimuthal ccw + , elevation, distance
    sp
    vect = [[ sp(3)*cosd(sp(2))*cosd(sp(1)) ];
            [ sp(3)*cosd(sp(2))*sind(sp(1)) ];
            [ sp(3)*sind(sp(2)) ]];
end

function sph = ca2sp(vec)
    r = norm(vec);
    uvec = vec/r;
    theta = asind(uvec(3));
    phi = rad2deg(atan2(uvec(2), uvec(1)));
    sph = [phi, theta, r];
end

k = [ cos(lambda) ; sin(lambda) ; 0 ];

K = [ [ 0 , - k(3) , k(2) ];
      [ k(3) , 0 ,  -k(1) ];
      [ -k(2) , k(1) , 0  ] ];

Rp = @(phi) eye(3) + sin(phi) * K + (1 - cos(phi)) * K^2;
Rx = @(psi) [ [ 1 0 0 ] ; [ 0 cos(psi) -sin(psi) ] ; [ 0 sin(psi) cos(psi) ] ];

% Forward Kinematics
l = Rx(psi) * Rp(phi) * hz

% Inverse Kinematics

nom1 = - l(1) * cot(lambda) + sqrt( l(1)^2 * cot(lambda)^2 - l(2)^2 - l(3)^2 )
nom2 = - l(1) * cot(lambda) - sqrt( l(1)^2 * cot(lambda)^2 - l(2)^2 - l(3)^2 )
den = l(2) - i * l(3)

PSI1 = real(- i * log( nom1 / den ));
PSI2 = real(- i * log( nom2 / den ));

PSI = (abs(PSI1) < pi)*(abs(PSI1) < abs(PSI2))*PSI1 + ...
    (abs(PSI2) < pi)*(abs(PSI2) < abs(PSI1))*PSI2

RxP = Rx(PSI)
vr = RxP * hz
hk = RxP * k
vrcl = cross(vr, l)
nrcl = norm(vrcl)
rcl = dot(vrcl/nrcl, hk)
norp = rcl/abs(rcl)

PHI = norp * acos( dot(vr, l) )

function ang_xy = invkin(azel_deg, lambda_deg)
    % azel_deg 2x1 , lambda 1x1
    azel_rad = deg2rad(azel_deg)
    lambda = deg2rad(lambda_deg)

    k0 = [ cos(lambda) ; sin(lambda) ; 0 ];
    los = sp2ca([azel_rad(1), azel_rad(2), 1])
    los = [0.5 0.5 0.707];
    nom1 = - los(1) * cot(lambda) + sqrt( los(1)^2 * cot(lambda)^2 - los(2)^2 - los(3)^2 )
    nom2 = - los(1) * cot(lambda) - sqrt( los(1)^2 * cot(lambda)^2 - los(2)^2 - los(3)^2 )
    den = los(2) - i * los(3)

    PSI1 = real(- i * log( nom1 / den ));
    PSI2 = real(- i * log( nom2 / den ));

    PSI = (abs(PSI1) < pi)*(abs(PSI1) < abs(PSI2))*PSI1 + ...
        (abs(PSI2) < pi)*(abs(PSI2) < abs(PSI1))*PSI2

    RxP =  [ [ 1 0 0 ] ; [ 0 cos(PSI) -sin(PSI) ] ; [ 0 sin(PSI) cos(PSI) ] ];
    hz = [0;0;1];
    vr = RxP * hz
    hk = RxP * k0
    vrcl = cross(vr, los)
    nrcl = norm(vrcl)
    rcl = dot(vrcl/nrcl, hk)
    norp = rcl/abs(rcl)

    PHI = norp * acos( dot(vr, los) )
    ang_xy = [PSI, PHI]
end

invkin([90,0],90)



