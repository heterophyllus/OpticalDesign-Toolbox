% doublet.m
%
% Simple example for ray tracing
%
% Reference
%   Kingslake
%
% Note
%   Glasses were changed to comtemporary ones
%

close all;
clear all;

% create optical system
sys = OpticalSystem(); 
sys.description = 'Kingslake doublet';

%                    R       D             N                   Aperture
%sys.addSurface(   Inf,                0.0,  Material(),  2.0 );
sys.addSurface(   1/0.1353271,       1.05,  Material('N-BK7','SCHOTT'),  2.0 );
sys.addSurface(  -1/0.1931098,        0.4,  Material('S-BSM71', 'OHARA'), 2.0 ); 
sys.addSurface(   -1/0.0616427,  11.28584,  Material(),  2 );


% set stop surface
sys.setStop(1);


% set fields
maxAngle = 3.0;
sys.setFieldOfView('Angle', maxAngle.*[0.0,0.7,1.0], {'k','b','g'});

% set wavelength
sys.setWavelength([Spectral.C, Spectral.d, Spectral.F], {'r', 'k', 'b'});
%sys.setWavelength([Spectral.C, Spectral.d, Spectral.e, Spectral.F, Spectral.g], {'r', 'k', 'g', 'c', 'b'});


% set system aperture
sys.setAperture('FNO', 4.0);

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
    disp(r1);

    %{
    r2= raytrace(sys, 0.0, 1.0, f, 2);
    drawRay(sys,r2, sys.field(f).color);hold on;

    r3 = raytrace(sys, 0.0, -1.0, f, 2);
    drawRay(sys,r3, sys.field(f).color);hold on;
    %}

    %fprintf('(%f,%f,%f), aoi= %f\n',r1.x(2),r1.y(2),r1.z(2),  r1.aoi(2));
end
hold off;


% plot transverse ray fan
%fprintf('-----> Draw Transverse Ray Fan...\n');
%transverse(sys, [-0.5 0.5]);

fprintf('-----> Draw Longitudinal Ray Fan...\n');
longitudinal(sys,[-1.0 1.0]);

