clc; clear all; close all;
warning off all;
format long g

args_cell = argv();
args_mat = str2double(args_cell);

function xy = Matlab_xy(Azimuth, Elevation)
    % This is the original xy inverse kinematics program from the matlab
    % script written by Mustafa Celik
    Azimuth_r = deg2rad(Azimuth);
    Elevation_r = deg2rad(Elevation);
    rotation_antenna = 1*cos(Elevation_r)*sin(Azimuth_r);
    Y_Axis_r = atan2(rotation_antenna,sqrt(1-rotation_antenna^2));
    X_Axis_r = atan2((cos(Azimuth_r)*cos(Elevation_r)/cos(Y_Axis_r)),...    
        (sin(Elevation_r)/cos(Y_Axis_r)));
    Y_Axis_d = rad2deg(Y_Axis_r);
    Y_Axis_d = round(Y_Axis_d*100)/100;
    X_Axis_d = rad2deg(X_Axis_r);
    X_Axis_d = round(X_Axis_d*100)/100;

    % checking if the calculated X-Y axis angles are greater than or equal
    % to ±90 degrees. if the condition is met, they are equal to ±90.
    if X_Axis_d >= 90 
        X_Axis_d = 90;
    elseif X_Axis_d <= -90
        X_Axis_d = -90;
    end

    if Y_Axis_d >= 90 
        Y_Axis_d = 90;
    elseif Y_Axis_d <= -90
        Y_Axis_d = -90;
    end
    xy = [ X_Axis_d ; Y_Axis_d ];
end

matlabResult = Matlab_xy(150 + 90, 50)
