function handle = vis_BLH_3D(Hmap, theta_list, map)
handle = figure;
hold on
n = length(Hmap(1,:));
mapsize = size(map);
matrix3D = zeros(mapsize(1)+2,mapsize(2)+2,n+1);
map3D = matrix3D;
X = matrix3D; Y = X; Z = X;
for i=1:mapsize(1)+2
    for j =1:mapsize(2)+2
        for theta_index = 1:n
            X(i,j,theta_index) = (i-1)/2;
            Y(i,j,theta_index) = (j-1)/2;
            Z(i,j,theta_index) = theta_list(theta_index);
        end
        X(i,j,n+1) = (i-1)/2;
        Y(i,j,n+1) = (j-1)/2;
        Z(i,j,n+1) = 2*pi;
    end
end


for theta_index = 1:n
    map3D(2:end-1,2:end-1, theta_index) = map;
    for k = 1:size(Hmap,1)
        
        i = mod(k-1, mapsize(1))+1;
        j = floor((k-1)/mapsize(1))+1;
        if Hmap(k,theta_index)>0
            %plot3(j,i,mod(theta_list(theta_index)+pi,2*pi)-pi,'.k','MarkerSize',5);
            if map(i,j) == 0
                matrix3D(i+1,j+1,theta_index) = 2;
            end
        end
        
    end
end
old = matrix3D;
% Smoothing the matrix
for iter = 1:20
for i = 2:mapsize(1) + 1
    for j = 2:mapsize(2) + 1
        for k = 2:n
            bias = old(i+1,j,k) + old(i-1,j,k) + old(i,j+1,k) + old(i,j-1,k) + ...
                old(i,j,k+1) + old(i,j,k-1) + ...
                old(i+1,j+1,k) + old(i+1,j-1,k) + old(i+1,j,k+1) + old(i+1,j,k-1) + ...
                old(i-1,j+1,k) + old(i-1,j-1,k) + old(i-1,j,k+1) + old(i-1,j,k-1) + ...
                old(i,j+1,k+1) + old(i,j-1,k+1) + old(i,j+1,k-1) + old(i,j-1,k-1);
            matrix3D(i,j,k) = 0.2*old(i,j,k) + 0.9*bias/18;
            
%             if k == 2
%                 bias = old(i,j,k+1) + old(i,j,k+2) + old(i,j,k-1);
%                 matrix3D(i,j,k) = 0.2*old(i,j,k) + 0.8*bias/3;
%             else if k == n
%                 bias = old(i,j,k+1) + old(i,j,k-2) + old(i,j,k-1);
%                 matrix3D(i,j,k) = 0.2*old(i,j,k) + 0.8*bias/3;
%                 else
%                     
%             bias = old(i,j,k+1) + old(i,j,k+2) + old(i,j,k-1) + old(i,j,k-2);
%             matrix3D(i,j,k) = 0.2*old(i,j,k) + 0.8*bias/4;
%                 end
%             end
        end
    end
end
end
handle = patch(isosurface(X,Y,Z,matrix3D,1));
handle.FaceColor = [0.8 0.1 0];
handle.EdgeColor = 'none';
alpha(handle,0.6);

p = patch(isosurface(X,Y,Z,map3D,0.5));
p.FaceColor = [0.3,0.3,0.3];
p.EdgeColor = 'none';
alpha(p, 0.8);

xlim = [1/4-0.1, mapsize(1)/2+1/4+0.1];
ylim = [1/4-0.1, mapsize(2)/2+1/4+0.1];
zlim = [0,theta_list(end)+1/4];
wall1 = fill3([1 1 1 1]*xlim(1),[ylim(1) ylim(2) ylim(2) ylim(1)],[zlim(1) zlim(1) zlim(2) zlim(2)],'k');
wall2 = fill3([1 1 1 1]*xlim(2),[ylim(1) ylim(2) ylim(2) ylim(1)],[zlim(1) zlim(1) zlim(2) zlim(2)],'k');
wall3 = fill3([xlim(1) xlim(2) xlim(2) xlim(1)],[1 1 1 1]*ylim(2),[zlim(1) zlim(1) zlim(2) zlim(2)],'k');
wall4 = fill3([xlim(1) xlim(2) xlim(2) xlim(1)],[1 1 1 1]*ylim(1),[zlim(1) zlim(1) zlim(2) zlim(2)],'k');
alpha(wall1, 0.3);
alpha(wall2, 0.3);
alpha(wall3, 0.3);
alpha(wall4, 0.3);
zlabel('\theta (rad)')
xlabel('x (m)')
ylabel('y (m)')
axis([0 xlim(2) 0 ylim(2) 0 zlim(2)]);
daspect([1 1 0.5])
view(3)
camlight; lighting phong


end
