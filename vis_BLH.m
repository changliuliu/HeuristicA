function handle = vis_BLH(lines, corners, Hmap, theta_index, mapsize)
handle = figure;
hold on
for k = 1:size(lines,2)
    plot([lines{k}.p1(1);lines{k}.p2(1)],[lines{k}.p1(2);lines{k}.p2(2)],'LineWidth',3)
    midpoint = (lines{k}.p1+lines{k}.p2)/2;
    showvec = [midpoint, midpoint + lines{k}.nvec];
    plot(showvec(1,:),showvec(2,:));
end
for k = 1:size(corners,2)
    plot(corners{k}.p(1),corners{k}.p(2),'o','MarkerSize',10);
end


for k = 1:size(Hmap,1)
    i = mod(k-1, mapsize(1))+1;
    j = floor((k-1)/mapsize(1))+1;
    if Hmap(k,theta_index)>0
        plot(i,j,'.k','MarkerSize',5);
    end
end
end
