function MODEL = build_K_and_forces(MODEL, MATERIAL, SOL)

MODEL.K = zeros( MODEL.ndof, MODEL.ndof );
MODEL.fint = zeros( MODEL.ndof, 1 );

xGauss = MODEL.int_rule.x;
wGauss = MODEL.int_rule.w;
nint_p = length( xGauss );
dim    = MODEL.dim;

for i = 1 : MODEL.nels

    %substtute the 2 with the dimension (either 2 or three)
    Kc_el = zeros( dim * MODEL.eltype, dim * MODEL.eltype );
    Kg_el = zeros( dim * MODEL.eltype, dim * MODEL.eltype );
    fint = zeros( dim * MODEL.eltype, 1 );
    el_nodes = MODEL.elements( i, : );

    switch dim

        case 2

            ELEMENT.XX = [ MODEL.XX( el_nodes, 1 ) MODEL.XX( el_nodes, 2 ) ];
            ELEMENT.xx = [ MODEL.xx( el_nodes, 1 ) MODEL.xx( el_nodes, 2 ) ];
            ELEMENT.formul = MODEL.formul;
            for iG = 1 : nint_p
                for jG = 1 : nint_p
                    xi = xGauss( jG );
                    eta = xGauss( iG );

                    KINEMATICS = get_kinematic_gradients( ELEMENT, xi, eta );

                    ELEMENT = get_C_matrix( ELEMENT, MATERIAL, KINEMATICS );
                    ELEMENT = get_sigma( ELEMENT, MATERIAL, KINEMATICS );

                    [Bc, Bg] = get_B_matrix( KINEMATICS );

                    switch KINEMATICS.formul

                        case 'UL'
                            dOm = wGauss( iG ) * wGauss( jG ) * KINEMATICS.detjxi * ELEMENT.t;

                        case 'TL'
                            dOm = wGauss( iG ) * wGauss( jG ) * KINEMATICS.detJxi * ELEMENT.t;
                    end

                    Kc_el = Kc_el + ( Bc' * ELEMENT.c * Bc ) * dOm;
                    Kg_el = Kg_el + kron( Bg' * ELEMENT.sigma_tens * Bg, eye( dim, dim ) ) * dOm;

                    fint = fint + Bc' * ELEMENT.sigma_voigt * dOm;

                end
            end

        case 3

            ELEMENT.XX = [ MODEL.XX( el_nodes, 1 ), MODEL.XX( el_nodes, 2 ), MODEL.XX( el_nodes, 3 )];
            ELEMENT.xx = [ MODEL.xx( el_nodes, 1 ), MODEL.xx( el_nodes, 2 ), MODEL.xx( el_nodes, 3 )];
            ELEMENT.formul = MODEL.formul;
            
            for iG = 1 : nint_p
                for jG = 1 : nint_p
                    for kG = 1 : nint_p
                        eta = xGauss( iG );
                        xi = xGauss( jG );
                        zi = xGauss( kG );

                        KINEMATICS = get_kinematic_gradients( ELEMENT, xi, eta, zi );
                        ELEMENT = get_C_matrix( ELEMENT, MATERIAL, KINEMATICS );
                        ELEMENT = get_sigma( ELEMENT, MATERIAL, KINEMATICS );

                        [Bc, Bg] = get_B_matrix( KINEMATICS );

                        switch KINEMATICS.formul

                            case 'UL'
                                dOm = wGauss( iG ) * wGauss( jG )  * wGauss( kG )* KINEMATICS.detjxi;

                            case 'TL'
                                dOm = wGauss( iG ) * wGauss( jG )  * wGauss( kG )* KINEMATICS.detJxi;
                        end

                        

                        Kc_el = Kc_el + ( Bc' * ELEMENT.c * Bc ) * dOm;
                        Kg_el = Kg_el + kron( Bg' * ELEMENT.sigma_tens * Bg, eye( dim, dim ) ) * dOm;

                        fint = fint + Bc' * ELEMENT.sigma_voigt * dOm;
                        
                    end
                end
            end

    end

    ptrs = MODEL.ptrs( i, : );
    MODEL.K( ptrs, ptrs ) = MODEL.K( ptrs, ptrs ) + Kc_el + Kg_el;
    MODEL.fint( ptrs, 1 ) = MODEL.fint( ptrs, 1 ) + fint;


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
MODEL.F_cons( constr_dofs, : )      = [];
MODEL.res_cons( constr_dofs, : )    = [];

end
