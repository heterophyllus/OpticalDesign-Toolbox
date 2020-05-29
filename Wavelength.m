% Wavelength
%
% properties
%     

classdef Wavelength
    properties
        value;
        color = 'b';
    end

    methods
        function self = Wavelength(v= 500,c='b')
            if nargin ~= 0
                self.value = v;
                self.color = c;
            end
        end

        function nm = atnm(self)
            nm = self.value;
        end

        function micron = atmicron(self)
            micron = self.value/1000;
        end
    end
    
end