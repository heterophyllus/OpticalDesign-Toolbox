% drawRay.m
% Draw a single ray on the figure
%

function drawRay(sys, ray, clr= 'k')
    zstart = 0;

    rz = ray.z;
    ry = ray.y;

    for i = 1:(sys.surfaceCount+1)
        cursurf = sys.surface(i);
        
        rz(i) = rz(i) + zstart;
        zstart = zstart + cursurf.distance;
    end

    plot(rz, ry, clr);
end
