function draw3Dcube(cube, figid, col)
if nargin < 3
    col = 'm';
end
cube = cube';
% place 3D model
X = [   cube(1, 1), cube(2, 1), cube(4, 1), cube(3, 1); ...
        cube(1, 1), cube(2, 1), cube(6, 1), cube(5, 1); ...
        cube(2, 1), cube(4, 1), cube(8, 1), cube(6, 1); ...
        cube(1, 1), cube(3, 1), cube(7, 1), cube(5, 1); ...
        cube(3, 1), cube(4, 1), cube(8, 1), cube(7, 1); ...
        cube(5, 1), cube(6, 1), cube(8, 1), cube(7, 1); ...
        ]';
    
Y = [   cube(1, 2), cube(2, 2), cube(4, 2), cube(3, 2); ...
        cube(1, 2), cube(2, 2), cube(6, 2), cube(5, 2); ...
        cube(2, 2), cube(4, 2), cube(8, 2), cube(6, 2); ...
        cube(1, 2), cube(3, 2), cube(7, 2), cube(5, 2); ...
        cube(3, 2), cube(4, 2), cube(8, 2), cube(7, 2); ...
        cube(5, 2), cube(6, 2), cube(8, 2), cube(7, 2); ...
        ]';
    
Z = [   cube(1, 3), cube(2, 3), cube(4, 3), cube(3, 3); ...
        cube(1, 3), cube(2, 3), cube(6, 3), cube(5, 3); ...
        cube(2, 3), cube(4, 3), cube(8, 3), cube(6, 3); ...
        cube(1, 3), cube(3, 3), cube(7, 3), cube(5, 3); ...
        cube(3, 3), cube(4, 3), cube(8, 3), cube(7, 3); ...
        cube(5, 3), cube(6, 3), cube(8, 3), cube(7, 3); ...
        ]';

figure(figid);
hold on;
for i=1:6
    h=patch(X(:, i), Y(:, i), Z(:, i), col);
    set(h,'edgecolor','k', 'linewidth',5, 'FaceAlpha', 0.6);
    plot3(cube(1,1), cube(1,2), cube(1, 3) , 'k.', 'MarkerSize', 40);
end
hold off;

end