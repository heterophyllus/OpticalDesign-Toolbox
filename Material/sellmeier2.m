% sellmeier2.m
% Sellmeier 2 dispersion formula
%
% Input
%       w   wavelength in micron
%       c   dispersion coefs (vector)
%
% Output
%       n   refractive index


function n = sellmeier2(w, c)

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

    n2 = 1 .+ c0 + c1.*w.^2/(w.^2.-c2) + c3.*w.^2./(w.^2.-c4);
    n = sqrt(n2);

end
