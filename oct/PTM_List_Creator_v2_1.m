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

%% Close All Open Function and Data

close all; clc;clear;warning off all;format shortG;

%% The only part to make changes in the code

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%        WRITE SATELLITE NAME      %%%%%%%%%%%%%%%%%%%%%%%

Sat_Name = 'AQUA';  % GOKTURK1A or GOKTURK2 or RASAT or AQUA or TERRA

%%%%%%%%%%%      CHANGE SATELLITE PASS CSV FILE NAME        %%%%%%%%%%%%%%

File_Name = 'Doppler_20221215_1106.csv';

%%%%%%%%%%%%%%%%%%   WRITE GENERAL CONSTANT VALUES     %%%%%%%%%%%%%%%%%%%

% Values for MIYEG Antenna at TUBITAK UZAY

Az_offset = -12.18;  % Azimuth offset from Satellite Signal Measurement [deg]
El_offset = 0.00;   % Elevation offset from Satellite Signal Measurement [deg]
UTC_offset = 3;     % UTC offset value based on system (BECKHOFF) time
Max_Vel = 2.40;     % X and Y axes maximum velocity value [deg/s]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Data Input from Doopler Software TLE to Az-El Conversation

Pass_data = readtable(File_Name);   % Get Data from calculated Satellite Pass

%% All required variables from Pass Data file

Time_array = table2array(Pass_data(:,1));           % Converting time data type from table to array
Azimuth_raw = table2array(Pass_data(:,3));          % Converting Azimuth data type from table to array
Elevation = table2array(Pass_data(:,4));            % Converting Elevation data type from table to array
Time_Split = datevec(Time_array,'HH:MM:SS');        % Separating time values each column into hours, minutes, seconds
Time_UTC = Time_Split(1:end,4:end);                 % Obtaining time information in 3 x Data length matrix

% For information and use in for loops purposes, calculating and printing the size of pass data
size_L = length(Azimuth_raw);
fprintf('Satellite Pass Data Size: %0.0f\n',size_L);

Hour = Time_UTC(:,1) + UTC_offset;                  % Define exact hour only as a single column

% For loop to check the probability of Hour value exceeding or equal to 24
% hours with the added UTC offset value
for n=1:size_L                                      % Include all hours from 1 to pass data length in the loop
    if Hour(n) >= 24                                % Checking if the hour value is greater than or equal 24 
	Hour(n) = Hour(n) - 24;                         % Subtract 24 if the hour value is greater than or equal 24 (Ex: 25 - 24 = 1)
    else
	Hour(n) = Hour(n);                              % Get exact hour if condition is not met	
    end
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

for m=size_L:-1:1                                  % Include all Azimuth-Elevation from 1 to pass data length in the loop

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

%% Limit the maximum velocity of X and Y Axis at 5 deg/s
% Due to the structure of the antenna system, the X and Y axes can have a maximum speed of 5 d/s.
% Very rarely, the X-Y axis may need speeds over 5 d/s in singular positions.
% The X and Y axis positions specified in the PTM file are also calculated every second.
% Therefore, if the position difference between current and the next position is greater than 5,
% the need for speed over 5 d/s will arise. In order to avoid this situation,
% the X and Y position differences in the PTM file should be checked and the highest difference should be 5

X_Axis = X_Axis_d;                                  % X-Axis is defined to compare with the next data

for n=2:length(X_Axis_d)                            % Since the first value of the data is the same, it starts from for 2
    % The difference between the n element of the original data and the n-1 element of the defined data
    X_Difference = X_Axis_d(n) - X_Axis(n-1);
    % The absolute difference between the n element of the original data and the n-1 element of the defined data
    X_Differenceabs = abs(X_Axis_d(n) - X_Axis(n-1));
    if X_Differenceabs > Max_Vel                    % if the absolute difference is greater than Max Vel
        if X_Difference > 0                         % and if the difference value is greater than 0 (positive value)
           X_Axis(n) = X_Axis(n-1) + Max_Vel;       % Add Max Vel (n-1) element is assigned to element n
        else                                        % and if the difference value is less than 0 (negative value)
           X_Axis(n) = X_Axis(n-1) - Max_Vel;       % Subtract Max Vel (n-1) element is assigned to element n
        end                                         % end of 2nd if statement
    end                                             % end of 1st if statement
end                                                 % end of for statement

Y_Axis = Y_Axis_d;                                  % Y-Axis is defined to compare with the next data

for n=2:length(Y_Axis_d)                            % Since the first value of the data is the same, it starts from for 2
    % The difference between the n element of the original data and the n-1 element of the defined data
    Y_Difference = Y_Axis_d(n) - Y_Axis(n-1);
    % The absolute difference between the n element of the original data and the n-1 element of the defined data
    Y_Differenceabs = abs(Y_Axis_d(n) - Y_Axis(n-1));
    if Y_Differenceabs > Max_Vel                    % if the absolute difference is greater than Max Vel
        if Y_Difference > 0                         % and if the difference value is greater than 0 (positive value)
           Y_Axis(n) = Y_Axis(n-1) + Max_Vel;       % Add Max Vel (n-1) element is assigned to element n
        else                                        % and if the difference value is less than 0 (negative value)
           Y_Axis(n) = Y_Axis(n-1) - Max_Vel;       % Subtract Max Vel (n-1) element is assigned to element n
        end                                         % end of 2nd if statement
    end                                             % end of 1st if statement
end  

%% Writing all calculated values in PTM txt file in TUBITAK UZAY message format
      
% For loop for the write all the variables needed in the PTM file
% Variables: Data Sequence Number, Message Length, X Axis, Y Axis, Hour, Minute, Second, Milisecond, Checksum
% In the PTM file, the data must be created from tail to head

for m = size_L:-1:1                                 % Include all veraibles from 1 to pass data length in the loop
    str_Size = num2str(m);                          % Data Sequence Number value conversion from numbers to string (character array)
    str_Hour = num2str(Hour(m));                    % Hour value conversion from numbers to string (character array)
    str_Minute = num2str(Minute(m));                % Minute value conversion from numbers to string (character array)
    str_Second = num2str(Second(m));                % Second value conversion from numbers to string (character array)
    str_Milisecond = num2str(Milisecond(m));        % Milisecond value conversion from numbers to string (character array)
    str_X_Axis = num2str(X_Axis(m));                % X-Axis value conversion from numbers to string (character array)
    str_Y_Axis = num2str(Y_Axis(m));                % Y-Axis value conversion from numbers to string (character array)
    % Writing PTM message excluding Data definition (U,C6), Message length and Checksum
    Message = [str_Size ',' str_X_Axis ',' str_Y_Axis ',' ...
        str_Hour ',' str_Minute ',' str_Second ',' str_Milisecond];
    MLN = length(Message);                          % Calculating the length of the obtained message
    str_MLN = num2str(MLN);                         % Message length value conversion from numbers to string (character array)
    
    % Checksum calculation, The whole message will be evaluated include characters when calculating the checksum.
    % Checksum data, which is the last 1 byte value of the PTM data, will not be kept separate from the message.
    % Standard 12 bytes message are "<U,C6, = 6 byte", Message length "XX, = 3byte" and Checksum ",X> = 3byte"
    CS = mod(12 + MLN , 9);                         % Calculation of checksum by taking mod operation according to the number 9        
    str_CS = num2str(CS);                           % Checksum value conversion from numbers to string (character array)

    % Creating messages as much as the size of pass data, covering each line of the PTM file
    WholeMessage = ['<U,C6,' str_MLN ',' Message ',' str_CS '>'];

    % Printing all generated messages into the generated PTM .txt file
    fprintf(fid,'%s\r\n',WholeMessage);
end

%% Axis Velocity Calculation

% X, Y axis and Az-EL axis velocities are calculated
% by taking the derivative (diff) of the positions
% The "loess" function is used to obtain a smooth velocity data.

X_Axis_Vel = smoothdata (diff(X_Axis),2,"loess");

Y_Axis_Vel = smoothdata (diff(Y_Axis),2,"loess");

Az_Vel_raw = abs(smoothdata (diff(Azimuth),2,"loess"));

El_Vel = smoothdata (diff(Elevation),2,"loess");

Az_Vel = zeros((size_L)-1,1);

% Azimuth velocity check

for k = 1:size(Az_Vel_raw)                   % Include all Azimuth Velocities from 1 to pass data length in the loop
    if Az_Vel_raw (k) > 180                  % Checking if the azimuth velocity value is greater than 180 deg/s
        Az_Vel (k) = Az_Vel_raw (k-1);       % Get previous Azimuth velocity data
       else
        Az_Vel (k) = Az_Vel_raw (k);         % Get calculated Azimuth velocity data if condition is not met
    end
end

% Finding the highest Azimuth Velocity value in whole data
[Max_Az_Vel, ind2] = max(Az_Vel);

%% Plotting satellite pass information

% Figure for Plotting X-Y Axis and Azimuth-Elevation Position
figure(1)
subplot(2,1,1)
yyaxis left;
plot(Time_array_new,X_Axis,'-','Color',[0 0.4470 0.7410])
title( {[strcat(Sat_Name(1:end)) ' Satellite Pass Information ' ...
    '(UTC+' num2str(UTC_offset) ')' ]...
    ['Date ' strcat(File_Name(9:16)) ' & Local Time Between at ' ...
    num2str(Hour(1,1)) ':' num2str(Minute(1,1)) ':' num2str(Second(1,1)) ' - '...
    num2str(Hour(end,1)) ':' num2str(Minute(end,1)) ':' num2str(Second(end,1))]})
ylabel('X Angle [deg]');
yyaxis right;hold on
plot (Time_array_new,Y_Axis,'-','Color',[0.8500 0.3250 0.0980])
xlabel(['Time (UTC+' num2str(UTC_offset') ')']);
ylabel('Y Angle [deg]');
legend ('X-Axis Position','Y-Axis Position');grid on;
subplot(2,1,2);
yyaxis left;
plot(Time_array_new,Azimuth,'-','Color',[0 0.4470 0.7410]);
ylabel('Azimuth Angle [deg]'); 
xlabel(['Time (UTC+' num2str(UTC_offset') ')']);
yyaxis right;hold on;
plot(Time_array_new,Elevation,'-','Color',[0.8500 0.3250 0.0980]);hold on;
plot(Time_array_new(ind),Max_Elevation,'ko');hold on;
plot([Time_array_new(ind) Time_array_new(ind)],[0 Max_Elevation],'-.k','LineWidth',0.5)
textLabel = (['Max EL=' num2str(Max_Elevation,'%.2f'),char(176) ' at '...
    num2str(Hour(ind,1)) ':' num2str(Minute(ind,1)) ':' num2str(Second(ind,1))]);
text(Time_array_new(ind), Max_Elevation, textLabel, 'fontSize', 10,...
    'Color', 'k', 'VerticalAlignment','bottom')
ylabel('Elevation Angle [deg]');
legend ('Azimuth Position','Elevation Position', ...
    ['Max Elevation=' num2str(Max_Elevation,'%.2f'),char(176)],...
    'Location','northwest');
grid on
set(1, 'Position', [10 75 1300 900]);

% Figure for Plotting X-Y Axis Position, X-Y Axis Velocity
% Azimuth-Elevation Axis Position, Azimuth-Elevation Axis Velocity
figure(2)
subplot(4,1,1)
yyaxis left;
plot(Time_array_new,X_Axis,'-','Color',[0 0.4470 0.7410])
title( {[strcat(Sat_Name(1:end)) ' Satellite Pass Information ' ...
    '(UTC+' num2str(UTC_offset) ')' ]...
    ['Date ' strcat(File_Name(9:16)) ' & Local Time Between at ' ...
    num2str(Hour(1,1)) ':' num2str(Minute(1,1)) ':' num2str(Second(1,1)) ' - '...
    num2str(Hour(end,1)) ':' num2str(Minute(end,1)) ':' num2str(Second(end,1))]})
ylabel('X Angle [deg]');
yyaxis right;hold on
plot (Time_array_new,Y_Axis,'-','Color',[0.8500 0.3250 0.0980])
xlabel(['Time (UTC+' num2str(UTC_offset') ')']);
ylabel('Y Angle [deg]');
legend ('X-Axis Position','Y-Axis Position');grid on;
subplot(4,1,2);
yyaxis left;
plot(Time_array_new(2:end),X_Axis_Vel,'-','Color',[0 0.4470 0.7410]);
ylabel('X Velocity [deg/s]');
yyaxis right;hold on;
plot(Time_array_new(2:end),Y_Axis_Vel,'-','Color',[0.8500 0.3250 0.0980]);
ylabel('Y Velocity [deg/s]');
xlabel(['Time (UTC+' num2str(UTC_offset') ')']);
legend ('X Axis Velocity','Y Axis Velocity','Location','east');
grid on
subplot(4,1,3);
yyaxis left;
plot(Time_array_new,Azimuth,'-','Color',[0 0.4470 0.7410]);
ylabel('Azimuth Angle [deg]'); 
xlabel(['Time (UTC+' num2str(UTC_offset') ')']);
yyaxis right;hold on;
plot(Time_array_new,Elevation,'-','Color',[0.8500 0.3250 0.0980]);hold on;
plot(Time_array_new(ind),Max_Elevation,'ko');hold on;
plot([Time_array_new(ind) Time_array_new(ind)],[0 Max_Elevation],'-.k','LineWidth',0.5)
textLabel = (['Max EL=' num2str(Max_Elevation,'%.2f'),char(176) ' at '...
    num2str(Hour(ind,1)) ':' num2str(Minute(ind,1)) ':' num2str(Second(ind,1))]);
text(Time_array_new(ind), Max_Elevation, textLabel, 'fontSize', 10,...
    'Color', 'k', 'VerticalAlignment','bottom')
ylabel('Elevation Angle [deg]');
legend ('Azimuth Position','Elevation Position', ...
    ['Max Elevation=' num2str(Max_Elevation,'%.2f'),char(176)],...
    'Location','northwest');
grid on
subplot(4,1,4);
yyaxis left;
plot(Time_array_new(2:end),Az_Vel,'-','Color',[0 0.4470 0.7410]);
ylabel('Azimuth Velocity [deg/s]');hold on;
plot(Time_array_new(ind2+1),Max_Az_Vel,'ko');hold on;
plot([Time_array_new(ind2+1) Time_array_new(ind2+1)],[0 Max_Az_Vel],'-.k','LineWidth',0.5)
textLabel = (['Max AZ Vel=' num2str(Max_Az_Vel,'%.1f'),char(176) '/s']);
text(Time_array_new(ind2+1), Max_Az_Vel, textLabel, 'fontSize', 10, 'Color',...
    'k', 'VerticalAlignment','bottom')
yyaxis right;hold on;
plot(Time_array_new(2:end),El_Vel,'-','Color',[0.8500 0.3250 0.0980]);
ylabel('Elevation Velocity [deg/s]');
xlabel(['Time (UTC+' num2str(UTC_offset') ')']);
legend ('Azimuth Axis Velocity',...
    ['Max Azimuth Velocity=' num2str(Max_Az_Vel,'%.1f'),char(176) '/s'],...
    '','Elevation Axis Velocity','Location','northeast');
grid on
set(2, 'Position', [200 75 1300 900]);

% Figure for Az-El Position with Polar Coordinate
figure(3)
h = skyplot(Azimuth,Elevation);
title( {[strcat(Sat_Name(1:end)) ' Satellite Pass Information ' ...
    '(UTC+' num2str(UTC_offset) ')' ]...
    ['Date ' strcat(File_Name(9:16)) ' & Local Time Between at ' ...
    num2str(Hour(1,1)) ':' num2str(Minute(1,1)) ':' num2str(Second(1,1)) ' - '...
    num2str(Hour(end,1)) ':' num2str(Minute(end,1)) ':' num2str(Second(end,1))]})
set(3, 'Position', [900 75 1000 900]);
h.ColorOrder = [0.8500    0.3250    0.0980];

% Figure for Plotting X-Y Axis Position, X-Y Axis Velocity and Az-El Position
figure(4)
subplot(3,1,1)
yyaxis left;
plot(Time_array_new,X_Axis,'-','Color',[0 0.4470 0.7410])
title( {[strcat(Sat_Name(1:end)) ' Satellite Pass Information ' ...
    '(UTC+' num2str(UTC_offset) ')' ]...
    ['Date ' strcat(File_Name(9:16)) ' & Local Time Between at ' ...
    num2str(Hour(1,1)) ':' num2str(Minute(1,1)) ':' num2str(Second(1,1)) ' - '...
    num2str(Hour(end,1)) ':' num2str(Minute(end,1)) ':' num2str(Second(end,1))]})
ylabel('X Angle [deg]');
yyaxis right;hold on
plot (Time_array_new,Y_Axis,'-','Color',[0.8500 0.3250 0.0980])
xlabel(['Time (UTC+' num2str(UTC_offset') ')']);
ylabel('Y Angle [deg]');
legend ('X-Axis Position','Y-Axis Position');grid on;
subplot(3,1,2);
yyaxis left;
plot(Time_array_new(2:end),X_Axis_Vel,'-','Color',[0 0.4470 0.7410]);
ylabel('X Velocity [deg/s]');
yyaxis right;hold on;
plot(Time_array_new(2:end),Y_Axis_Vel,'-','Color',[0.8500 0.3250 0.0980]);
ylabel('Y Velocity [deg/s]');
xlabel(['Time (UTC+' num2str(UTC_offset') ')']);
legend ('X Axis Velocity','Y Axis Velocity','Location','east');
grid on
subplot(3,1,3);
yyaxis left;
plot(Time_array_new,Azimuth,'-','Color',[0 0.4470 0.7410]);
ylabel('Azimuth Angle [deg]'); 
xlabel(['Time (UTC+' num2str(UTC_offset') ')']);
yyaxis right;hold on;
plot(Time_array_new,Elevation,'-','Color',[0.8500 0.3250 0.0980]);hold on;
plot(Time_array_new(ind),Max_Elevation,'ko');hold on;
plot([Time_array_new(ind) Time_array_new(ind)],[0 Max_Elevation],'-.k','LineWidth',0.5)
textLabel = (['Max EL=' num2str(Max_Elevation,'%.2f'),char(176) ' at '...
    num2str(Hour(ind,1)) ':' num2str(Minute(ind,1)) ':' num2str(Second(ind,1))]);
text(Time_array_new(ind), Max_Elevation, textLabel, 'fontSize', 10,...
    'Color', 'k', 'VerticalAlignment','bottom')
ylabel('Elevation Angle [deg]');
legend ('Azimuth Position','Elevation Position', ...
    ['Max Elevation=' num2str(Max_Elevation,'%.2f'),char(176)],...
    'Location','northwest');
grid on
set(4, 'Position', [400 75 1300 900]);

%% Automatically Save the Graph Files

% Creating folder to save Satellite Pass Information Graph
path = pwd ;                % mention your path 
myfolder = sprintf('%s Pass Graphs %s %s-%s to %s-%s %s EL', ...
    Sat_Name(1:end), File_Name(9:16),...
    num2str(Hour(1,1)), num2str(Minute(1,1)), num2str(Hour(end,1)),...
    num2str(Minute(end,1)), num2str(Max_Elevation,'%.00f'));
folder = mkdir([path,filesep,myfolder]);
path  = [path,filesep,myfolder];

% Saving graphics as .png based on Satellite Pass Information
for p = 1:4
    figure(p)
    temp=[path,filesep,sprintf('%s_%s_%s-%s_to_%s-%s_%s_EL_',...
        Sat_Name(1:end), File_Name(9:16),...
        num2str(Hour(1,1)), num2str(Minute(1,1)), num2str(Hour(end,1)),...
        num2str(Minute(end,1)),num2str(Max_Elevation,'%.00f')),...
        num2str(p),'.png'];
    saveas(gca,temp);
end

% Saving graphics as .fig based on Satellite Pass Information
for p = 1:4
    figure(p)
    temp=[path,filesep,sprintf('%s_%s_%s-%s_to_%s-%s_%s_EL_',...
        Sat_Name(1:end), File_Name(9:16),...
        num2str(Hour(1,1)), num2str(Minute(1,1)), num2str(Hour(end,1)),...
        num2str(Minute(end,1)),num2str(Max_Elevation,'%.00f')),...
        num2str(p),'.fig'];
    saveas(gca,temp);
end
