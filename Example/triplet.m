% triplet.m
%
% Simple example for ray tracing
%
% Warren Smith, Modern Lens Design, p214
% (slightly modified)
%

close all;
clear all;


% create optical system
sys = OpticalSystem(); 
sys.description = '16degHFOV TRIPLET';

%               R                D             N                     Ap
sys.addSurface( 35.670,    8.000,  Material('N-SK4','SCHOTT'),  20.0 );
sys.addSurface( 675.100,  11.900,  Material(),                  20.0 );
sys.addSurface( Inf,       0.000,  Material(),                  15.7 );
sys.addSurface( -61.660,   1.600,  Material('N-SF2','SCHOTT'),  15.7 );
sys.addSurface( 32.570,   12.500,  Material(),                  15.7 ); 
sys.addSurface( 98.520,    7.000,  Material('N-SK4','SCHOTT'),  18.0 ); 
sys.addSurface( -45.500,  78.183,  Material(),                  18.0 );


% set stop surface
sys.setStop(4);


% set field
maxAngle = 16.01;
sys.setFieldOfView('Angle', maxAngle.*[0.0,0.7,1.0], {'k','b','g'});


% set wavelength
sys.setWavelength([Spectral.C, Spectral.d, Spectral.e, Spectral.F, Spectral.g, Spectral.h], {'r', 'k', 'g', 'c', 'b', 'm'});


% set system aperture
fno = 2.5;
sys.setAperture('FNO', fno);

% set vignetting
sys.setVignetting();

% display system
fprintf('-----> Display System Data...\n');
disp(sys);


% draw layout
fprintf('-----> Draw System Layout...\n');
drawLayout(sys);
hold on;

fprintf('-----> Draw Rays...\n');
for f = 1 : sys.fieldCount
    [r2] = raytrace(sys, 0.0, 1.0, f, 2);
    drawRay(sys,r2, sys.field(f).color);hold on;

    [r3] = raytrace(sys, 0.0, -1.0, f, 2);
    drawRay(sys,r3, sys.field(f).color);hold on;
end
hold off;


% plot ray fan
fprintf('-----> Draw Transverse Ray Fan...\n');
transverse(sys, [-0.2 0.2]);


fprintf('-----> Draw Longitudinal Ray Fan...\n');
longitudinal(sys,[-2.0 2.0],[-1 1]);
