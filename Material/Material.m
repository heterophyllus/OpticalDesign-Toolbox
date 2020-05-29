%% Material
% Material class
%
% Container class for optical material
%
% properties
%       nd
%       vd
%       name
%       database
%       dispersionFormNum
%       dispersionFormCoefs
%
% Author : Hiiragi <heterophyllus.work@gmail.com>
% Date   : May 11, 2020


classdef Material < handle

    properties
        database = 'Base';
        nd = 1.0;
        name = "Air";
        dispersionFormNum = 1;
        dispersionCoefs;
    end

    properties (Dependent)
        vd;
        dispersionFormName;
    end

    methods
        function self = Material(name='', catalog='')
            % Material.Material
            % Material object constructor
            %

            if nargin == 0
                self.database = 'Base';
                self.nd = 1.0;
                self.name = "Air";
                self.dispersionFormNum = 1;
                self.dispersionCoefs = zeros(10,1);
                self.dispersionCoefs(1) = 1.0;
            else
                self = self.getGlassFromMat(name, catalog);
            end
        end

        function val = get.vd(self)
            % Abbe number
            nC = self.index(Spectral.C/1000);
            nF = self.index(Spectral.F/1000);
            nd = self.index(Spectral.d/1000);

            val = (nd-1)/(nF-nC);
        end

        function disp(self)
            % disp  display the property values
            %   disp(m)
            %   m.disp()
            %
            % Note::
            %   - Overrided function of 'disp'

            fprintf('Material\n');
            fprintf('name: %s   database: %s\n', self.name, self.database);
            fprintf('nd= %f\n',self.nd);
            fprintf('vd= %f\n', self.vd);
            fprintf('Dispersion : %d\n', self.dispersionFormNum);
            for i = 1:size(self.dispersionCoefs)
                fprintf('C%d = %f\n', (i-1), self.dispersionCoefs(i));
            end
        end

        function self = getGlassFromMat(self,glassName, matFilePath)
            % getGlassFromMat   search material properties from .mat and create Material object
            %       m = getGlassFromMat('N-BK7', 'SCHOTT')
            % Note::
            %       .mat file need to be created in advance
            %

            [matFolder, matName, matExt] = fileparts(matFilePath);
            if strcmp(matExt, '')
                matFilePath = strcat(matName,'.mat');
            end
            self.database = matName;
            warning off;
            load (matFilePath);
            warning on;
            for i = 1:size(glasses)
                if strcmp(glasses(i).name,glassName)
                    %fprintf('Found: %s\n',glasses(i).name);
                    self.name = glasses(i).name;
                    self.nd = glasses(i).nd;
                    %self.vd = glasses(i).vd;
                    self.dispersionFormNum = glasses(i).dispersionFormNum;
                    self.dispersionCoefs = glasses(i).dispersionCoefs;
                    break;
                end
            end
        end

        
        function n = index(self, wvl)
            % index
            % calculate refractive index using dispersion formula
            %
            % n = index(wvl)
            %
            % Input
            %       wvl     wavelength in micron
            %
            % Output
            %       n       refractive index
            %
            
            switch self.dispersionFormNum
                case 1
                    n = schott(wvl,self.dispersionCoefs);
                case 2
                    n = sellmeier1(wvl,self.dispersionCoefs);
                case 3
                    n = herzberger(wvl,self.dispersionCoefs);
                case 4
                    n = sellmeier2(wvl,self.dispersionCoefs);
                case 5
                    n = conrady(wvl,self.dispersionCoefs);
                case 6
                    n = sellmeier3(wvl,self.dispersionCoefs);
                case 7
                    n = handbookofoptics1(wvl,self.dispersionCoefs);
                case 8
                    n = handbookofoptics2(wvl,self.dispersionCoefs);
                case 9
                    n = sellmeier4(wvl,self.dispersionCoefs);
                case 10
                    n = extended1(wvl,self.dispersionCoefs);
                case 11
                    n = sellmeier5(wvl,self.dispersionCoefs);
                case 12
                    n = extended2(wvl,self.dispersionCoefs);
                otherwise % unknown
                    n = 0;
            end
        end

        
    end
    
end
