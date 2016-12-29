load('map_for_test.mat');
lines = map2line(map);
corners = findcorner(lines);

critical_points = zeros(size(map));

hold on
for k = 1:size(lines,2)
    plot([lines{k}.p1(1);lines{k}.p2(1)],[lines{k}.p1(2);lines{k}.p2(2)],'LineWidth',3)
    midpoint = (lines{k}.p1+lines{k}.p2)/2;
    showvec = [midpoint, midpoint + lines{k}.nvec];
    plot(showvec(1,:),showvec(2,:));
    critical_points(lines{k}.p1(1),lines{k}.p1(2)) = 1;
    critical_points(lines{k}.p2(1),lines{k}.p2(2)) = 1;
end
for k = 1:size(corners,2)
    plot(corners{k}.p(1),corners{k}.p(2),'o','MarkerSize',10);
    critical_points(corners{k}.p(1),corners{k}.p(2)) = 2;
end



nline = size(lines,2);
ncorner = size(corners,2);

Rmin = 10;

theta_list = [pi];
Hmap = zeros(size(map));%,max(size(theta_list)));
perp = [0 1;-1 0];
for i = 1:max(size(theta_list))
    theta = theta_list(i);
    vec = [cos(theta),sin(theta)];
    for j = 1:nline
        if dot(vec,lines{j}.nvec) < 0
            thick = Rmin*(1-abs(dot([cos(theta-pi/2),sin(theta-pi/2)],lines{j}.nvec)));
            for ii = 1:round(thick)
                for jj = 0:norm(lines{j}.p1-lines{j}.p2)
                    shift = round(vec*perp*lines{j}.nvec)*ii;
                    point = lines{j}.p2 + ii*lines{j}.nvec + (jj+shift)*lines{j}.tvec;
                    O1 = point + Rmin*[-sin(theta);cos(theta)];
                    O2 = point + Rmin*[sin(theta);-cos(theta)];
                    if point(1) <= 100 && point(2) <= 100 && point(1) >= 1 && point(2) >= 1
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
                        
                        Hmap(point(1),point(2)) = 10;
                        plot(point(1),point(2),'.k','MarkerSize',5)
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
                    if point(1) <= 100 && point(2) <= 100 && point(1) >= 1 && point(2) >= 1
                        Hmap(point(1),point(2)) = 10;
                        plot(point(1),point(2),'.k','MarkerSize',5)
                    end
                end
            end
        end
    end
end
% for i = 1:100
%     for j = 1:100
%         if Hmap(i,j)>0
%             plot(i,j,'.k','MarkerSize',5);
%         end
%     end
% end
axis equal
