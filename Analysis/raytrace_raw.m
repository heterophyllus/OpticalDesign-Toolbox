% raytrace_raw.m
% ray trace base function
% 
% trace a ray from source point to image plane
%
% Input
%       sys
%       pt0
%       dir0
%       fldNum
%       wvlNum


function [varargout] = raytrace_raw(sys, pt0, dir0, fldNum=1, wvlNum = 1)

    passthrough = true;
    rayObj = Ray();
    rayObj.reserve(sys.surfaceCount+1);
    

    % loop surface
    srcPt = pt0;
    srcDir = dir0;
    rayObj.sourcePosition = srcPt;
    rayObj.sourceDirection = srcDir;
    wvlmicron = sys.wvl.data(wvlNum)/1000;
    nin = 1.0;
    for i = 1:sys.surfaceCount
        cursurf = sys.surface(i);
        nout = cursurf.material.index(wvlmicron);
        [xyz] = cursurf.intersect(srcPt,srcDir);
        if norm([xyz(1) xyz(2)]) > cursurf.aperture
            passthrough = false;
            %continue;
            %break;
        end
        [lmn, snorm] = cursurf.refract(xyz,srcDir, nin, nout);
        %rayObj.append(xyz,lmn);
        rayObj.insert(i,xyz,lmn,snorm);
        srcPt = xyz.-[0,0, cursurf.distance];
        srcDir = lmn;
        nin = nout;
    end

    % closing

    i = i+1;
    [xyz] = sys.surface(i).intersect(srcPt,srcDir);
    [lmn,snorm] = cursurf.refract(xyz,srcDir,nin, 1.0);
    %rayObj.append(xyz,lmn);
    rayObj.insert(i,xyz,lmn,snorm);


    varargout{1} = rayObj;
    varargout{2} = passthrough;

end