function [MODEL, POST, MATERIAL, SOL] = set_model(INPUT)
% SET_MODEL initializes the finite element model, post-processing structures, 
% material properties, and solution parameters based on the input data.
%
% Inputs:
%   INPUT - Structure containing the problem definition:
%       nodes         - Matrix of nodal coordinates [n_nodes x 2]
%       elements      - Element connectivity matrix [n_elements x n_nodes_per_element]
%       spc           - Prescribed constraints (e.g., boundary conditions) [n_constraints x 2]
%       load          - External nodal loads [n_loads x 3] (node, direction, magnitude)
%       integration_pts - Number of integration points for Gaussian quadrature (1, 2, or 3)
%       E, nu, t      - Material properties (Young's modulus, Poisson's ratio, thickness)
%       sol_type      - Solution type ('linear', etc.)
%
% Outputs:
%   MODEL    - Structure containing model parameters and matrices
%   POST     - Structure for storing post-processing data
%   MATERIAL - Structure containing material properties
%   SOL      - Structure with solution parameters

% Initialize structures
MODEL = struct();
MATERIAL = struct();
SOL = struct();

% Compute degrees of freedom (DOFs) and model dimensions
nnodes = size(INPUT.nodes, 1);
dim    = size(INPUT.nodes, 2);
nels   = size(INPUT.elements, 1);
MODEL.dim = dim;
MODEL.ndof = nnodes * dim; % Total DOFs
MODEL.nfree_dofs = MODEL.ndof - size(INPUT.spc, 1);       % Free DOFs (excluding constraints)
MODEL.nels = nels;                    % Number of elements
MODEL.nnodes = nnodes;                     % Number of nodes
MODEL.eltype = size(INPUT.elements, 2);                  % Number of nodes per element
MODEL.elements = INPUT.elements;                         % Element connectivity
MODEL.nodes = INPUT.nodes;                               % Nodal coordinates
MODEL.pos = nan(nnodes, dim); % DOF map per node
MODEL.dU_nodes = zeros(size(MODEL.pos));
MODEL.U_nodes = MODEL.dU_nodes;
MODEL.formul = INPUT.formul;

for i = 1 : MODEL.nnodes
    M = i * dim;
    switch dim
        case 2
            MODEL.pos(i, :) = [M-1,M];
        case 3
           MODEL.pos(i, :) = [M-2,M-1,M];
    end
end

% Identify constrained DOFs based on specified constraints
MODEL.constr_dofs = nan(size(INPUT.spc, 1), 1);
for i = 1 : size(INPUT.spc, 1)
    MODEL.constr_dofs(i) = MODEL.pos(INPUT.spc(i, 1), INPUT.spc(i, 2));
end

% Identify free DOFs (not constrained)
MODEL.free_dofs = nan(MODEL.nfree_dofs, 1);
k = 1;
for i = 1 : MODEL.ndof
    if ~any(MODEL.constr_dofs == i) % If DOF is not in the constrained list
        MODEL.free_dofs(k) = i;
        k = k + 1;
    end
end

% Define integration rule (Gaussian quadrature)
MODEL.int_rule = struct();
switch INPUT.integration_pts
    case 1 % Single integration point
        MODEL.int_rule.x = 0;
        MODEL.int_rule.w = 2;
    case 2 % Two integration points
        MODEL.int_rule.x = [-1 / sqrt(3), 1 / sqrt(3)];
        MODEL.int_rule.w = [1, 1];
        MODEL.barlow_rule.x = 0;
        MODEL.barlow_rule.w = 2;
    case 3 % Three integration points
        MODEL.int_rule.x = [-sqrt(0.6), 0, sqrt(0.6)];
        MODEL.int_rule.w = [5 / 9, 8 / 9, 5 / 9];
        MODEL.barlow_rule.x = [-1 / sqrt(3), 1 / sqrt(3)];
        MODEL.barlow_rule.w = [1, 1];
end

nint_p = length(MODEL.int_rule.x);

% Initialize global stiffness matrix and force vectors
MODEL.K = zeros(MODEL.ndof);       % Global stiffness matrix
MODEL.F = zeros(MODEL.ndof, 1);   % External force vector
MODEL.Fhat = zeros(MODEL.ndof, 1);% Prescribed load vector

% Apply loads to the global force vector
for i = 1 : size(INPUT.load, 1)
    dof = MODEL.pos(INPUT.load(i, 1), INPUT.load(i, 2)); % Get DOF index
    MODEL.Fhat(dof) = INPUT.load(i, 3);                 % Assign load
end

% Initialize post-processing data structure
POST = struct();
MODEL.X     = zeros(MODEL.nels, MODEL.eltype); % Initial X-coordinates of elements
MODEL.Y     = MODEL.X;                        % Initial Y-coordinates of elements
MODEL.x     = MODEL.X;                        % Deformed X-coordinates of elements
MODEL.y     = MODEL.X;                        % Deformed Y-coordinates of elements
MODEL.Ux    = MODEL.X;                       % X-displacements of elements
MODEL.Uy    = MODEL.X;                       % Y-displacements of elements
MODEL.U_tot = MODEL.X;                    % Total displacement magnitude
if dim == 3
    MODEL.Z     = MODEL.X;                        % Initial Z-coordinates of elements
    MODEL.z     = MODEL.X;                        % Deformed Z-coordinates of elements
    MODEL.Uz    = MODEL.X;                        % Z-displacements of elements
end
MODEL.sigmaxx_nod = nan(size(MODEL.elements));  % Initialize stress components
MODEL.sigmayy_nod = MODEL.sigmaxx_nod;
MODEL.sigmaxy_nod = MODEL.sigmaxx_nod;
MODEL.sigmaxx= zeros(nint_p^dim, MODEL.nels);
MODEL.sigmayy = MODEL.sigmaxx;
MODEL.sigmaxy = MODEL.sigmaxx;
if dim == 3
    MODEL.sigmazz_nod = MODEL.sigmaxx_nod;
    MODEL.sigmaxz_nod = MODEL.sigmaxx_nod;
    MODEL.sigmayz_nod = MODEL.sigmaxx_nod;
    MODEL.sigmazz = MODEL.sigmaxx;
    MODEL.sigmaxz = MODEL.sigmaxx;
    MODEL.sigmayz = MODEL.sigmaxx;

end

% Store nodal coordinates for each element
for i = 1 : MODEL.nels
    Nodes = MODEL.elements(i, :);        % Nodes of the current element
    MODEL.X(i, :) = MODEL.nodes(Nodes, 1); % X-coordinates
    MODEL.Y(i, :) = MODEL.nodes(Nodes, 2); % Y-coordinates
    MODEL.x(i, :) = MODEL.X(i, :);         % Initial X-coordinates (deformed state initialized)
    MODEL.y(i, :) = MODEL.Y(i, :);         % Initial Y-coordinates (deformed state initialized)
    if dim == 3
        MODEL.Z(i, :) = MODEL.nodes(Nodes, 3); % Z-coordinates
        MODEL.z(i, :) = MODEL.Z(i, :);         % Initial Z-coordinates (deformed state initialized)
    end
end

MODEL.dUx = zeros(size(MODEL.X));
MODEL.dUy = zeros(size(MODEL.X));
if dim == 3
    MODEL.dUz = zeros(size(MODEL.X));
end
MATERIAL.mat_type = INPUT.mat_type;
switch MATERIAL.mat_type

    case 'L_plane_stress'

        MATERIAL.E = INPUT.E;   % Young's modulus
        MATERIAL.nu = INPUT.nu; % Poisson's ratio
        MATERIAL.t = INPUT.t;   % Thickness

    case 'NL_UL_neohookean'

        MATERIAL.E = INPUT.E;   % Young's modulus
        MATERIAL.nu = INPUT.nu; % Poisson's ratio

        if dim == 2
            MATERIAL.t  = INPUT.t;   % Thickness
        end

        I1          = nan(dim);
        I2          = nan(dim);

        for i = 1 : dim

            for j = 1 : dim

                dij = double(i == j);

                for r = 1 : dim

                    dir = double(i == r);
                    djr = double(j == r);

                    for s = 1 : dim

                        dis = double(i == s);
                        djs = double(j == s);
                        drs = double(r == s);

                        I_voigt = tensorToVoigtIndex(i, j, dim);
                        J_voigt = tensorToVoigtIndex(r, s, dim);

                        I1(I_voigt, J_voigt) = dij*drs;
                        I2(I_voigt, J_voigt) = dir*djs + dis*djr;
                    end
                end
            end
        end

        MATERIAL.I1 = I1;
        MATERIAL.I2 = I2;

    case 'NL_TL_plane_stress'

        MATERIAL.E = INPUT.E;   % Young's modulus
        MATERIAL.nu = INPUT.nu; % Poisson's ratio
        MATERIAL.t = INPUT.t;   % Thickness

    otherwise

        error('material not present!')

end

% Define solution parameters
SOL.type = INPUT.sol_type; % Solution type

switch SOL.type

    case 'linear'

        SOL.lambda_max = 1;   % Maximum load factor for linear problems
        SOL.dlambda0 = 1;      % Load step increment
        SOL.nincrmax = 1;
        SOL.solver = 'Newton';

    case 'nonlinear'

        SOL.lambda_max = INPUT.lambda_max;   % Maximum load factor for linear problems
        SOL.dlambda0 = INPUT.dlambda0;      % Load step increment
        SOL.solver  = INPUT.solver;
        SOL.Delta_L0 = INPUT.Delta_L0;
        SOL.norm_res_max = INPUT.norm_res_max;
        SOL.nitermax = INPUT.nitermax;
        SOL.nincrmax = INPUT.nincrmax;
end

return