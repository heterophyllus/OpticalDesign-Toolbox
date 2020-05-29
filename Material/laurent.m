% laurent.m
% Laurent dispersion formula (CODE V)
%
% Input
%       w   wavelength in micron
%       c   dispersion coefs (vector)
%
% Output
%       n   refractive index
%      

function n = laurent(w, c)

    c0 = c(1);
    c1 = c(2);
    c2 = c(3);
    c3 = c(4);
    c4 = c(5);
    c5 = c(6);
    c6 = c(7);
    c7 = c(8);
    c8 = c(9);
    c9 = c(10);

    % CODE V
    c10 = 0;
    c11 = 0;
    c12 = 0;

    n2 = c0 .+ c1.*w.^2 .+ c2.*w.^(-2) .+ c3.*w.^(-4) .+ c4.*w.^(-6) .+ c5.*w.^(-8) .+ c6.*w.^(-10) .+ c7.*w.^(-12) .+ c8.*w.^(-14) .+ c9.*w.^(-16) .+ c10.*w.^(-18) .+ c11.*w.^(-20);
    n = sqrt(n2);
    
end

