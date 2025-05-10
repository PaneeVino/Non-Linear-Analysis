function [Be, Bg] = compute_B_lin(N, Nx, U, Ux, alpha, beta, nltype)

Nax = Nx(alpha); Nbx = Nx(beta);

switch nltype
    case 'vK'
        Be = [0,       0, 0;
              0, Nax*Nbx, 0;
              0,       0, 0];
        Bg = zeros(3);

    case 'full'
        phi = U(3);
        c = cos(phi); s = sin(phi);
        Na = N(alpha); Nb = N(beta);
        ux = Ux(1); wx = Ux(2);

        g1 = s*wx  -c*(1+ux);
        g2 = -c*wx -s*(1+ux);

        Be = [        0,         0, -s*Nax*Nb;
                      0,         0, -c*Nax*Nb;
              -s*Na*Nbx, -c*Na*Nbx,  g1*Na*Nb];

        Bg = [       0,         0,  c*Nax*Nb;
                     0,         0, -s*Nax*Nb;
              c*Na*Nbx, -s*Na*Nbx,  g2*Na*Nb];

end

end