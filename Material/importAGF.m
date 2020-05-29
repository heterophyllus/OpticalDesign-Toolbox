% importAGF.m
% Load glass data from AGF. Data will exported to .mat file.
% 
% Usage
%       importAGF(agfpath)
% Input
%       agfpath     path to AGF
% Output
%       matName     exported .mat file name
%


function [matName] = importAGF(agfpath)

    errmsg = 'AGF file open error\n';
    [fid,errmsg] = fopen(agfpath,'r');
    if fid < 0
        matName = '';
        return;
    else
        [folder, name, ext] = fileparts(agfpath);
        matName = strcat(name, '.mat');
    end

    glasses = [];
    i = 0;
    while ~feof(fid)
        tline = fgetl(fid);
        token = strtok(tline);

        if size(token,1) == 0 % blank line
            continue;
        elseif strcmp(token,'NM')
            i = i+1;
            tlineParts = strsplit(tline);
            glasses(i).name = tlineParts{2};
            glasses(i).nd = str2double(tlineParts{5});
            glasses(i).vd = str2double(tlineParts{6});
            glasses(i).dispersionFormNum = str2num(tlineParts{3});
        elseif strcmp(token,'CD')
            tlineParts = strsplit(strtrim(tline));
            glasses(i).dispersionCoefs = zeros(10,1);
            for c=1:size(tlineParts,2)-1
                glasses(i).dispersionCoefs(c) = str2double(tlineParts{1+c});
            end
        end
    end
    glasses = glasses';
    save(matName, 'glasses');
    fclose(fid);
    fprintf('AGF data was exported to %s\n', matName);
end
