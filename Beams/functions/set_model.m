function [MODEL, POST, SOL] = set_model(INPUT)

% Initialize structures
MODEL = struct();
POST = struct();
SOL = struct();

nnodes = size(INPUT.nodes, 1);
nels   = size(INPUT.elements, 1);
ndof   = 3*nnodes;
ncondof = size(INPUT.spc, 1);
nfreedof = ndof - ncondof;

MODEL.nnodes = nnodes;
MODEL.nels = nels;
MODEL.ndof = ndof;
MODEL.ncondof = ncondof;
MODEL.nfreedof = nfreedof;
MODEL.nltype = INPUT.nltype;

MODEL.nodes = INPUT.nodes;
MODEL.elements = INPUT.elements;

MODEL.pos = nan(nnodes, 3);
for k = 1 : nnodes
    K = 3*k;
    MODEL.pos(k, :) = [K-2,K-1,K];
end

MODEL.constr_dofs = nan(ncondof, 1);
for k = 1 : ncondof
    I = INPUT.spc(k, 1);
    J = INPUT.spc(k, 2);
    MODEL.constr_dofs(k) = MODEL.pos(I, J);
end

MODEL.free_dofs = nan(nfreedof, 1);
kk = 1;
for k = 1 : ndof
    if ~any(MODEL.constr_dofs == k)
        MODEL.free_dofs(kk) = k;
        kk = kk + 1;
    end
end

MODEL.int_rule = struct();
switch INPUT.integration_pts
    case 1 % Single integration point
        MODEL.int_rule.x = 0;
        MODEL.int_rule.w = 2;
    case 2 % Two integration points
        MODEL.int_rule.x = [-1 / sqrt(3), 1 / sqrt(3)];
        MODEL.int_rule.w = [1, 1];
    case 3 % Three integration points
        MODEL.int_rule.x = [-sqrt(0.6), 0, sqrt(0.6)];
        MODEL.int_rule.w = [5 / 9, 8 / 9, 5 / 9];
end

% Initialize global stiffness matrix and force vectors
MODEL.K = zeros(ndof);       % Global stiffness matrix
MODEL.F = zeros(ndof, 1);   % External force vector
MODEL.Fhat = zeros(ndof, 1);% Prescribed load vector

% Apply loads to the global force vector
for i = 1 : size(INPUT.load, 1)
    dof = MODEL.pos(INPUT.load(i, 1), INPUT.load(i, 2)); % Get DOF index
    MODEL.Fhat(dof) = INPUT.load(i, 3);                 % Assign load
end

MODEL.X = zeros(nels, 2);
MODEL.Y = zeros(nels, 2);

MODEL.x = zeros(nels, 2);
MODEL.y = zeros(nels, 2);

MODEL.u = zeros(nels, 2);
MODEL.w = zeros(nels, 2);
MODEL.phi = zeros(nels, 2);

MODEL.dU = zeros(nels, 2);
MODEL.dW = zeros(nels, 2);
MODEL.dPhi = zeros(nels, 2);

for i = 1 : nels
    Nodes = MODEL.elements(i, :);
    MODEL.X(i, :) = MODEL.nodes(Nodes, 1); 
    MODEL.Y(i, :) = MODEL.nodes(Nodes, 2); 
    MODEL.x(i, :) = MODEL.X(i, :);        
    MODEL.y(i, :) = MODEL.Y(i, :);         
end

MODEL.EA = INPUT.EA;
MODEL.EJ = INPUT.EJ;
MODEL.GA = INPUT.GA;

SOL.lambda_max = INPUT.lambda_max;   % Maximum load factor for linear problems
SOL.dlambda0 = INPUT.dlambda0;      % Load step increment
SOL.solver  = INPUT.solver;
SOL.Delta_L0 = INPUT.Delta_L0;
SOL.norm_res_max = INPUT.norm_res_max;
SOL.nitermax = INPUT.nitermax;
SOL.nincrmax = INPUT.nincrmax;

end

