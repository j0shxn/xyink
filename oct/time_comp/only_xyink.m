clc; clear all; close all;
warning off all;
format long g

% args_cell = argv();
% args_mat = str2double(args_cell);

function vect = spherical2cartesian(sp)
    % Map horizontal coordinates to cartesian coordinates
    % Warning: In a ned system elevation=-theta
    % Spherical coordinates to cartesian
    % sp = [azimuthal ccw + , elevation, distance]
    vect = [[ sp(3)*cos(sp(2))*cos(sp(1)) ];
            [ sp(3)*cos(sp(2))*sin(sp(1)) ];
            [ sp(3)*sin(sp(2)) ]];
end

function xy = Xyink(Azimuth_D, Elevation_D, Orthogonality_Error)
    ld = pi/2 + Orthogonality_Error;
    % We need to first multiply azimuth with -1 to fix for NED to NWU
    Offset = 90; % Degrees
    ModifiedAzimuth = mod(360 - (Azimuth_D + Offset), 360);
    SphericalP = deg2rad(ModifiedAzimuth);
    SphericalT = deg2rad(Elevation_D);
    losv = spherical2cartesian([SphericalP,SphericalT,1]);
    % Quadratic form to get the double roots of the X joint
    cotld = cos(ld)/sin(ld);
    nomp0 = -(losv(1)*cotld);
    nomp1 = sqrt( losv(1)^2 * cotld^2 - losv(2)^2 - losv(3)^2 );
    nom0 = nomp0 + nomp1;
    nom1 = nomp0 - nomp1;
    den = losv(2) - i * losv(3);

    PSI0 = mod(real(-i*log(nom0/den)), 2*pi);
    PSI1 = mod(real(-i*log(nom1/den)), 2*pi);

    bPSI = PSI0 < PSI1;
    iPSI0 = imag(PSI0) == 0;
    iPSI1 = imag(PSI1) == 0;

    if (iPSI0 & iPSI1)
        PSI = bPSI*PSI0 + !bPSI*PSI1;
    elseif (iPSI0)
        PSI = PSI0;
    elseif (iPSI1)
        PSI = PSI1;
    else
        PSI = bPSI*PSI0 + !bPSI*PSI1;
    endif

    %fprintf("X roots are %d and %d\n", rad2deg(PSI0), rad2deg(PSI1))

    % Check which of the X roots are within mechanical boundaries of the system
    
%   PSI0 = PSI0 - 2*pi*( PSI0 > pi );
%   PSI1 = PSI1 - 2*pi*( PSI1 > pi );
%
%   if PSI0 < pi/2 && PSI0 > -pi/2
%       PSI = PSI0;
%   elseif PSI1 < pi/2 && PSI1 > -pi/2
%       PSI = PSI1;
%   else
%       fprintf("FATAL ERROR: Out of workspace at < %d , %d > \n",...
%           Azimuth_D, Elevation_D)
%       if PSI0 < PSI1
%           PSI = PSI0;
%       elseif
%           PSI = PSI1;
%       end
%   end

    % ----------------------------------------------------------------- Y ANGLE
    % Rotation the X motor does to the Y
    
    Rx = [ 1 0 0 ; 0 cos(PSI) -sin(PSI) ; 0 sin(PSI) cos(PSI)];
    Zhat = [0 ; 0 ; 1];
    Tipv = Rx * Zhat;

    K0v = [ cos(ld) ; sin(ld) ; 0 ];

    % Rotated Y motor joint vector
    Kv = Rx * K0v;

    nTipLos = cross(Tipv, losv);
    TipLos = nTipLos / norm(nTipLos);
    unnormSign = dot(TipLos, Kv);
    % This is a bit weird the sign seems to be reverse of what its supposed to
    % be, need to look into it
    if unnormSign < 0
        phiSign = 1;
    elseif unnormSign > 0
        phiSign = -1;
    else
        phiSign = 0;
    end
    PHI = phiSign * acos( dot(Tipv, losv) );

    xy = rad2deg([ PSI ; PHI ]);

    if (imag(PSI) != 0 | imag(PHI) != 0)
        disp("----------------------------------------")
        disp("AZ motor angle (deg): "), disp(Azimuth_D)
        disp("EL motor angle (deg): "), disp(Elevation_D)
        disp("X motor angle (deg): "), disp(xy(1))
        disp("Y motor angle (deg): "), disp(xy(2))
        disp("----------------------------------------")
    end

end

%   % xyinkResult = Xyink(args_mat(1), args_mat(2), 0)
%
%   xyangs = [0];
%   cnt = 0;
%   for azimuth_angle = 0:2:360
%       for elevation_angle = 0:2:360
%           cnt = cnt + 1;
%           xyang = Xyink(azimuth_angle, elevation_angle, 0);
%           x_angs(cnt) = xyang(1);
%           y_angs(cnt) = xyang(2);
%       end
%   end
%
%   plot(1:cnt, x_angs, 1:cnt, y_angs)
%   pause

xyinkResult = Xyink(150,50,0)
