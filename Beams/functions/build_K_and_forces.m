function MODEL = build_K_and_forces(MODEL, SOL)

MODEL.K = zeros( MODEL.ndof, MODEL.ndof );
MODEL.fint = zeros( MODEL.ndof, 1 );

xGauss = MODEL.int_rule.x;
wGauss = MODEL.int_rule.w;
nint_p = length( xGauss );
nltype = MODEL.nltype;

EA = MODEL.EA;
GA = MODEL.GA;
EJ = MODEL.EJ;
C  = diag([EA, GA, EJ]);

for i = 1 : MODEL.nels

    el_nodes = MODEL.elements( i, : );
    XX = [ MODEL.XX( el_nodes, 1 ) MODEL.XX( el_nodes, 2 ) ]; %position of nodes in global system
    el_point = MODEL.ptrs(i, :);
    el_U_glob  = [MODEL.U_dof(el_point(1:3)), MODEL.U_dof(el_point(4:6))]; %displacements associated to the element

    ll_vec = XX(2, :) - XX(1, :);
    le = norm(ll_vec); %length of the element
    theta = atan2(ll_vec(2), ll_vec(1));
    T = [cos(theta), sin(theta), 0;
        -sin(theta), cos(theta), 0;
                  0,          0, 1];
    el_U = T*el_U_glob;

    Kc_el_loc = zeros(6);
    Kg_el_loc = zeros(6);
    f_int_loc = zeros(6, 1);

    for iG = 1 : nint_p

        wG = wGauss(iG);
        xi = xGauss(iG);

        [N1, Nx1] = shape_fun(xi, 1, le);
        [N2, Nx2] = shape_fun(xi, 2, le);
        N = [N1;N2]; Nx = [Nx1;Nx2];

        int_u  = el_U*N;
        int_ux = el_U*Nx;

        eps_vec = compute_strains(int_u, int_ux, Nx, el_U, nltype);
        N_load = C * eps_vec;

        B1 = compute_B(N, Nx, int_u, int_ux, 1, nltype);
        B2 = compute_B(N, Nx, int_u, int_ux, 2, nltype);
        Bc = [B1, B2];

        Kc_el_loc = Kc_el_loc + Bc.'*C*Bc*wG*le/2;

        [Be11, Bg11] = compute_B_lin(N, Nx, int_u, int_ux, 1, 1, nltype);
        [Be12, Bg12] = compute_B_lin(N, Nx, int_u, int_ux, 1, 2, nltype);
        [Be21, Bg21] = compute_B_lin(N, Nx, int_u, int_ux, 2, 1, nltype);
        [Be22, Bg22] = compute_B_lin(N, Nx, int_u, int_ux, 2, 2, nltype);

        Be = [Be11, Be12; Be21, Be22];
        Bg = [Bg11, Bg12; Bg21, Bg22];

        Kg_el_loc = Kg_el_loc + N_load(1)*Be*wG*le/2 + N_load(2)*Bg*wG*le/2;

        f_int_loc = f_int_loc + Bc.'* N_load * wG * le/2;

    end

    K_el_loc = Kc_el_loc + Kg_el_loc;
    Te    = [T, zeros(3); zeros(3), T];
    K_el  = Te.' * K_el_loc * Te;
    f_int = Te.' * f_int_loc;

    Ptrs = MODEL.ptrs(i, :);
    MODEL.K(Ptrs, Ptrs) = MODEL.K(Ptrs, Ptrs) + K_el;
    MODEL.fint(Ptrs, 1) = MODEL.fint(Ptrs, 1) + f_int;
    
end

MODEL.F = SOL.lambda*MODEL.Fhat;
MODEL.res = MODEL.F - MODEL.fint;

constr_dofs          = MODEL.constr_dofs;
MODEL.K_cons         = MODEL.K;
MODEL.fint_cons      = MODEL.fint;
MODEL.Fhat_cons      = MODEL.Fhat;
MODEL.F_cons         = MODEL.F;
MODEL.res_cons       = MODEL.res;


MODEL.K_cons( constr_dofs, : )      = [];
MODEL.K_cons( :, constr_dofs )      = [];
MODEL.fint_cons( constr_dofs, : )   = [];
MODEL.Fhat_cons( constr_dofs, : )   = [];
MODEL.F_cons( constr_dofs, : )   = [];
MODEL.res_cons( constr_dofs, : )   = [];
end