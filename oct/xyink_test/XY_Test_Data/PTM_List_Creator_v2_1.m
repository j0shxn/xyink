%% @ Generating PTM list in TUBITAK UZAY PTM format from Doppler Az-El data

% Author    : Mustafa Çelik
% Version   : 2.1.0
% Date      : 15.03.2022
% Brief     : For 1.0.0 version:
%           With this code, required PTM lists are obtained by using 
%           satellite pass .csv files generated from Doppler software.
%           : For 2.0.0 version: 21.03.2022
%           In the second version, automatic graph naming, 
%           automatic PTM filename generation 
%           and automatic graphics saving as .fig and .png were added
%           : For 2.1.0 version: 23.03.2022
%           In all graph xlabel arranged according to local time
%           Azimuth velocity of 360 deg/s have been corrected for position
%           values that change from 0 to 360 degrees instantaneously

close all; clc;clear;warning off all;format shortG;

Sat_Name = 'AQUA';  % GOKTURK1A or GOKTURK2 or RASAT or AQUA or TERRA

File_Name = 'Doppler_20221215_1106.csv';
% Values for MIYEG Antenna at TUBITAK UZAY

Az_offset = -12.18;  % Azimuth offset from Satellite Signal Measurement [deg]
El_offset = 0.00;   % Elevation offset from Satellite Signal Measurement [deg]
UTC_offset = 3;     % UTC offset value based on system (BECKHOFF) time
Max_Vel = 2.40;     % X and Y axes maximum velocity value [deg/s]

%% Data Input from Doopler Software TLE to Az-El Conversation

Pass_data = readtable(File_Name);   % Get Data from calculated Satellite Pass

%% All required variables from Pass Data file

Time_array = table2array(Pass_data(:,1));           % Converting time data type from table to array
Azimuth_raw = table2array(Pass_data(:,3));          % Converting Azimuth data type from table to array
Elevation = table2array(Pass_data(:,4));            % Converting Elevation data type from table to array
Time_Split = datevec(Time_array,'HH:MM:SS');        % Separating time values each column into hours, minutes, seconds
Time_UTC = Time_Split(1:end,4:end);                 % Obtaining time information in 3 x Data length matrix

size_L = length(Azimuth_raw);
fprintf('Satellite Pass Data Size: %0.0f\n',size_L);

Hour = Time_UTC(:,1) + UTC_offset;                  % Define exact hour only as a single column

for n=1:size_L
    % Normalize hour into 24 hours
    Hour(n) = mod(Hour(n),24);
end

Minute = Time_UTC(:,2);                             % Define minute only as a single column
Second = Time_UTC(:,3);                             % Define second only as a single column
Milisecond = zeros(length(Azimuth_raw), 1);         % Setting milliseconds 0 as long as the data length

Azimuth_offset = Azimuth_raw + Az_offset;           % Adding the azimuth offset value over the raw azimuth

% For loop to check the probability of Azimuth value exceeding 360 degrees
% or take a negative value with the added Azimuth offset value

Azimuth = zeros(size_L,1);                          % Creating empty matrix for Azimuth value to check

for j=1:size_L                                      % Include all Azimuths from 1 to pass data length in the loop
    if Azimuth_offset (j) < 0                       % Checking if the azimuth value is negative
       Azimuth (j)= 360 + Azimuth_offset (j);       % Add 360 if azimuth value is less than 0 (Ex: 360 - 1 = 359)
    elseif Azimuth_offset (j) > 360                 % Checking if the azimuth value is greater than 360
       Azimuth (j)= Azimuth_offset (j) - 360;       % Subtract 360 if the azimuth value is greater than 360 (Ex: 361 - 360 = 1)
    else
        Azimuth (j)= Azimuth_offset (j);            % Get Azimuth offset if both conditions are not met
    end
end

% For loop for checking if the elevation is less than or equal to 0
% If the Elevation value equals absolute 0, 
% the trigonometric equation will not calculate the correct result

for i=1:size_L                                      % Include all Elevatioýns from 1 to pass data length in the loop
    if Elevation(i) <= 0                            % Checking if the elevation value is less than or equal to 0 
        Elevation(i) = 0.001;                       % Take the elevation value as 0.001 if the condition is met
    end
end

[Max_Elevation, ind] = max(Elevation);

% After adding the specified UTC to the time value, a new time array is created.
Merge_time_c = strcat(num2str(Hour),':', num2str(Minute),':', num2str(Second));

% For loop for Converting the new time information obtained as char to duration
for l=1:size_L
Merge_time(l) = duration(str2double(strsplit(Merge_time_c(l,1:end), ':')));
end

% Transpose operation for the 1x291 Duration time to 291x1
% and the new time array is obtained with the UTC offset included
Time_array_new = Merge_time';

%% Creating a PTM .txt file to write data into

% PTM File Name Example: "PTM_List_RASAT_20220202_9-4_0.18Az_offset_5.0X-Y-max_vel.txt"
PTM_file_name = strcat('PTM_List_', Sat_Name(1:end), '_', File_Name(9:16), '_', ...
    num2str(Hour(1,1)),'-',num2str(Minute(1,1)),'_',num2str(Az_offset,'%.2f'),...
    'Az_offset','_',num2str(Max_Vel,'%.1f'),'X-Y-max_vel','.txt');

% open a text file and write PTM command
fid=fopen(PTM_file_name,'w');                        

%% Calculating the Az-El to X-Y for East-West Antenna Placement
% When the Y Axis is 0 degrees and the X Axis 90 degrees, the azimuth is 0 degrees
% When the Y Axis is 90 degrees and the X Axis 0 degrees, the azimuth is 90 degrees
% When the Y Axis is 0 degrees and the X Axis -90 degrees, the azimuth is 180 degrees
% When the Y Axis is -90 degrees and the X Axis 0 degrees, the azimuth is -270 degrees
% in the east-west placement of the antenna.

Azimuth_r = deg2rad(Azimuth);                      % Azimuth angle conversion from degree to radian
Elevation_r = deg2rad(Elevation);                  % Elevation angle conversion from degree to radian

% For loop to calculate the corresponding X-Axis (lower) and Y-Axis (upper) angles 
% in the Azimuth-Elevation angle in each row over the entire pass data length
% m=size:-1:1 means takes m values from tail to head.
% Because in the PTM file, the data must be created from tail to head.

for m=size_L:-1:1     % Include all Azimuth-Elevation from 1 to pass data length in the loop

   % Calculation of X-Y axis angles with Atan2 conversion formula from Azimuth-Elevation
   rotation_antenna(m) = 1*cos(Elevation_r(m))*sin(Azimuth_r(m));
   Y_Axis_r(m) = atan2(rotation_antenna(m),sqrt(1-rotation_antenna(m)^2));             % Calculation Y-Axis Angle [rad]
   X_Axis_r(m) = atan2((cos(Azimuth_r(m))*cos(Elevation_r(m))/cos(Y_Axis_r(m))),...    
        (sin(Elevation_r(m))/cos(Y_Axis_r(m))));                                       % Calculation X-Axis Angle [rad]
   Y_Axis_d(m) = rad2deg(Y_Axis_r(m));              % Y-Axis angle conversion from radian to degree [deg]
   Y_Axis_d(m) = round(Y_Axis_d(m)*100)/100;        % Define Y-Axis as two digits [deg]
   X_Axis_d(m) = rad2deg(X_Axis_r(m));              % X-Axis angle conversion from radian to degree [deg]
   X_Axis_d(m) = round(X_Axis_d(m)*100)/100;        % Define X-Axis as two digits [deg]
   
   % checking if the calculated X-Y axis angles are greater than or equal
   % to ±90 degrees. if the condition is met, they are equal to ±90.
   if X_Axis_d(m) >= 90 
        X_Axis_d(m) = 90;
    elseif X_Axis_d(m) <= -90
        X_Axis_d(m) = -90;
   end

   if Y_Axis_d(m) >= 90 
        Y_Axis_d(m) = 90;
   elseif Y_Axis_d(m) <= -90
        Y_Axis_d(m) = -90;
   end
end

