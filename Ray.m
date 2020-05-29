%% Ray
% Ray trace result container
%
% 
%
% properties
%       position        intersection point at each surface [x1,y1,z1];[x2,y2,z2]...
%       direction       direction cosine after refract [l,m,n]
%

classdef Ray < handle
    properties
        pupilX = 0.0;
        pupilY = 0.0;
        sourcePosition = [0,0,0];  % object
        sourceDirection = [0,0,1];
        positions = [];       % each surface including image plane
        directions = [];
    end

    properties(Dependent)
        x;
        y;
        z;
        l;
        m;
        n;
    end

    methods
        function self = Ray(px=0.0, py=0.0, srcP=[0,0,0], srcD=[0,0,1], p=[0,0,0], d=[0,0,1])
            if nargin ~= 0
                self.pupilX = px;
                self.pupilY = py;
                self.sourcePosition = srcP;  % object
                self.sourceDirection = srcD;
                self.positions = p;       % each surface including image plane
                self.directions = d;
            end
        end

        function disp(self)
            fprintf('Ray parameters:\n');
            fprintf('%2s %12s %12s %12s   %12s %12s %12s\n', 'S', 'x', 'y', 'z', 'l', 'm', 'n');
            for i = 1:size((self.positions),1)
                fprintf('%2d %12f %12f %12f   %12f %12f %12f\n', i, self.x(i), self.y(i), self.z(i), self.l(i), self.m(i), self.n(i));
            end
        end

        function self = reserve(self, nsurf)
            self.positions = zeros(nsurf,3);
            self.directions = zeros(nsurf,3);
        end

        function self = insert(self, atsurf, newPos=[0,0,0], newDir=[0,0,1])
            self.positions(atsurf,:) = newPos;
            self.directions(atsurf,:) = newDir;
        end

        function self = append(self, newPos=[0,0,0], newDir=[0,0,1])
            %fprintf('Call Ray.append\n');
            cur = self.positions;
            self.positions = vertcat(cur,newPos);
            cur = self.directions;
            self.directions= vertcat(cur,newDir);
        end

        function vec = get.x(self)
            vec = self.positions(:,1);
        end

        function vec = get.y(self)
            vec = self.positions(:,2);
        end

        function vec = get.z(self)
            vec = self.positions(:,3);
        end

        function vec = get.l(self)
            vec = self.directions(:,1);
        end

        function vec = get.m(self)
            vec = self.directions(:,2);
        end

        function vec = get.n(self)
            vec = self.directions(:,3);
        end

    end % methods end

end % classdef end