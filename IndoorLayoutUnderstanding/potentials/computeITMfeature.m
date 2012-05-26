function [ifeat, cloc, theta, dloc, dpose] = computeITMfeature(x, rule, idx, params, quickrun)
% (dx^2, dz^2, da^2) * n + view dependent biases
if nargin < 5
    quickrun = 0;
end
ifeat = zeros(rule.numparts * 3 + 8, 1);

pg.childs = idx;
if(quickrun)
    bottoms = zeros(1, length(pg.childs));
    for i = 1:length(pg.childs)
        cube = x.cubes{pg.childs(i)};
        bottoms(i) = -min(cube(2, :));
    end
    
    camh = mean(bottoms(bottoms > 0));
    pg.camheight = camh;
    pg.objscale = camh ./ bottoms; 
    
    
    if(isnan(camh))
        cloc = [0;0];
        theta = 0;
        dloc = [];
        dpose = [];
        return;
    end
else
    pg = findConsistent3DObjects(pg, x);
end
    
partslocs = x.locs(idx, [1 3]) .* repmat(pg.objscale', 1, 2);
partspose = x.locs(idx, 4);

cloc = mean(partslocs, 1);
theta = atan2(partslocs(2, 2) - partslocs(1, 2), partslocs(2, 1) - partslocs(1, 1));

R = rotationMat(theta);

dloc = ( partslocs - repmat(cloc, size(partslocs, 1), 1) ) * R;
dpose =  partspose - theta;

ibase = 0;
for i = 1:length(rule.parts)
    ifeat(ibase + 1) = (dloc(i, 1) - rule.parts(i).dx) ^ 2;
    ifeat(ibase + 2) = (dloc(i, 2) - rule.parts(i).dz) ^ 2;
    
    if(params.model.objmodel(rule.parts(i).citype).ori_sensitive)
        ifeat(ibase + 3) = anglediff(dpose(i), rule.parts(i).da) ^ 2;
    else
        % ignore orientation feature.. 
        % e.g. table, dining table - no consistent pose definition
        ifeat(ibase + 3) = 0;
    end
    ibase = ibase + 3;
end

% view dependent bias
idx = getposeidx(theta, 8);
ifeat(ibase + idx) = 1;

end