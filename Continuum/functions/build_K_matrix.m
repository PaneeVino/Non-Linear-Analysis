function MODEL = build_K_matrix(MODEL, MATERIAL)
% BUILD_K_MATRIX assembles the global stiffness matrix (K) for the finite element model.
%
% This function calculates the stiffness matrix for each element by performing numerical integration 
% over the element's domain. The element stiffness matrices are then assembled into the global stiffness matrix.
% It also handles the imposition of boundary conditions and constraints on the system.
%
% Inputs:
%   MODEL - Structure containing the finite element model data:
%       - MODEL.int_rule.x: Gauss quadrature points (for numerical integration).
%       - MODEL.int_rule.w: Gauss quadrature weights (for numerical integration).
%       - MODEL.nels: Number of elements.
%       - MODEL.elements: Connectivity matrix of elements.
%       - MODEL.X, MODEL.x: Initial and deformed nodal coordinates.
%       - MODEL.eltype: The number of nodes per element.
%       - MODEL.ptrs: Assembly pointers for mapping local element degrees of freedom to global DOFs.
%       - MODEL.K: Global stiffness matrix (to be updated).
%
%   MATERIAL - Structure containing material properties:
%       - MATERIAL: Material properties such as Young’s modulus and Poisson’s ratio.
%
% Outputs:
%   MODEL - Updated structure with the global stiffness matrix (MODEL.K) and residuals:
%       - MODEL.K: Updated global stiffness matrix.
%       - MODEL.res: Residual vector for the system (external forces - internal forces).
%       - MODEL.K_cons: Global stiffness matrix including constraints (before applying boundary conditions).
%       - MODEL.F_cons: Global force vector including constraints.
%       - MODEL.res_cons: Residual vector including constraints.

% --- Integration rule parameters
xGauss = MODEL.int_rule.x; % Gauss quadrature points (for numerical integration)
wGauss = MODEL.int_rule.w; % Gauss quadrature weights (for numerical integration)
nint_p = length(xGauss);   % Number of integration points (quadrature)

% Loop over each element to compute its contribution to the global stiffness matrix
for i = 1 : MODEL.nels
    % --- Initialize local element stiffness matrix (Kc_el)
    Kc_el = zeros(2 * MODEL.eltype, 2 * MODEL.eltype); % Local stiffness matrix for element i

    % --- Get nodal coordinates for the element (spatial and deformed positions)
    el_nodes = MODEL.elements(i, :); % Get the node indices for element i
    ELEMENT.XX = [MODEL.XX(el_nodes, 1), MODEL.XX(el_nodes, 2)]; % Initial nodal coordinates (undeformed)
    ELEMENT.xx = [MODEL.xx(el_nodes, 1), MODEL.xx(el_nodes, 2)]; % Current nodal coordinates (deformed)
    ELEMENT.formul = MODEL.formul;
    % --- Perform numerical integration over the element
    for iG = 1 : nint_p
        eta = xGauss(iG); % Gauss point in the eta-direction (2D integration)

        for jG = 1 : nint_p
            xi = xGauss(jG); % Gauss point in the xi-direction (2D integration)

            % --- Get kinematic gradients for the current Gauss point
            KINEMATICS = get_kinematic_gradients(ELEMENT, xi, eta);

            % --- Get the elasticity tensor (C matrix) for the element based on material properties
            ELEMENT = get_C_matrix(ELEMENT, MATERIAL, KINEMATICS);

            % --- Compute the B matrix, which is related to strain-displacement relations
            B = get_B_matrix(KINEMATICS);

            % --- Compute the coefficient for integration in the element's computational domain
            dOm = wGauss(iG) * wGauss(jG) * KINEMATICS.detjxi * ELEMENT.t;

            % --- Update the element stiffness matrix with the current integration point's contribution
            Kc_el = Kc_el + (B' * ELEMENT.c * B) * dOm;
        end
    end

    % --- Assembly: Place the local element stiffness matrix into the global stiffness matrix
    ptrs = MODEL.ptrs(i, :); % Get the global DOFs for the current element
    MODEL.K(ptrs, ptrs) = MODEL.K(ptrs, ptrs) + Kc_el; % Assemble the local matrix into the global matrix
end

% --- Compute the residual vector (external forces - internal forces)
MODEL.res = MODEL.F - MODEL.fint;

% --- Save data for free DOFs (constrained DOFs will be handled separately)
constr_dofs = MODEL.constr_dofs; % Indices of constrained degrees of freedom (e.g., boundary conditions)

% Store the full stiffness matrix and force vector before applying constraints
MODEL.K_cons = MODEL.K;
MODEL.F_cons = MODEL.F;
MODEL.Fhat_cons      = MODEL.Fhat;
MODEL.res_cons = MODEL.res;
MODEL.fint_cons = MODEL.fint;

% --- Apply boundary conditions: Remove rows and columns for constrained DOFs
MODEL.K_cons(constr_dofs, :) = [];
MODEL.K_cons(:, constr_dofs) = [];
MODEL.res_cons(constr_dofs, :) = [];
MODEL.F_cons(constr_dofs, :) = [];
MODEL.Fhat_cons( constr_dofs, : )   = [];
MODEL.fint_cons(constr_dofs, :) = [];

return

