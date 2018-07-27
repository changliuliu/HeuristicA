# HeuristicA - Boundary Layer Heuristic

This repo contains algorithm to compute the boundary layer heuristic for A* search. 

Borrowed from fluid dynamics, the concept of boundary layer is defined as the area in the proximity of obstacles such that once a nonholonomic vehicle enters, it must shift gear to escape. Informed with the position of the boundary layers, the vehicle can better evaluate the consequences of getting into those areas, and hence reach the goal node faster.

For details of the algorithm, refer to:

C. Liu, Y. Wang, and M. Tomizuka, "Boundary layer heuristic for search-based nonholonomic path planning in maze-like environments", in IEEE Intelligent Vehicle Symposium. IEEE, 2017, pp. 831-836. [Preprint](http://web.stanford.edu/~cliuliu/files/iv17-1.pdf) | [Poster](http://web.stanford.edu/~cliuliu/files/iv17-1poster.pdf)

![](https://github.com/changliuliu/HeuristicA/blob/master/boundary_layer_3D.jpg)

run test_BLheuristics.m to see the result.
