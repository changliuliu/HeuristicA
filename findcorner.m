function corners = findcorner(lines)
corners = {};
ncorner = 0;
nline = max(size(lines));
perp = [0 1; -1  0];
for i=1:nline-1
    if lines{i}.p1 == lines{i+1}.p2
        if lines{i+1}.nvec'*perp*lines{i}.nvec > 0
            ncorner = ncorner + 1;
            corners{ncorner}.p = lines{i}.p1;
            corners{ncorner}.n1 = lines{i+1}.nvec;
            corners{ncorner}.n2 = lines{i}.nvec;
            corners{ncorner}.l1 = norm(lines{i+1}.p1-lines{i+1}.p2);
            corners{ncorner}.l2 = norm(lines{i}.p1-lines{i}.p2);
        end
    end
    if lines{i}.p2 == lines{i+1}.p1
        if lines{i}.nvec'*perp*lines{i+1}.nvec > 0
            ncorner = ncorner + 1;
            corners{ncorner}.p = lines{i+1}.p1;
            corners{ncorner}.n1 = lines{i}.nvec;
            corners{ncorner}.n2 = lines{i+1}.nvec;
            corners{ncorner}.l1 = norm(lines{i}.p1-lines{i}.p2);
            corners{ncorner}.l2 = norm(lines{i+1}.p1-lines{i+1}.p2);
        end
    end
end