function INPUT = inputNL_geocantilever_biquad( int_pts )
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

%%      
% -- Problem data
L = 10;
b = 0.1478;
h = 0.1;

E = 1e8;
nu = 0.;

% --- Get load
Ftot =  269.35;

% -- Init
INPUT = struct();

% -- Elements
INPUT.integration_pts = int_pts;
% INPUT.integration_barlow = 1; %optional field: to recover stresses with Barlow set to 1; otherwise omit or set to 0;

INPUT.elements = [  1      2     21     22     23     24     25     26
      2      3     20     21     27     28     29     24
      3      4     19     20     30     31     32     28
      4      5     18     19     33     34     35     31
      5      6     17     18     36     37     38     34
      6      7     16     17     39     40     41     37
      7      8     15     16     42     43     44     40
      8      9     14     15     45     46     47     43
      9     10     13     14     48     49     50     46
     10     11     12     13     51     52     53     49  ];

% -- Nodes
nodes = [   0.           0.
 0.1           0.
 0.2           0.
 0.3           0.
 0.4           0.
 0.5           0.
 0.6           0.
 0.7           0.
 0.8           0.
 0.9           0.
  1.           0.
  1.           1.
 0.9           1.
 0.8           1.
 0.7           1.
 0.6           1.
 0.5           1.
 0.4           1.
 0.3           1.
 0.2           1.
 0.1           1.
  0.           1.
0.05           0.
 0.1          0.5
0.05           1.
  0.          0.5
0.15           0.
 0.2          0.5
0.15           1.
0.25           0.
 0.3          0.5
0.25           1.
0.35           0.
 0.4          0.5
0.35           1.
0.45           0.
 0.5          0.5
0.45           1.
0.55           0.
 0.6          0.5
0.55           1.
0.65           0.
 0.7          0.5
0.65           1.
0.75           0.
 0.8          0.5
0.75           1.
0.85           0.
 0.9          0.5
0.85           1.
0.95           0.
  1.          0.5
0.95           1. ];

INPUT.nodes = [ nodes( :, 1 )*L nodes( :, 2 )*b ];

% --- Material properties
INPUT.mat_type = 'NL_TL_plane_stress'; 
INPUT.E  = E;
INPUT.nu = nu;
INPUT.t  = h;
 
% -- Loading conditions
INPUT.load = [ 11  2 Ftot*1/6; 
               12  2 Ftot*1/6;
               52  2 Ftot*2/3; ];

% -- Boundary conditions
INPUT.spc = [ 1  1
              22 1 
              26 1
              1  2
              22 2 
              26 2 ];
          
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
INPUT.Delta_L0     = []; 
INPUT.norm_res_max = 1e-5;
INPUT.nitermax     = 99;
INPUT.nincrmax     = 99;

