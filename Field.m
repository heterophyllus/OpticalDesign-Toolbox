%% Field
% Field property container
%
% Class to contain field properties
%
% properties
%       sourcePt
%       sourceDir
%       x       x coordinate/angle
%       y       y coordinate/angle
%       vdx     vignetting factor
%       vdy     vignetting factor
%       vcx     vignetting factor
%       vcy     vignetting factor
%       weight  weight
%       color   color for plot
%
% Note
%       P'x = VDX + Px(1 - VCX)

classdef Field
    properties(Access = public)
        x = 0.0;
        y = 0.0;
        vdx = 0.0; % shift
        vcx = 0.0; % scale
        vdy = 0.0;
        vcy = 0.0;
        chiefRayDirection = [0.0, 0.0, 1.0];
        weight = 1.0;
        color = 'b';

        % reference rays
        ray1 = Ray();
        ray2 = Ray();
        ray3 = Ray();
    end


    methods
        function vp = applyVignettingX(self, px) 
            a = 1 - self.vcx;
            b = self.vdx;
            vp = b + a*px;
        end

        function vp = applyVignettingY(self, py) 
            a = 1 - self.vcy;
            b = self.vdy;
            vp = b + a*py;
        end
    end
end
