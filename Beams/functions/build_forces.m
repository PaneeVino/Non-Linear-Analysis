function MODEL = build_forces(MODEL)

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

    f_int_loc = zeros(6, 1);

    for iG = 1 : nint_p

        wG = wGauss(iG);
        xi = xGauss(iG);

        [N1, Nx1] = shape_fun(xi, 1, le);
        [N2, Nx2] = shape_fun(xi, 2, le);
        N = [N1;N2]; Nx = [Nx1;Nx2];

        int_u = el_U*N;
        int_ux = el_U*Nx;

        eps_vec = compute_strains(int_u, int_ux, Nx, el_U, nltype);
        N_load = C * eps_vec;

        B1 = compute_B(N, Nx, int_u, int_ux, 1, nltype);
        B2 = compute_B(N, Nx, int_u, int_ux, 2, nltype);
        Bc = [B1, B2];

        f_int_loc = f_int_loc + Bc.'* N_load * wG * le/2;

    end

    Te    = [T, zeros(3); zeros(3), T];
    f_int = Te.' * f_int_loc;

    Ptrs = MODEL.ptrs(i, :);
    MODEL.fint(Ptrs, 1) = MODEL.fint(Ptrs, 1) + f_int;
    
end

constr_dofs          = MODEL.constr_dofs;
MODEL.fint_cons      = MODEL.fint;
MODEL.Fhat_cons      = MODEL.Fhat;

MODEL.fint_cons( constr_dofs, : )   = [];
MODEL.Fhat_cons( constr_dofs, : )   = [];

end