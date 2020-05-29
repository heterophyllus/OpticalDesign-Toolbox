% raytrace.m
% traces a ray with pupil coordinate
%
% Input
%       sys         OpticalSystem object
%       px          x pupil coordinate
%       py          y pupil coordinate
%       fldNum      field number to be traced
%       wvlNum      wavelength number to be traced
%
% Output
%       rayObj       ray trace data
%       passthrough  true if the ray reached image plane


function [varargout] = raytrace(sys, px, py, fldNum=1, wvlNum = 1)

    passthrough = true;
    rayObj = Ray();
    rayObj.reserve(sys.surfaceCount+1);

    epd = sys.pupil.diameter;
    enp = sys.pupil.distance;

    % Not accurate. Should be fixed.
    vpx = sys.field(fldNum).applyVignettingX(px);
    vpy = sys.field(fldNum).applyVignettingY(py);
    aimPt = [epd/2, epd/2, enp].*[ vpx, vpy, 1.0];
    %aimPt = [epd/2, epd/2, enp].*[ px, py, 1.0];
    aimDirection = sys.field(fldNum).chiefRayDirection;

    % opening
    objd = sys.object.distance;
    if objd == Inf
        t = -aimPt(3)/aimDirection(3);
        srcPt = aimPt + t.*aimDirection; % on the tangent plane of 1st surafce
    else
        t = (-aimPt(3)-objd)/aimDirection(3);
        srcPt = aimPt + t.*aimDirection; % on the object plane
    end

    %srcPt = srcPt;
    srcDir = aimDirection;
    [rayObj, passthrough] = raytrace_raw(sys, srcPt, srcDir, fldNum, wvlNum);

    varargout{1} = rayObj;
    varargout{2} = passthrough;

end


