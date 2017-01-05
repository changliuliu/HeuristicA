function [Hmap,lines,corners] = BLHeuristics(map,Rmin,theta_list)
mapsize = size(map);
% Find all of connected obstacles
CC = bwconncomp(map);
lines = {};
corners = {};
critical_points = zeros(mapsize);
for i=1:CC.NumObjects
    submap = zeros(mapsize);
    xlist = []; ylist = [];
    for k = 1:length(CC.PixelIdxList{i})
        index_i = mod(CC.PixelIdxList{i}(k)-1, mapsize(1))+1;
        index_j = floor((CC.PixelIdxList{i}(k)-1)/mapsize(1))+1;
        xlist = [xlist;index_i];
        ylist = [ylist;index_j];
        submap(index_i,index_j) = 1;
    end
    % Find lines and corners in the map
    line = map2line(submap,xlist,ylist);
    corner = findcorner(line);
    for k = 1:size(line,2)
        critical_points(line{k}.p1(1),line{k}.p1(2)) = 1;
        critical_points(line{k}.p2(1),line{k}.p2(2)) = 1;
    end
    for k = 1:size(corner,2)
        critical_points(corner{k}.p(1),corner{k}.p(2)) = 2;
    end
    lines = [lines line];
    corners = [corners corner];
end

nline = size(lines,2);
ncorner = size(corners,2);
Hmap = zeros(mapsize(1)*mapsize(2),length(theta_list));
perp = [0 1;-1 0];
for i = 1:max(size(theta_list))
    theta = pi/2 - theta_list(i);
    vec = [cos(theta),sin(theta)];
    for j = 1:nline
        if dot(vec,lines{j}.nvec) < 0
            thick = Rmin*(1-abs(dot([cos(theta-pi/2),sin(theta-pi/2)],lines{j}.nvec)));
            for ii = 1:round(thick)
                for jj = 0:norm(lines{j}.p1-lines{j}.p2)
                    shift = round(vec*perp*lines{j}.nvec)*ii;
                    point = lines{j}.p2 + ii*lines{j}.nvec + (jj+shift)*lines{j}.tvec;
                    point = round(point);
                    O1 = point + Rmin*[-sin(theta);cos(theta)];
                    O2 = point + Rmin*[sin(theta);-cos(theta)];
                    if point(1) <= mapsize(1) && point(2) <= mapsize(2) && point(1) >= 1 && point(2) >= 1
                        if critical_points(lines{j}.p2(1),lines{j}.p2(2)) < 2
                        if dot(lines{j}.tvec,(O1-lines{j}.p2)) < 0 && norm(O1-lines{j}.p2) > Rmin
                            continue;
                        end
                        else
                            if jj<-shift 
                                continue;
                            end
                        end
                        if critical_points(lines{j}.p1(1),lines{j}.p1(2)) < 2
                        if dot(lines{j}.tvec,(lines{j}.p1 - O2)) < 0 && norm(O2-lines{j}.p1) > Rmin
                            continue;
                        end
                        else
                            if jj>norm(lines{j}.p1-lines{j}.p2)-shift
                                continue;
                            end
                        end
                        
                        Hmap(point(1)+(point(2)-1)*mapsize(1),i) = 1;
                        
                    end
                end
            end
        end
    end
    for j = 1:ncorner
        if dot(vec,corners{j}.n1) < 0 || dot(vec,corners{j}.n2) < 0
            d1 = Rmin*(1-dot([cos(theta-pi/2),sin(theta-pi/2)],corners{j}.n1));
            d2 = Rmin*(1-dot([cos(theta+pi/2),sin(theta+pi/2)],corners{j}.n2));
            point = corners{j}.p + d1*corners{j}.n1+d2*corners{j}.n2;
            O1 = point + Rmin*[-sin(theta);cos(theta)];
            O2 = point + Rmin*[sin(theta);-cos(theta)];
            M1 = O1 - Rmin*corners{j}.n2;
            M2 = O2 - Rmin*corners{j}.n1;
            m1 = norm(M1 - corners{j}.p);
            m2 = norm(M2 - corners{j}.p);
            for ii = 1:min([d1,corners{j}.l2+d1-m1])
                for jj = 1:min([d2,corners{j}.l1+d2-m2])
                    point = corners{j}.p + ii*corners{j}.n1 + jj*corners{j}.n2;
                    if point(1) <= mapsize(1) && point(2) <= mapsize(2) && point(1) >= 1 && point(2) >= 1
                        Hmap(point(1)+(point(2)-1)*mapsize(1),i) = 1;
                    end
                end
            end
        end
    end
end

end
