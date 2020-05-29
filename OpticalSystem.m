% OpticalSystem.m
% Fundamental class for optical system
%
% properties
%   object          object plane
%   surfaceList     inner surfaces
%   imagePlane      image plane
%   stop            stop surface
%       


classdef OpticalSystem < handle
    properties
        stop;
        aperture;
        fov;
        wvl;
        description='New Lens';    
    end

    properties(private)
        object = Surface;
        surfaceList = Surface;
        imagePlane = Surface;
    end

    properties (GetAccess= public, SetAccess= protected)
        % entrance pupil
        pupil;
    end

    properties (Dependent)
        surfaceCount;
        fieldCount;
        wavelengthCount; 

        efl;
        fno;
    end

    methods
        function self = OpticalSystem()
            % constructor
            %
            if nargin == 0
                self.surfaceList(1) = Surface();
                self.stop = 1;

                self.aperture.type = 'FNO';
                self.aperture.value = 3.0;
                %self.setAperture('FNO', 3);

                self.fov.type ='Angle';
                self.fov.data = Field;

                self.wvl.data = [Spectral.C, Spectral.d, Spectral.F];
                self.wvl.color = {'r','k', 'c'};
                self.wvl.primary = 2;
            end
        end

        function val = get.surfaceCount(self)
            val = size(self.surfaceList,1);
        end

        function val = get.fieldCount(self)
            val = size(self.fov.data,2);
        end

        function val = get.wavelengthCount(self)
            val = size(self.wvl.data,2);
        end

        function val = get.efl(self)
            abcd = self.ABCD(1, self.surfaceCount);
            val = -1/abcd(1,2);
        end

        function val = get.fno(self)
            val = self.efl/self.pupil.diameter;
        end

        
        function disp(self)
            % disp
            % Display system data 
            % override function of 'disp'
            %
            fprintf('Description: %s\n', self.description);
            fprintf('Focal Length: %f\n', self.efl);
            fprintf('Entrance Pupil Diameter: %f\n', self.pupil.diameter);
            fprintf('Entrance Pupil Distance: %f\n', self.pupil.distance);
            fprintf('F/# : %f\n', self.fno);

            fprintf('---\n');
            fprintf('System Configuration\n');
            fprintf('Field of View : %s\n', self.fov.type);
            for i = 1:self.fieldCount
                fprintf('   F%d : %f %f\n',i, self.field(i).x, self.field(i).y);
            end
            fprintf('Wavelength\n');
            for i = 1: self.wavelengthCount
                fprintf('   W%d : %f\n', i, self.wvl.data(i));
            end

            fprintf('---\n');
            fprintf('System Data:\n');
            fprintf('%2s %12s %12s %12s\n', 'S', 'R', 'D', 'N');
            for i = 1:size(self.surfaceList)
                s = self.surfaceList(i);
                fprintf('%2d %12f %12f %12f\n',i, s.radius, s.distance, s.material.nd);
            end
        end


        function s = surface(self, n=1)
            %
            % surface aliase
            %
            if n < 1
                s = self.object;
            elseif n > self.surfaceCount
                s = self.imagePlane;
            else
                s = self.surfaceList(n);
            end
        end

        function f = field(self, n=1)
            %
            % field aliase
            %
            f = self.fov.data(n);
        end

        function self = addSurface(self, r= Inf, d= 0.0, m= Material(), ap= Inf)
            s = Surface(r,d,m,ap);
            row = size(self.surfaceList,1);
            self.surfaceList(row+1,1) = s;
        end

        
        function self = setFieldOfView(self, fldType= 'Angle', flds= [], colors=[])
            self.fov.type = fldType;
            for i=1:size(flds,2)
                self.fov.data(i).y = flds(i);
                self.fov.data(i).chiefRayDirection = [0, sin(deg2rad(flds(i))), cos(deg2rad(flds(i)))];
                self.fov.data(i).color = colors{i};
            end
        end

        function self = setWavelength(self, wvls=[], colors={}, primary=2)
            self.wvl.data = wvls;
            self.wvl.color = colors;
            self.wvl.primary = 2;
        end

        function self = setAperture(self, apeType = 'FNO', val = 2.0)
            
            self.aperture.type = apeType;
            self.aperture.value = val;

            if apeType == 'FNO'
                abcd = self.ABCD(1, self.surfaceCount);
                efl = -1/abcd(1,2);
                self.pupil.diameter = efl/self.aperture.value;
            elseif apeType == 'EPD'
                self.pupil.diameter = val;
            %else if apeType == 'STO'
                % set aperture to stop surface
            end

            % update pupil position
            if self.stop == 1
                self.pupil.distance = 0;
            else
                abcd = self.ABCD(1,self.stop);

                % [nu; y] at first surface
                nuy1 = inv(abcd)*[-1;0];
                self.pupil.distance = -nuy1(2)/nuy1(1);
            end
        end

        function self = setStop(self, nsto=1)
            self.stop = nsto;
        end

        function self = setVignetting(self)
            %
            % set vignetting factor
            %
            % Not confident on this implementation, shoul search references
            %
            eps = 0.01;
    
            for f = 1:self.fieldCount

                % reset
                self.fov.data(f).vdy = 0;
                self.fov.data(f).vcy = 0;
                self.fov.data(f).vdx = 0;
                self.fov.data(f).vcx = 0;

                % upper marginal
                k = 0;
                pa = 0.0;
                pb = 1.0;
                while 1
                    k = k+1;
                    pm = (pb+pa)/2;
                    [r,pass] = raytrace(self,0.0,pm,f,2);
                    if pass
                        pa = pm;
                    else
                        pb = pm;
                    end

                    if or((pb-pa) < eps, k > 20)
                        break;
                    end
                end
                yum = (pb+pa)/2;

                % lower marginal
                k = 0;
                pa = 0.0;
                pb = -1.0;
                while 1
                    k = k+1;
                    pm = (pb+pa)/2;
                    [r,pass] = raytrace(self,0.0,pm,f,2);
                    if pass
                        pa = pm;
                    else
                        pb = pm;
                    end

                    if or((pa-pb) < eps, k > 20)
                        break;
                    end
                end
                ylm = (pb+pa)/2;

                self.fov.data(f).vdy = (yum+ylm)/2;
                self.fov.data(f).vcy = 1-(yum-ylm)/2; 


                % sagittal
                % upper marginal
                k = 0;
                pa = 0.0;
                pb = 1.0;
                while 1
                    k = k+1;
                    pm = (pb+pa)/2;
                    [r,pass] = raytrace(self,pm,0.0,f,2);
                    if pass
                        pa = pm;
                    else
                        pb = pm;
                    end

                    if or((pb-pa) < eps, k > 20)
                        break;
                    end
                end
                xum = (pb+pa)/2;

                % lower marginal
                k = 0;
                pa = 0.0;
                pb = -1.0;
                while 1
                    k = k+1;
                    pm = (pb+pa)/2;
                    [r,pass] = raytrace(self,pm,0.0,f,2);
                    if pass
                        pa = pm;
                    else
                        pb = pm;
                    end

                    if or((pa-pb) < eps, k > 20)
                        break;
                    end
                end
                xlm = (pb+pa)/2;

                self.fov.data(f).vdx = (xum+xlm)/2;
                self.fov.data(f).vcx = 1-(xum-xlm)/2; 

            end
        end

        function M = ABCD(self, s1, s2)
            %
            % calculate ABCD matrix
            %
            % Usage
            %   T = ABCD(s1,s2)
            %
            % Input
            %   s1  start surface number
            %   s2  end surface number
            %   

            if s1 == s2
                M = eye(2);
            else
                wvlmicron = self.wvl.data(self.wvl.primary)/1000;
                M = eye(2);

                k = s2;
                c    = self.surface(k).curvature;
                t    = self.surface(k).distance;
                nin  = self.surface(k-1).material.index(wvlmicron);
                nout = self.surface(k).material.index(wvlmicron);
                phi  = (nout - nin)*c;
                RefM = [1 -phi;0 1];
                M = RefM*M;

                for k = (s2-1):-1:s1
                    c    = self.surface(k).curvature;
                    t    = self.surface(k).distance;
                    nin  = self.surface(k-1).material.index(wvlmicron);
                    nout = self.surface(k).material.index(wvlmicron);
                    phi  = (nout - nin)*c;

                    % refract at i
                    RefM = [1 -phi; 0 1];

                    % transfer from (i-1) to i
                    TrnsM = [1 0; t/nout 1];

                    M = M*TrnsM * RefM;

                end
            end % end if

        end

        function oal = track(self, s1, s2)
            % track
            % Return on-axis length from s1 to s2
            %
            oal = 0;
            if s1 < s2
                for i =  s1:s2-1
                    oal = oal + self.surface(i).distance;
                end
            end 
        end

    end % end methods

end % end class


