function show2DGraph(pg, x, icluster, fig2d)
% imshow(x.imfile);
if nargin < 4
    fig2d = 1000;
end
figure(fig2d); 
clf;

om = objmodels();

ShowGTPolyg(imread(x.imfile), x.lpolys(pg.layoutidx, :), fig2d)
for i = 1:length(pg.childs)
    idx = pg.childs(i);
    
    if(icluster(idx).isterminal)
        oid = icluster(idx).ittype;
        drawObject(x, idx, oid, om, fig2d);
    else
        childs = icluster(idx).chindices;
        bbs = zeros(length(childs), 4);
        for j = 1:length(childs)
            oid = icluster(childs(j)).ittype;
            bbs(j, :) = drawObject(x, childs(j), oid, om, fig2d);
        end
        drawITMLink(bbs);
    end
%     rectangle('position', bbox2rect(x.dets(idx, 4:7)), 'linewidth', 2, 'edgecolor', 'm');
%     [poly, rt] = get2DCubeProjection(x.K, x.R, x.cubes{idx});
%     draw2DCube(poly, rt, fig2d, om(x.dets(idx, 1)).name, col(oid));
end
str = ['Best sample, lkhood : ' num2str(pg.lkhood, '%.03f')];
text(10, 20, str, 'backgroundcolor', 'w', 'edgecolor', 'k', 'linewidth', 2);

end

function drawITMLink(bbs)
objct = zeros(size(bbs, 1), 2);
for i = 1:size(bbs, 1)
    objct(i, :) = bbox2ct(bbs(i, :));
end
ct = mean(objct, 1);
for i = 1:size(bbs, 1)
    line([ct(1) objct(i, 1)], [ct(2) objct(i, 2)], 'LineWidth',8, 'Color', 'k', 'linestyle', '-.');
    line([ct(1) objct(i, 1)], [ct(2) objct(i, 2)], 'LineWidth',4, 'Color', 'w', 'linestyle', '-.');
    rectangle('position', [objct(i, 1) - 10, objct(i, 2) - 10, 20, 20], 'facecolor', 'w', 'edgecolor', 'k', 'linewidth', 4);
end
% rectangle('position', bbox2rect(bbox), 'linewidth', 4, 'linestyle', '-.', 'edgecolor', 'w');
rectangle('position', [ct(1) - 10, ct(2) - 10, 20, 20], 'Curvature', .8, 'facecolor', 'c', 'edgecolor', 'k', 'linewidth', 4);

end

function [bbox] = drawObject(x, idx, oid, om, fig2d)

col = 'rgbykmcrgbykmcrgbykmcrgbykmc';

rectangle('position', bbox2rect(x.dets(idx, 4:7)), 'linewidth', 2, 'edgecolor', 'm');
[poly, rt] = get2DCubeProjection(x.K, x.R, x.cubes{idx});
draw2DCube(poly, rt, fig2d, om(x.dets(idx, 1)).name, col(oid));

bbox = x.dets(idx, 4:7);

end
