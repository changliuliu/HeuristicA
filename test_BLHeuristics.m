%% Setup Paramters
map = load('grid_worlds/maze.csv');
Rmin = 10;
theta_list = [0.0, 26.565, 45.0, 63.435, 90.0, 116.565, 135.0, 153.435, 180.0, 206.565, 225.0, 243.435, 270.0, 296.565, 315.0, 333.435] / 180 * pi;

%% Compute the BLHeuristics
[Hmap,lines,corners] = BLHeuristics(map,Rmin,theta_list);

%% Write to csv file
% e.g. 40 * 80 grid cell with 16 angles 
% theta's = [0.0, 26.565, 45.0, 63.435, 90.0, 116.565, 135.0, 153.435, 180.0, 206.565, 225.0, 243.435, 270.0, 296.565, 315.0, 333.435]
% Heuristic file csv will contain 3200 rows and 16 cols, rows are
% organized in col-major.
% row 1 :  heuristic_cost of (1,1) cell for 16 theta's
% row 2 :  heuristic_cost of (2,1) cell for 16 theta's
% ...
% row 40 : (40,1) cell
% row 41 : (1,2) cell
% ...
% row 3200 : heuristic_cost of (40,80) cell for 16 theta's.

filename = 'bl_heuristic.csv';
csvwrite(filename,Hmap);

%% Visualize
theta_index = 1;
mapsize = size(map);
vis_BLH(lines, corners, Hmap, theta_index, mapsize)