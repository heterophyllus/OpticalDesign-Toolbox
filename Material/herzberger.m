% herzberger.m
% Herzberger dispersion formula
%
% Input
%       w   wavelength in micron
%       c   dispersion coefs (vector)
%
% Output
%       n   refractive index

function herzberger(w, c)

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

    L = 1./(w.^2-0.028);

    n = c0 .+ c1.*L .+ c2.*L.^2 .+ c3.*w.^2 .+ c4.*w.^4 .+ c5.*w.^6;

end