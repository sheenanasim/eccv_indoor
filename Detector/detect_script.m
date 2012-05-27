load ./Models/dpm_mine/sidetable_final.mat
process_onedir( '../Data_Collection/diningroom/', ...
                'results/DPM_MINE_AUG/diningroom/sidetable/', ...
                {model}, {'sidetable'}, {'jpg'})

process_onedir( '../Data_Collection/livingroom/', ...
                'results/DPM_MINE_AUG/livingroom/sidetable/', ...
                {model}, {'sidetable'}, {'jpg'})
            
process_onedir( '../Data_Collection/bedroom/', ...
                'results/DPM_MINE_AUG/bedroom/sidetable/', ...
                {model}, {'sidetable'}, {'jpg'})

%load ./Models/dpm_mine/table_final.mat
%process_onedir( '../Data_Collection/diningroom/', ...
%                'results/DPM_MINE_AUG/diningroom/table/', ...
%                {model}, {'table'}, {'jpg'})
            
%load ./Models/dpm_mine/chair_final.mat
%process_onedir( '../Data_Collection/diningroom/', ...
%                'results/DPM_MINE_AUG/diningroom/chair/', ...
%                {model}, {'chair'}, {'jpg'})
            
%load ./Models/dpm_mine/bed_final.mat
%process_onedir( '../Data_Collection/diningroom/', ...
%                'results/DPM_MINE_AUG/diningroom/bed/', ...
%                {model}, {'bed'}, {'jpg'})            
