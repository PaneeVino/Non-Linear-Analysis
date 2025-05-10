function B = compute_B(N, Nx, U, Ux, alpha, nltype)

phi = U(3);
c = cos(phi); s = sin(phi);
Na = N(alpha); Nax = Nx(alpha);
ux = Ux(1); wx = Ux(2);

switch nltype
    case 'vK'
        B = [Nax, wx*Nax,    0;
             0,      Nax,   Na;
             0,        0,  Nax];

    case 'full'
        B = [c*Nax, -s*Nax, (-c*wx -s*(1+ux))*Na;
             s*Nax,  c*Nax, (-s*wx +c*(1+ux))*Na;
                 0,      0,                  Nax];
end

end