
classdef Surface < handle
    properties
        aperture = Inf;
        radius = Inf;
        distance = 0.0;
        material = Material;
        shape= 'SPH';
        name = '';
    end

    properties(Dependent)
        curvature;
    end


    methods
        function self = Surface(rdy=0, d=0, m=Material, ap=Inf)
            if nargin ~= 0
                self.radius = rdy;
                self.distance = d;
                self.material = m;
                self.aperture = ap;
            end
        end

        function val = get.curvature(self)
            % getter of self.curvature
            %   s.curvature

            if self.radius == 0.0 % avoid warning
                val = Inf;
            else
                val = 1/self.radius;
            end
        end

        function disp(self)
            % disp  display object property list
            %
            % disp(s)
            % s.disp

            fprintf('Surface: %s\n', self.name);
            fprintf('R= %f\n', self.radius);
            fprintf('D= %f\n', self.distance);
            fprintf('Material : %s\n', self.material.name);
            fprintf('    Nd= %f\n', self.material.nd);
            fprintf('    Vd= %f\n', self.material.vd);

        end

        function zval = sag(self, h)
            if strcmp(self.shape, 'SPH')
                r = self.radius;
                if r == Inf % flat 
                    zval = zeros(size(h));
                else
                    zval = -sign(r)*sqrt(r^2 .- h.^2) .+ r;
                end
            else
                zval = zeros(size(h));
            end
        end

        function F = surffunc(self, p) % F(x,y,z) = 0
            if strcmp(self.shape, "SPH") % x^2 + y^2 + (z-r)^2 - r^2 = 0
                r = self.radius;
                
                x = p .- [0,0,r];
                F = sum(x.^2) - r.^2;
            else
                F = 0;
            end
        end

        function vec = surfgrad(self,p)
            if self.shape == "SPH"
                r = self.radius;
                x = p - [0,0,r];
                vec = 2.*x;
            else
                vec = [0,0,0];
            end
        end

        function vec = surfnorm(self,p)
            % returns surface norm vector
            % Inputs
            %       p=[x,y,z]      the position on the surface
            %
            % Outputs
            %       vec = [L,M,N]  Surface norm vector expressed as direction cosine
            % 

            if strcmp(self.shape, 'SPH')
                if self.radius == Inf
                    vec = [0,0,-1];
                else
                    vec = p - [0, 0, self.radius];
                    vec = vec./norm(vec);
                end
            end
        end

        function [pt] = intersect(self, pt0, dir0)
            % intersect
            % Returns intersect point
            %
            % Input
            %       pt0  = [x,y,z]     the point where the ray origins
            %       dir0 = [l,m,n]     the direction cosine of the incident ray
            %       


            % P: source
            % Q: point at z =0
            % R: point on the surface (=pt)

            r = self.radius;
            pathPQ = -pt0(3)/dir0(3);  % path from P to Q
            posQ = pt0 + pathPQ.*dir0; % position on the ray at z=0

            % search intersection point R
            if r == Inf
                pathQR = 0;
            else 
                F = @(rho) self.surffunc(posQ + rho.*dir0);
                %dF = @(rho) dot(self.surfgrad(posQ + rho.*dir0),dir0);
                %pathQR = newton_raphson(F,dF,0.0);
                [pathQR] = fsolve(F,0.0);
            end
            pathPR = pathPQ + pathQR; % total path from P to R
            pt = posQ + pathQR.*dir0;
            
        end


        function [dirout,snorm] = refract(self, pt, dirin, nin, nout)
            % refract
            % compute direction cosine after refraction
            %
            % Input
            %       pt      intersection point
            %       dirin   direcsion cosine of the incident ray
            %       nin     refractive index of the input medium
            %       nout    refractive index of the output medium (= index of the surface)

            mu = nin/nout;

            snorm = self.surfnorm(pt); % surface norm

            if mu == 1.0 % pass through
                dirout = dirin;
            else
                %snorm = self.surfnorm(pt); 
                a = mu*( dot(snorm,dirin)/sum(snorm.^2) );
                b = (mu^2-1)/( sum(snorm.^2) );
                f = @(lambda) lambda^2 + 2*a*lambda + b;
                %df = @(lambda) 2*lambda + 2*a;
                %lambda = newton_raphson(f,df,-b/(2*a));
                [lambda] = fsolve(f,-b/(2*a));
                dirout = mu.*dirin + lambda.*snorm;
            end

        end

        %varargout{1} = dirout;
        %varargout{2} = snorm;

    end % method end
end
