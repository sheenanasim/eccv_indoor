clear

corrector = 'wongun';

setname = 'set10';

imbase = ['livingroom/' setname '/'];
annobase = ['annotation/livingroom_temp/' setname '/'];
verifiedbase = ['annotation/livingroom/' setname '/'];

imfiles = dir(fullfile(imbase, '*.JPEG'));

if(~exist(verifiedbase, 'dir'))
    mkdir(verifiedbase);
end

%%%%%%%
for i = 1:length(imfiles)
    idx = find(imfiles(i).name == '.', 1, 'last');
    
    annofile = [imfiles(i).name(1:idx-1) '_labels.mat'];
    
    orgfile = fullfile(annobase, [imfiles(i).name(1:end-4) '_labels.mat']);
    if ~exist(orgfile, 'file')
        disp(['missing ' orgfile]);
        continue;
    end
    
    destfile = fullfile(verifiedbase, annofile);
    if exist(destfile, 'file')
        orgfile = destfile;
    end
    
    draw_annotation(fullfile(imbase, imfiles(i).name), orgfile);
    if('y' == input('Correct annotation? [y/n]', 's'))
        correct_annotation(fullfile(imbase, imfiles(i).name), orgfile, destfile, corrector);
    else
        if ~strcmp(orgfile, destfile)
            copyfile(orgfile, destfile);
        end
    end
end