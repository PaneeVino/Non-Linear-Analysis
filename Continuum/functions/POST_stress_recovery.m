function POST = POST_stress_recovery( POST, MODEL, MATERIAL, SOL )

dim = MODEL.dim;
nincr = SOL.nincr;
xGauss = MODEL.int_rule.x;  % Get integration points from the model's integration rule
nint_p = length(xGauss);    % Number of integration points (should be square, e.g., 2x2 or 3x3)

% Loop over all elements in the model
for i = 1 : MODEL.nels
    % --- Initialize displacement vectors for the current element
    Ux = POST.STEP(nincr).Ux(i, :);  % Displacement in x-direction
    Uy = POST.STEP(nincr).Uy(i, :);  % Displacement in y-direction
    if dim == 3
        Uz = POST.STEP(nincr).Uz(i, :);  % Displacement in z-direction
    end
    U  = nan(dim * length(Ux), 1);  % Initialize a vector to store the total displacement (Ux and Uy combined)

    % Combine Ux and Uy into a single displacement vector
    for k = 1 : length(Ux)
        if dim == 2
            U(2*k - 1 : 2*k) = [Ux(k); Uy(k)];
        elseif dim == 3
            U(3*k - 2 : 3*k) = [Ux(k); Uy(k); Uz(k)];
        end
    end

    % --- Get the element's node coordinates in physical space
    el_nodes = MODEL.elements(i, :);  % Get the element's node connectivity
    switch dim
        case 2
            ELEMENT.XX = [MODEL.XX(el_nodes, 1), MODEL.XX(el_nodes, 2)];  % Global coordinates of nodes
            ELEMENT.xx = [MODEL.xx(el_nodes, 1), MODEL.xx(el_nodes, 2)];  % Material coordinates of nodes
        case 3
            ELEMENT.XX = [MODEL.XX(el_nodes, 1), MODEL.XX(el_nodes, 2), MODEL.XX(el_nodes, 3)];  % Global coordinates of nodes
            ELEMENT.xx = [MODEL.xx(el_nodes, 1), MODEL.xx(el_nodes, 2), MODEL.xx(el_nodes, 3)];  % Material coordinates of nodes
    end

    ELEMENT.formul = MODEL.formul;

    % --- Initialize matrix for storing stresses at the integration points and coordinates
    n = dim*(dim+1)/2;
    sigma_mat  = nan(nint_p^dim, n);  % Stress matrix (3 stress components at each integration point)
    xi_eta_mat = nan(nint_p^dim, dim);  % Coordinates matrix for the integration points (xi, eta)
    iter = 0;  % Initialize iteration index for integration points

    switch dim
        case 2
            % --- Loop over all integration points (xi, eta) in natural coordinates
            for iG = 1 : nint_p
                xi = xGauss(iG);  % Get the xi coordinate of the current integration point

                for jG = 1 : nint_p
                    eta = xGauss(jG);  % Get the eta coordinate of the current integration point
                    iter = iter + 1;  % Increment iteration index
                    xi_eta_mat(iter, :) = [xi, eta];  % Store the current (xi, eta) coordinates

                    % --- Get the kinematic gradients (derivatives of the shape functions)
                    KINEMATICS = get_kinematic_gradients(ELEMENT, xi, eta);

                    switch SOL.type

                        case 'linear'

                            % --- Get the elasticity tensor (material properties and stiffness matrix)
                            ELEMENT = get_C_matrix(ELEMENT, MATERIAL, KINEMATICS);

                            % --- Get the B matrix (strain-displacement matrix)
                            [Bc, ~] = get_B_matrix( KINEMATICS );

                            % --- Calculate and store the stresses at the current integration point
                            sigma_mat(iter, :) = (ELEMENT.c * Bc * U).';  % Stresses at the integration point

                        case 'nonlinear'

                            % --- Get the elasticity tensor (material properties and stiffness matrix)
                            ELEMENT = get_C_matrix(ELEMENT, MATERIAL, KINEMATICS);
                            ELEMENT = get_sigma(ELEMENT, MATERIAL, KINEMATICS);

                            % --- Calculate and store the stresses at the current integration point
                            sigma_mat(iter, :) = ELEMENT.sigma_voigt;  % Stresses at the integration point

                    end

                end
            end
            % --- Calculate the nodal stresses based on the integration point stresses
            s = nodal_stresses(xi_eta_mat, sigma_mat, nint_p, MODEL);

            % --- Store the recovered stresses in the POST structure
            POST.STEP(nincr).sigmaxx(:, i)      = sigma_mat(:,1);
            POST.STEP(nincr).sigmayy(:, i)      = sigma_mat(:,2);
            POST.STEP(nincr).sigmaxy(:, i)      = sigma_mat(:,3);
            POST.STEP(nincr).sigmaxx_nod(i, :)  = s(1, :);  % Store the stresses in the x-direction at the nodes
            POST.STEP(nincr).sigmayy_nod(i, :)  = s(2, :);  % Store the stresses in the y-direction at the nodes
            POST.STEP(nincr).sigmaxy_nod(i, :)  = s(3, :);  % Store the shear stresses at the nodes
            POST.STEP(nincr).sigmavm_nod(i, :)  = s(4, :);  % Store the Von Mises stresses at the nodes
        case 3
                        % --- Loop over all integration points (xi, eta, zi) in natural coordinates
            for iG = 1 : nint_p
                xi = xGauss(iG);  % Get the xi coordinate of the current integration point

                for jG = 1 : nint_p
                    eta = xGauss(jG);
                    for kG = 1 : nint_p
                        zi = xGauss(kG);
                        iter = iter + 1;  % Increment iteration index
                        xi_eta_mat(iter, :) = [xi, eta, zi];  % Store the current (xi, eta) coordinates
                        % --- Get the kinematic gradients (derivatives of the shape functions)
                        KINEMATICS = get_kinematic_gradients(ELEMENT, xi, eta, zi);
                        switch SOL.type

                            case 'linear'

                                % --- Get the elasticity tensor (material properties and stiffness matrix)
                                ELEMENT = get_C_matrix(ELEMENT, MATERIAL, KINEMATICS);

                                % --- Get the B matrix (strain-displacement matrix)
                                [Bc, ~] = get_B_matrix( KINEMATICS );

                                % --- Calculate and store the stresses at the current integration point
                                sigma_mat(iter, :) = (ELEMENT.c * Bc * U).';  % Stresses at the integration point

                            case 'nonlinear'

                                % --- Get the elasticity tensor (material properties and stiffness matrix)
                                ELEMENT = get_C_matrix(ELEMENT, MATERIAL, KINEMATICS);
                                ELEMENT = get_sigma(ELEMENT, MATERIAL, KINEMATICS);

                                % --- Calculate and store the stresses at the current integration point
                                sigma_mat(iter, :) = ELEMENT.sigma_voigt;  % Stresses at the integration point

                        end

                    end
                end
            end
            s = nodal_stresses(xi_eta_mat, sigma_mat, nint_p, MODEL);

            % --- Store the recovered stresses in the POST structure
            POST.STEP(nincr).sigmaxx(:, i)      = sigma_mat(:,1);
            POST.STEP(nincr).sigmayy(:, i)      = sigma_mat(:,2);
            POST.STEP(nincr).sigmazz(:, i)      = sigma_mat(:,3);
            POST.STEP(nincr).sigmayz(:, i)      = sigma_mat(:,4);
            POST.STEP(nincr).sigmaxz(:, i)      = sigma_mat(:,5);
            POST.STEP(nincr).sigmaxy(:, i)      = sigma_mat(:,6);
            POST.STEP(nincr).sigmaxx_nod(i, :)  = s(1, :);  % Store the stresses in the x-direction at the nodes
            POST.STEP(nincr).sigmayy_nod(i, :)  = s(2, :);  % Store the stresses in the y-direction at the nodes
            POST.STEP(nincr).sigmazz_nod(i, :)  = s(3, :);  % Store the stresses in the z-direction at the nodes
            POST.STEP(nincr).sigmayz_nod(i, :)  = s(4, :);  % Store the shear stresses at the nodes
            POST.STEP(nincr).sigmaxz_nod(i, :)  = s(5, :);  % Store the shear stresses at the nodes
            POST.STEP(nincr).sigmaxy_nod(i, :)  = s(6, :);  % Store the shear stresses at the nodes
            POST.STEP(nincr).sigmavm_nod(i, :)  = s(7, :);  % Store the Von Mises stresses at the nodes
    end

end

end