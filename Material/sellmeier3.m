% sellmeier3.m
% Sellmeier 3 dispersion formula
%
% Input
%       w   wavelength in micron
%       c   dispersion coefs (vector)
%
% Output
%       n   refractive index


function n = sellmeier3(w, c)

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

    n2 = 1 + c0*w^2/(w^2-c1) + c2*w^2/(w^2-c3) + c4*w^2/(w^2-c5) + c6*w^2/(w^2-c7);
    n = sqrt(n2);

end
