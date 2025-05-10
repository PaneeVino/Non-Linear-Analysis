function eps_vec = compute_strains(U, Ux, Nx, el_U, nltype)

phi = U(3);

switch nltype

    case 'vK'
        ux = Ux(1);
        wx = Ux(2);
        phix = Ux(3);
        
        eps_vec = [ux+0.5*wx^2; wx+phi; phix];
    case 'full'

        c = cos(phi); s = sin(phi);
        alpha_trans = [  c, -s, 0;
            s,  c, 0;
            0,  0, 1];

        eps_vec = (alpha_trans - eye(3))*[1; 0; 0];
        for a = 1 : 2
            Nax = Nx(a);
            ua = el_U(:, a);
            
            eps_vec = eps_vec + alpha_trans*Nax*ua;
        end

end

end