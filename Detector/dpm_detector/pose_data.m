function [pos, neg] = pose_data(cls)

% [pos, neg] = pascal_data(cls)
% Get training data from the PASCAL dataset.

globals;
VOC2006 = false;
pascal_init;

switch cls
    case {'car'}
        index_train = 1:240;
    case {'bicycle'}
        index_train = 1:360;
    case {'chair'}
        index_train = 1:770;
    case {'bed'};
        index_train = 1:400;
    case {'sofa'}
        index_train = 1:800;
        index_train2 = 1:874;
    case {'table'}
        index_train = 1:670;        
end

try
  load([cachedir cls '_train_pose']);
catch
    
  % positive examples from train+val
  fprintf('Read 3DObject samples\n');
  pos = read_positive(cls, index_train);
  pos2 = read_positive2(cls, index_train2);
  pos = [pos, pos2];
  clear pos2;
  % negative examples from train (this seems enough!)
  ids = textread(sprintf(VOCopts.imgsetpath, 'train'), '%s');
  neg = [];
  numneg = 0;
  for i = 1:length(ids);
    if(mod(i, 50) == 0)
        fprintf('%s: parsing negatives: %d/%d\n', cls, i, length(ids));
    end
    rec = PASreadrecord(sprintf(VOCopts.annopath, ids{i}));
    clsinds = strmatch(cls, {rec.objects(:).class}, 'exact');
    if isempty(clsinds)
      numneg = numneg+1;
      neg(numneg).im = [VOCopts.datadir rec.imgname];
      neg(numneg).flip = false;
    end
  end
  
  save([cachedir cls '_train_pose'], 'pos', 'neg');
end

% read positive training images
function pos = read_positive(cls, index_train)

N = numel(index_train);
path_image = sprintf('../../Data_Collection/yuxiangdata/Images/%s', cls);
path_anno = sprintf('../../Data_Collection/yuxiangdata/Annotations/%s', cls);

count = 0;
for i = 1:N
    index = index_train(i);
    file_ann = sprintf('%s/%04d.mat', path_anno, index);
    image = load(file_ann);
    object = image.object;
    if isfield(object, 'view') == 0
        continue;
    end
    bbox = object.bbox;
    n = size(bbox, 1);
    if n ~= 1
        fprintf('Training image %d contains multiple instances.\n', i);
    end
    view = object.view;
    file_img = sprintf('%s/%s', path_image, object.image);
    for j = 1:n
        if view(j,1) == -1
            continue;
        end
        count = count + 1;
        pos(count).im = file_img;
        pos(count).x1 = bbox(j,1);
        pos(count).y1 = bbox(j,2);
        pos(count).x2 = bbox(j,1)+bbox(j,3);
        pos(count).y2 = bbox(j,2)+bbox(j,4);
        pos(count).flip = false;
        pos(count).trunc = 0;
        pos(count).azimuth = view(j,1);
        %%% wongun added %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        pos(count).mirrored = false;
        pos(count).subid = 1;
        count = count + 1;
        pos(count).im = file_img;
        pos(count).x1 = bbox(j,1);
        pos(count).y1 = bbox(j,2);
        pos(count).x2 = bbox(j,1)+bbox(j,3);
        pos(count).y2 = bbox(j,2)+bbox(j,4);
        pos(count).flip = false;
        pos(count).trunc = 0;
        pos(count).azimuth = 360 - view(j,1);
        %%% wongun added
        pos(count).mirrored = true;
        pos(count).subid = 1;
        %%% wongun added %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

%%% wongun added
% read positive training images
function pos = read_positive2(cls, index_train)

N = numel(index_train);
path_image = sprintf('../../Data_Collection/objdata/images/%s', cls);
path_anno = sprintf('../../Data_Collection/objdata/annotation/%s', cls);

count = 0;
for i = 1:N
    index = index_train(i);
    file_ann = sprintf('%s/annotation%05d.mat', path_anno, index);
    anno = load(file_ann);
    
    object = anno.anno;
    view = (object.azimuth) * 180 / pi;
    if view < 0
        view = view + 360;
    end
    
    count = count + 1;
    
    imfile = object.im(find(object.im == '/', 1, 'last')+1:end);
    imfile = fullfile(path_image, imfile);
    
    pos(count).im = imfile;
    pos(count).x1 = object.x1;
    pos(count).y1 = object.y1;
    pos(count).x2 = object.x2;
    pos(count).y2 = object.y2;
    pos(count).flip = false;
    pos(count).trunc = 0;
    pos(count).azimuth = view;
    %%% wongun added %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pos(count).mirrored = false;
    pos(count).subid = object.subid;
    
    count = count + 1;
    pos(count).im = imfile;
    pos(count).x1 = object.x1;
    pos(count).y1 = object.y1;
    pos(count).x2 = object.x2;
    pos(count).y2 = object.y2;
    pos(count).flip = false;
    pos(count).trunc = 0;
    pos(count).azimuth = 360 - view;
    %%% wongun added
    pos(count).mirrored = true;
    pos(count).subid = object.subid;
    %%% wongun added %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if isfield(object, 'view') == 0
%         continue;
%     end
%     bbox = object.bbox;
%     n = size(bbox, 1);
%     if n ~= 1
%         fprintf('Training image %d contains multiple instances.\n', i);
%     end
%     view = object.view;
%     file_img = sprintf('%s/%s', path_image, object.image);
%     for j = 1:n
%         if view(j,1) == -1
%             continue;
%         end
%         count = count + 1;
%         pos(count).im = file_img;
%         pos(count).x1 = bbox(j,1);
%         pos(count).y1 = bbox(j,2);
%         pos(count).x2 = bbox(j,1)+bbox(j,3);
%         pos(count).y2 = bbox(j,2)+bbox(j,4);
%         pos(count).flip = false;
%         pos(count).trunc = 0;
%         pos(count).azimuth = view(j,1);
%         %%% wongun added %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         pos(count).mirrored = false;
%         count = count + 1;
%         pos(count).im = file_img;
%         pos(count).x1 = bbox(j,1);
%         pos(count).y1 = bbox(j,2);
%         pos(count).x2 = bbox(j,1)+bbox(j,3);
%         pos(count).y2 = bbox(j,2)+bbox(j,4);
%         pos(count).flip = false;
%         pos(count).trunc = 0;
%         pos(count).azimuth = 360 - view(j,1);
%         %%% wongun added
%         pos(count).mirrored = true;
%         %%% wongun added %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     end
end