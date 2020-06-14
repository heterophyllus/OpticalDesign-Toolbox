% longitudinal.m
% plot longitudinal aberration
% 
% Usage
%   longitudinal(sys)     
% Input
%   sys     OpticalSystem object
%   

function lsa(sys, xl=[-0.5 0.5])

    figure;

    si = sys.surfaceCount + 1;
    colors = sys.wvl.color;
    nwvls = size(sys.wvl.data,2);
    nflds = sys.fieldCount;

    % longitudinal spherical aberration
    f = 1;
    
    for w = 1:nwvls
        k = 0;
        x = [];
        y = [];
        for py = 0.0:0.05:1.0
            k = k+1;
            ray = raytrace(sys,0.0,py,f,w);
            x(k) = -(ray.y(si)) * ( ray.n(si)/ray.m(si) );
            y(k) = py;
        end
        plot(x,y,colors{w});
        hold on;
    end

    xlim(xl);
    hold off;


end

