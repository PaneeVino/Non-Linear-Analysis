function MODEL = build_forces(MODEL, MATERIAL, SOL)

MODEL.fint = zeros( MODEL.ndof, 1 );

xGauss = MODEL.int_rule.x;
wGauss = MODEL.int_rule.w;
nint_p = length( xGauss );
dim    = MODEL.dim;

for i = 1 : MODEL.nels

    %substtute the 2 with the dimension (either 2 or three)
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

                    [Bc, ~] = get_B_matrix( KINEMATICS );

                    switch KINEMATICS.formul

                        case 'UL'
                            dOm = wGauss( iG ) * wGauss( jG ) * KINEMATICS.detjxi * ELEMENT.t;

                        case 'TL'
                            dOm = wGauss( iG ) * wGauss( jG ) * KINEMATICS.detJxi * ELEMENT.t;
                    end

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
                        xi = xGauss( jG );
                        eta = xGauss( iG );
                        zi = xGauss( kG );

                        KINEMATICS = get_kinematic_gradients( ELEMENT, xi, eta, zi );

                        ELEMENT = get_C_matrix( ELEMENT, MATERIAL, KINEMATICS );
                        ELEMENT = get_sigma( ELEMENT, MATERIAL, KINEMATICS );

                        [Bc, ~] = get_B_matrix( KINEMATICS );

                        switch KINEMATICS.formul

                            case 'UL'
                                dOm = wGauss( iG ) * wGauss( jG )  * wGauss( kG )* KINEMATICS.detjxi;

                            case 'TL'
                                dOm = wGauss( iG ) * wGauss( jG )  * wGauss( kG )* KINEMATICS.detJxi;
                        end

                        fint = fint + Bc' * ELEMENT.sigma_voigt * dOm;
                        
                    end
                end
            end

    end

    ptrs = MODEL.ptrs( i, : );
    MODEL.fint( ptrs, 1 ) = MODEL.fint( ptrs, 1 ) + fint;

end

constr_dofs          = MODEL.constr_dofs;
MODEL.fint_cons      = MODEL.fint;
MODEL.Fhat_cons      = MODEL.Fhat;

MODEL.fint_cons( constr_dofs, : )   = [];
MODEL.Fhat_cons( constr_dofs, : )   = [];

MODEL.F_cons = SOL.lambda*MODEL.Fhat_cons;
MODEL.res_cons = MODEL.F_cons - MODEL.fint_cons;

end