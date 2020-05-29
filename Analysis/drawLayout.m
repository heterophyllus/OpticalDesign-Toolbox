% drawLayout.m
% draw system layout
%
%

function drawLayout(sys)

    zstart = 0;
    
    % draw lens
    for i = 1:(sys.surfaceCount+1)
        cursurf = sys.surface(i);
        if (cursurf.material.nd > 1.0) || (i == sys.surfaceCount+1)
            nextsurf = sys.surface(i+1);
            ape = cursurf.aperture;
            thi = cursurf.distance;

            u = linspace(-ape,ape,40); 
            z = [cursurf.sag(u) thi+nextsurf.sag(u) cursurf.sag(-ape)] .+ zstart;
            y = [u -u -ape];
            
            plot(z,y,'k');
            hold on;
        end
        zstart = zstart + cursurf.distance;
    end

    % draw image plane
    % 

    % scaling axis
    xl = xlim;
    xm = abs(diff(xl)) * 0.1;
    xl = xl .+ [-xm xm];
    xlim(xl);

    yl = ylim;
    ym = abs(diff(yl)) * 0.1;
    yl = yl .+ [-ym ym];
    ylim(yl);

end
