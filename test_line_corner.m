lines = map2line(map');
corners = findcorner(lines);
hold on
for k = 1:size(lines,2)
    plot([lines{k}.p1(1);lines{k}.p2(1)],[lines{k}.p1(2);lines{k}.p2(2)],'LineWidth',3)
    midpoint = (lines{k}.p1+lines{k}.p2)/2;
    showvec = [midpoint, midpoint + lines{k}.nvec];
    plot(showvec(1,:),showvec(2,:));
end
for k = 1:size(corners,2)
    plot(corners{k}.p(1),corners{k}.p(2),'o','MarkerSize',10)
end