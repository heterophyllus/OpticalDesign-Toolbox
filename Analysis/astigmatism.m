% astigmatism.m
% plot longitudinal aberration
% 
% Usage
%   astigmatism(sys)     
% Input
%   sys     OpticalSystem object
%   

function [xfo, yfo] =  astigmatism(sys, f, w)

    ray1 = raytrace(sys, 0.0, 0.0, f, w);

    % opening
    s = Inf;
    t = Inf;
    if sys.object.distance == Inf
        s = Inf;
        t = Inf;
    else
        B = sys.object.distance;
        Zpr = sys.surface(1).sag( ray1.x(1), ray1.y(1) );
    end

    n = 1.0;
    for i = 1 : sys.surfaceCount
        cursurf = sys.surface(i);
        c     = cursurf.curvature;
        nd    = cursurf.material.index(Spectral.d/1000);
        cosI  = abs(cos( ray1.aoi(i) ));
        cosId = abs(cos( ray1.aor(i) ));
        phi   = c*(nd*cosId - n*cosI);

        sd = nd/(n/s+phi);
        td = (nd*(cosId)^2)/( (n*cosI^2)/t + phi );

        h1 = sqrt( ray1.x(i)^2 + ray1.y(i)^2 );
        h2 = sqrt( ray1.x(i+1)^2 + ray1.y(i+1)^2 );
        Z1 = sys.surface(i).sag(h1) ;
        Z2 = sys.surface(i+1).sag(h2 );
        d = cursurf.distance;
        cosUd = cos( atan(ray1.m(i+1)/ray1.n(i+1)) );
        D = (d+Z2-Z1)/cosUd;

        %fprintf('%d : c= %f, cosI= %f, cosId= %f, phi= %f, sd= %f, td= %f\n', i, c,cosI, cosId,phi, sd, td);

        s = sd-D;
        t = td-D;

        n = nd;
    end

    % closing
    ld = cursurf.distance;
    cosUpr = cos( atan( ray1.m(i+1)/ray1.n(i+1) ) );
    h1 = sqrt( ray1.x(i)^2 + ray1.y(i)^2 );
    Z = cursurf.sag( h1 );
    
    xfo = sd*cosUpr + Z -ld;
    yfo = td*cosUpr + Z -ld;

end
