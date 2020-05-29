% transverse.m
% plot transverse ray fan
% 
% Usage
%   transverse(sys, yl)      
% Input
%   sys     OpticalSystem object
%   yl      vertical axis range
%

function transverse(sys, yl=[-0.2 0.2])

    figure;

    si = sys.surfaceCount + 1;
    colors = sys.wvl.color;
    nwvls = size(sys.wvl.data,2);
    nflds = sys.fieldCount;


    % stop aperture
    [ray] = raytrace(sys, 0.0, 1.0, 1,2);
    h0 = ray.y(sys.stop);

    % tangential
    for f = 1:nflds % loop for all fields
        %fprintf('F%d\n',f);

        % chief ray at reference wvl
        [ray] = raytrace(sys, 0.0, 0.0, f,2);
        y0 = ray.y(si);

        for w = 1:nwvls % loop for all wavelengths
            %fprintf('   W%d\n',w);
            
            x = [];
            y = [];
            px = 0.0;
            k = 0;
            for py = -1.0:0.1:1.0 % pupil
                
                [ray, passthrough] = raytrace(sys, px, py, f,w);
                if passthrough
                    k = k+1;
                    %x(k) = py;
                    y(k) = ray.y(si);

                    x(k) = ray.y(sys.stop)/h0; % ray height at stop surface
                end
            end
            
            y = y.-y0;
            ylim(yl);
            xlim([-1 1]);
            subplot(nflds,1, nflds-f+1);
            plot(x,y,colors{w});
            title(strcat('F',num2str(f)));
            grid on;
            hold on; 
        end

    end
    hold off;

    
    % sagittal
    figure;
    for f = 1:nflds
        % chief ray at reference wvl
        [ray] = raytrace(sys, 0.0, 0.0, f,2);
        y0 = ray.x(si);

        for w = 1:nwvls
            %fprintf('   W%d\n',w);
            x = [];
            y = [];
            py = 0.0;
            k=0;
            for px = 0.0:0.1:1.0
                [ray, passthrough] = raytrace(sys, px, py, f,w);
                if passthrough
                    k = k+1;
                    %x(k) = px;
                    y(k) = ray.x(si);

                    x(k) = ray.x(sys.stop)/h0;
                end
            end
            y = y.-y0;
            ylim(yl);
            xlim([0 1]);
            subplot(nflds,1, nflds-f+1);
            plot(x,y,colors{w});
            title(strcat('F',num2str(f)));
            grid on;
            hold on;
        end

    end

end

