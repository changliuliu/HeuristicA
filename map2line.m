function lines = map2line(map)
x = []; y = [];
for i=1:size(map,1)
    for j=1:size(map,2)
        if map(i,j)>0
            x = [x;i];
            y = [y;j];
        end
    end
end
k_list = boundary(x,y,1);
%plot(x(k_list),y(k_list))

lines = {}; nline = 0;
perp = [0 -1;1 0];
k = 1; p1 = [x(k_list(k));y(k_list(k))];
while k < size(k_list,1)
    nline = nline + 1;
    vec = [x(k_list(k+1));y(k_list(k+1))] - [x(k_list(k));y(k_list(k))];
    k0 = k;
    if map(x(k_list(k))-vec(2),y(k_list(k))+vec(1)) > map(x(k_list(k))+vec(2),y(k_list(k))-vec(1))
        nvec = perp'*vec;
    else
        nvec = perp*vec;
    end
    while k < size(k_list,1) && dot([x(k_list(k+1));y(k_list(k+1))] - p1, nvec) == 0
        k = k+1;
    end
    if k - k0 < 2
        nline = nline - 1;
        lines{nline}.p2 = lines{nline}.p2 + [x(k_list(k0));y(k_list(k0))] - [x(k_list(k0-1));y(k_list(k0-1))];
        k = k0 + 1;
        p1 = lines{nline}.p2;
    else
        p2 = [x(k_list(k));y(k_list(k))];
        
        lines{nline}.p1 = p1;
        lines{nline}.p2 = p2;
        lines{nline}.nvec = nvec;
        p1 = p2;
    end
end

%hold on
for k = 1:size(lines,2)
    if (lines{k}.p1-lines{k}.p2)'*perp*lines{k}.nvec<0
        p = lines{k}.p1;
        lines{k}.p1 = lines{k}.p2;
        lines{k}.p2 = p;
    end
    lines{k}.tvec = lines{k}.p1 - lines{k}.p2;
    lines{k}.tvec = lines{k}.tvec/norm(lines{k}.tvec);
    %plot([lines{k}.p1(1);lines{k}.p2(1)],[lines{k}.p1(2);lines{k}.p2(2)])
end
end