function INPUT = inputNL_single_el
%
% Structure INPUT
%     integration_pts: number of integration points
%            elements: nodal connectivity
%               nodes: nodal coordinates
%            mat_type: material type (name from library)
%                   E: Young's modulus
%                  nu: Poisson's ratio
%                   t: thickness
%                      see get_C_matrix function
%                          get_stresses
%                load: [node_id component magnitude]
%                 spc: [node_id component]


% -- Init
INPUT = struct();

% -- Elements
INPUT.integration_pts = 2;
% INPUT.integration_barlow = 1; %optional field: to recover stresses with Barlow set to 1; otherwise omit or set to 0;

INPUT.elements = [   1     2     3     4 ];

% -- Nodes
INPUT.nodes = [   0.   0.
                100.   0.
                100. 100.
                  0. 100.  ];

% --- Material properties
INPUT.mat_type = 'NL_UL_neohookean'; 
INPUT.E  = 1.2675;
INPUT.nu = .5;
INPUT.t  = 0.079;
  
% -- Loading conditions
Fx = 5;
INPUT.load = [   2  1 Fx
                 3  1 Fx ];

% -- Boundary conditions
INPUT.spc = [ 1 1
              1 2
              2 2
              4 1 ];

% --- Nonlinear solver parameters
% 
%            sol_type: solution procedure
%                      'linear'
%                      'nonlinear'
%              solver: solution method
%                      'Newton'
%                      'Ramm'
%                      'Riks'
%                      'Abaqus_Riks'
%              formul: formulation for nonlinear procedure
%                      'UL': updated Lagrangian
%                      'TL': total Lagrangian (for linear analysis skip this command)
%          lambda_max: max load parameter (only for nonlinear analysis)
%            dlambda0: load increment  (only for nonlinear analysis via Newton)
%            Delta_L0: arc-length increment  (only for nonlinear analysis with arc-length)
%        norm_res_max: tolerance for iterations (only for nonlinear analysis)
%            nitermax: max number of iterations (only for nonlinear analysis)
%            nincrmax: max number of increments (only for nonlinear analysis)

INPUT.sol_type     = 'nonlinear'; 
INPUT.solver       = 'Newton'; 
INPUT.formul       = 'UL';
INPUT.lambda_max   = 1.0;
INPUT.dlambda0     =  .1;
INPUT.Delta_L0     = []; 
INPUT.norm_res_max = 1e-6;
INPUT.nitermax     = 99;
INPUT.nincrmax     = 99;







