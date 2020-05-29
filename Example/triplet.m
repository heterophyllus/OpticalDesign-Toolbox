% triplet.m
%
% Simple example for ray tracing
%
% Joseph M.Geary, Lens Deign with Practical Zemax Examples, p50, Fig.5.17
% (slightly modified)
%

close all;
clear all;


% create optical system
sys = OpticalSystem(); 


%               R                D             N                     Ap
sys.addSurface( 1/0.024426,   8.74,  Material('N-SSK8','SCHOTT'),  20.0 );
sys.addSurface( Inf,         11.05,  Material(),                   20.0 );
sys.addSurface( -1/0.017969,  2.78,  Material('N-SF2','SCHOTT'),   20.0 );
sys.addSurface( 1/0.025157,    2.0,  Material(),                   20.0 ); 
sys.addSurface( Inf,          5.63,  Material(),                   10.0 ); 
sys.addSurface( 1/0.009297,   9.54,  Material('N-SSK8','SCHOTT'),  20.0 );
sys.addSurface( -1/0.023079,  78.702, Material(),                  20.0 );


%{
    Here, the system would be;
                 R            D            N
    O          Inf         Inf
    1(S)       Inf     0.000000     1.000000
    2    40.939982     8.740000     1.617730
    3          Inf    11.050000     1.000000
    4   -55.651400     2.780000     1.647690
    5    39.750368     2.000000     1.000000
    6          Inf     5.630000     1.000000
    7   107.561579     9.540000     1.617730
    8   -43.329434    78.702000     1.000000
    I
%}

% set stop surface
sys.setStop(6);


% set field
maxAngle = 14.0;
sys.setFieldOfView('Angle', maxAngle.*[0.0,0.7,1.0], {'k','b','g'});


% set wavelength
sys.setWavelength([Spectral.C, Spectral.d, Spectral.F], {'r', 'k', 'b'});


% set system aperture
fno = 3.741121;
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


