% ernostar.m
%
% Simple example for ray tracing
%
% Reference
%   Warren J. Smith, Modern Lens Design, p251
%
% Note
%   Glasses were changed to comtemporary ones
%

close all;
clear all;

% create optical system
sys = OpticalSystem(); 
sys.description = 'F/2 15degHFOV SPLIT FR CROWN TRIPLET EP 237,212/1925';

%                    R       D             N                   Aperture
sys.addSurface(   51.00,  8.80,  Material('N-SK11','SCHOTT'),  25.0 );
sys.addSurface( -441.00,  0.03,  Material(),                   25.0 ); % Air
sys.addSurface(   35.30,  7.80,  Material('N-SK11','SCHOTT'),  22.0 );
sys.addSurface(   47.80,  8.40,  Material(),                   20.0 ); 
sys.addSurface( -254.80,  2.00,  Material('N-SF2','SCHOTT'),   18.0 );
sys.addSurface(   28.30, 10.00,  Material(),                   16.0 );
sys.addSurface(     Inf, 19.40,  Material(),                   15.7 ); 
sys.addSurface(  107.80,  4.90,  Material('N-SK11','SCHOTT'),  16.0 );
sys.addSurface(  -60.30, 56.887, Material(),                   16.0 );


% set stop surface
sys.setStop(8);


% set fields
maxAngle = 15.11;
sys.setFieldOfView('Angle', maxAngle.*[0.0,0.7,1.0], {'k','b','g'});

% set wavelength
sys.setWavelength([Spectral.C, Spectral.d, Spectral.F], {'r', 'k', 'b'});

% set system aperture
sys.setAperture('FNO', 2.0);


% set vignetting
sys.setVignetting();


% display system data
fprintf('-----> Display System Data...\n');
disp(sys);


% draw layout
fprintf('-----> Draw System Layout...\n');
drawLayout(sys);
hold on;

% overlay reference rays on the layout
fprintf('-----> Draw Rays...\n');
for f = 1 : sys.fieldCount
    r1 = raytrace(sys, 0.0, 0.0, f, 2);
    drawRay(sys,r1, sys.field(f).color);hold on;

    r2= raytrace(sys, 0.0, 1.0, f, 2);
    drawRay(sys,r2, sys.field(f).color);hold on;

    r3 = raytrace(sys, 0.0, -1.0, f, 2);
    drawRay(sys,r3, sys.field(f).color);hold on;
end
hold off;


% plot transverse ray fan
fprintf('-----> Draw Transverse Ray Fan...\n');
transverse(sys, [-0.5 0.5]);

