% extended2.m
% Extended 2 dispersion formula
%
% Input
%       w   wavelength in micron
%       c   dispersion coefs (vector)
%
% Output
%       n   refractive index
%      

function n = extended2(w, c)

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

    n2 = c0 .+ c1.*w.^2 .+ c2.*w.^(-2) .+ c3.*w.^(-4) .+ c4.*w.^(-6) .+ c5.*w.^(-8) .+ c6.*w.^4 .+ c7.*w.^6;
    n = sqrt(n2);
    
end

