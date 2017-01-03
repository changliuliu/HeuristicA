%% Setup Paramters
load('map_for_test.mat');
Rmin = 10;
theta_list = [pi/2];

%% Compute the BLHeuristics
[Hmap,lines,corners] = BLHeuristics(map,Rmin,theta_list);

%% Write to csv file
filename = 'Heuristic.csv';
csvwrite(filename,Hmap);

%% Visualize
theta_index = 1;
mapsize = size(map);
vis_BLH(lines, corners, Hmap, theta_index, mapsize)