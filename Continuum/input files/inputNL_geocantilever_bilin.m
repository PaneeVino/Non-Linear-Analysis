function INPUT = inputNL_geocantilever_bilin( int_pts )
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

%% Problem Data
L = 10;
h = 0.1478;
t = 0.1;

E = 1e8;
nu = 0.;

Ftot =  269.35;

%% Mesh data
% nelx = 80;
% nely = 1;

nelx = 20;
nely = 1;

%% Generate mesh
nnodesx = nelx + 1;
nnodesy = nely + 1;

nnodes = nnodesx * nnodesy;

idnodes = 1 : nnodes;
idnodes = reshape( idnodes, nnodesx, nnodesy )';

%... nodal connectivity
k = 0;
for i = 1 : nely
    for j = 1 : nelx
        k = k + 1;
        
        elements( k, : ) = [ idnodes( i, j ) idnodes( i, j+1 ) idnodes( i+1, j+1 ) idnodes( i+1, j )];
        
    end
end

%... nodal coordinates
x = linspace( 0, L, nnodesx );
y = linspace( 0, h, nnodesy );

[ X, Y ] = meshgrid( x, y );
xv = reshape( X', 1, nnodes )';
yv = reshape( Y', 1, nnodes )';

nodes = [ xv yv ];

%... spc
id_spc = idnodes( :, 1 );
spc = [ id_spc id_spc./id_spc * 1;
       id_spc id_spc./id_spc * 2; ];
   
%... loads
F_int = Ftot / ( nnodesy - 1 );
F_ext = F_int / 2;

id_loads = idnodes( :, end );
id_loads_int = [ id_loads( 2 : end - 1 ) ];
id_loads_ext = [ id_loads( 1 ); id_loads( end ) ];

loads = [ id_loads_int id_loads_int./id_loads_int*2 id_loads_int./id_loads_int*F_int;
          id_loads_ext id_loads_ext./id_loads_ext*2 id_loads_ext./id_loads_ext*F_ext];

%%      
% -- Init
INPUT = struct();

% -- Elements
INPUT.integration_pts = int_pts;
% INPUT.integration_barlow = 1; %optional field: to recover stresses with Barlow set to 1; otherwise omit or set to 0;

INPUT.elements = elements;

% -- Nodes
INPUT.nodes = nodes;

% --- Material properties
INPUT.mat_type = 'NL_TL_plane_stress'; 
INPUT.E  = E;
INPUT.nu = nu;
INPUT.t  = t;
  
% -- Loading conditions
INPUT.load = loads;

% -- Boundary conditions
INPUT.spc = spc;

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
INPUT.formul       = 'TL';
INPUT.lambda_max   = 1.;
INPUT.dlambda0     = .05; 
INPUT.Delta_L0     = 10; 
INPUT.norm_res_max = 1e-5;
INPUT.nitermax     = 99;
INPUT.nincrmax     = 99;

%% Store data
INPUT.PB_DATA.L = L;
INPUT.PB_DATA.t = t;
INPUT.PB_DATA.loaded_nodes = id_loads;
