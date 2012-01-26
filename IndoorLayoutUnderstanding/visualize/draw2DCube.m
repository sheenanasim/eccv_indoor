function draw2DCube(poly, fignum)

idx= [1 2; 2 4; 4 3; 3 1; ...
    5 6; 6 8; 8 7; 7 5; ...
    2 6; 4 8; ...
    1 5; 3 7 ];

figure(fignum);
hold on;
for i = 1:size(idx, 1)
    plot([poly(1, idx(i, 1)) poly(1, idx(i, 2))], [poly(2, idx(i, 1)) poly(2, idx(i, 2))], 'r.-');
end
hold off;

end