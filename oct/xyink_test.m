clc; clear all; close all;
format long g
cnt = 1;

azeldata = csvread("./xy_table_dogu.csv")([1:50],[4:7]);

for ind = 1:length(azeldata)
    az_deg = azeldata(ind, 1) + 90;
    el_deg = azeldata(ind, 2);
    command = cstrcat("./xyink ", " -a ", num2str(az_deg), " -e ", num2str(el_deg));
    [~,res] = system(command);
    if (res(1) == "n")
        fprintf("Found incontinuity at [%d, %d]", az_deg, el_deg);
    end
    c_ans_str = strsplit(res)(1:2);
    xyink_x = str2num(c_ans_str{1});
    xyink_y = str2num(c_ans_str{2});
    table_x = deg2rad(azeldata(ind, 3));
    table_y = deg2rad(azeldata(ind, 4));
    x_err = xyink_x - table_x;
    y_err = xyink_y - table_y;

    if (x_err > 1e-2)
        fprintf("\n[ WARNING ] Error at [%d, %d]\n",...
            az_deg, el_deg);
        fprintf("Xyink returned [%d, %d]\n",...
            rad2deg(xyink_x), rad2deg(xyink_y));
        fprintf("While the table value was [%d, %d]\n",...
            rad2deg(table_x), rad2deg(table_y));
        fprintf("Error = [%d, %d]\n",...
            rad2deg(x_err), rad2deg(y_err));
    elseif (y_err > 1e-2)
        fprintf("\n[ WARNING ] Error at [%d, %d]\n",...
            az_deg, el_deg);
        fprintf("Xyink returned [%d, %d]\n",...
            rad2deg(xyink_x), rad2deg(xyink_y));
        fprintf("While the table value was [%d, %d]\n",...
            rad2deg(table_x), rad2deg(table_y));
        fprintf("Error = [%d, %d]\n",...
            rad2deg(x_err), rad2deg(y_err));
    end
    X_ERR(ind) = x_err;
    Y_ERR(ind) = y_err;
end

indx = 1:length(azeldata);

plot(indx, X_ERR, indx, Y_ERR);
pause
