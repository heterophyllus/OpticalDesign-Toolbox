% longitudinal.m
% plot longitudinal aberration
% 
% Usage
%   longitudinal(sys)     
% Input
%   sys     OpticalSystem object
%   

function longitudinal(sys, lsarange=[-0.5 0.5], astrange=[-0.5 0.5])

    figure;

    % longitudinal spherical aberration
    si = sys.surfaceCount + 1;
    colors = sys.wvl.color;
    nwvls = size(sys.wvl.data,2);
    nflds = sys.fieldCount;
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

        
        subplot(1,2,1);
        title('LSA');
        plot(x,y,colors{w});
        xlim(lsarange);
        hold on;
    end


    % astigmatism

    w = 2;
    y = [];
    s = [];
    t = [];
    maxAngle = sys.maxField;
    division = 20;
    fields = zeros(division+1);
    for i = 1:division+1
        fields(i) = maxAngle*(i-1)/division;
        colors{i} = 'k';
    end
    sys.setFieldOfView('Angle', fields, colors);

    %s(1) = 0.0;
    %t(1) = 0.0;
    for f=1:sys.fieldCount
        [xfo, yfo] = astigmatism(sys, f, w);
        y(f) = sys.field(f).y;
        s(f) = xfo;
        t(f) = yfo;
    end

    
    subplot(1,2,2);
    title('Astigmatism');
    plot(s,y,'-k');hold on;
    plot(t,y, '--k');
    xlim(astrange);
    ylim([0 maxAngle]);

end

