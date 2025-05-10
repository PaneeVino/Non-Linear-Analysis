function POST = recover_stresses(POST, MODEL, MATERIAL)
% RECOVER_STRESSES calculates the stress components (sigmaxx, sigmayy, sigmaxy)
% at the nodes of the finite elements based on the element displacement 
% and material properties.
%
% Inputs:
%   POST    - Structure containing the displacement results.
%   MODEL   - Structure containing the finite element model (e.g., element connectivity, integration rule).
%   MATERIAL - Structure containing material properties (e.g., Young's modulus, Poisson's ratio).
%
% Outputs:
%   POST    - Structure containing the recovered stress components at the nodes (sigmaxx, sigmayy, sigmaxy).

% --- Integration rule parameters (xGauss defines the integration points in natural coordinates)
xGauss = MODEL.int_rule.x;  % Get integration points from the model's integration rule
nint_p = length(xGauss);    % Number of integration points (should be square, e.g., 2x2 or 3x3)

% Loop over all elements in the model
for i = 1 : MODEL.nels
    % --- Initialize displacement vectors for the current element
    Ux = POST.Ux(i, :);  % Displacement in x-direction
    Uy = POST.Uy(i, :);  % Displacement in y-direction
    U  = nan(2 * length(Ux), 1);  % Initialize a vector to store the total displacement (Ux and Uy combined)

    % Combine Ux and Uy into a single displacement vector
    for k = 1 : length(Ux)
        U(2*k - 1 : 2*k) = [Ux(k); Uy(k)];
    end

    % --- Get the element's node coordinates in physical space
    el_nodes = MODEL.elements(i, :);  % Get the element's node connectivity
    ELEMENT.XY_nodes = [MODEL.X(el_nodes, 1), MODEL.X(el_nodes, 2)];  % Global coordinates of nodes
    ELEMENT.xy_nodes = [MODEL.x(el_nodes, 1), MODEL.x(el_nodes, 2)];  % Material coordinates of nodes

    % --- Initialize matrix for storing stresses at the integration points and coordinates
    sigma_mat  = nan(nint_p^2, 3);  % Stress matrix (3 stress components at each integration point)
    xi_eta_mat = nan(nint_p^2, 2);  % Coordinates matrix for the integration points (xi, eta)
    iter = 0;  % Initialize iteration index for integration points

    % --- Loop over all integration points (xi, eta) in natural coordinates
    for iG = 1 : nint_p
        xi = xGauss(iG);  % Get the xi coordinate of the current integration point

        for jG = 1 : nint_p
            eta = xGauss(jG);  % Get the eta coordinate of the current integration point
            iter = iter + 1;  % Increment iteration index
            xi_eta_mat(iter, :) = [xi, eta];  % Store the current (xi, eta) coordinates

            % --- Get the kinematic gradients (derivatives of the shape functions)
            KINEMATICS = get_kinematic_gradients(ELEMENT, xi, eta);

            % --- Get the elasticity tensor (material properties and stiffness matrix)
            ELEMENT = get_C_matrix(ELEMENT, MATERIAL, KINEMATICS);

            % --- Get the B matrix (strain-displacement matrix)
            B = get_B_matrix(KINEMATICS);

            % --- Calculate and store the stresses at the current integration point
            sigma_mat(iter, :) = (ELEMENT.C * B * U).';  % Stresses at the integration point

        end
    end

    % --- Calculate the nodal stresses based on the integration point stresses
    [sxx, syy, sxy] = nodal_stresses(xi_eta_mat, sigma_mat, nint_p, MODEL);

    % --- Store the recovered stresses in the POST structure
    POST.sigmaxx(:, i)      = sigma_mat(:,1);
    POST.sigmayy(:, i)      = sigma_mat(:,2);
    POST.sigmaxy(:, i)      = sigma_mat(:,3);
    POST.sigmaxx_nod(i, :) = sxx;  % Store the stresses in the x-direction at the nodes
    POST.sigmayy_nod(i, :) = syy;  % Store the stresses in the y-direction at the nodes
    POST.sigmaxy_nod(i, :) = sxy;  % Store the shear stresses at the nodes

end

end
