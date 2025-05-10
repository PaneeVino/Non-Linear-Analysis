function INPUT = inputNLB_beam_bending( type, n_int, method, Delta_L0, nltype )
%
% INPUT = inputNLB_beam_bending( type, n_int )
%
% Input file for nonlinear bending analysis of thin and thick beams
% Cantilever beam with tip load
% Abaqus files available: bending_thin.inp and bending_thick.inp
%
% INPUT:  type: 'thin' or 'thick'
%         n_int: number of integration points      
%
% OUTPUT: INPUT: struct with input
%
% Authors
% =======
% Riccardo Vescovini (riccardo.vescovini@polimi.it)
% DAER, Politecnico di Milano
% February 2024

% --- My data: Material properties
E = 72000;
G = E / ( 2 * ( 1 + .3 ) );
L = 300;

switch type
    
    case 'thin'
        
        h  = 3;
        
    case 'thick'
        
        h = 30;
        
end

A = h * h;
J = 1 / 12 * h^4;

P = 10 * E * J / L^2;

%%
% -- Init
INPUT = struct();

% -- Elements
INPUT.integration_pts = n_int;

INPUT.L = L;
INPUT.elements = [ 1  2
    2  3
    3  4
    4  5
    5  6
    6  7
    7  8
    8  9
    9 10
    10 11
    11 12
    12 13
    13 14
    14 15
    15 16
    16 17
    17 18
    18 19
    19 20
    20 21
    21 22
    22 23
    23 24
    24 25
    25 26
    26 27
    27 28
    28 29
    29 30
    30 31 ];

% -- Nodes
INPUT.nodes = [ 0 0.
    10 0.
    20 0.
    30 0.
    40 0.
    50 0.
    60 0.
    70 0.
    80 0.
    90 0.
    100 0.
    110 0.
    120 0.
    130 0.
    140 0.
    150 0.
    160 0.
    170 0.
    180 0.
    190 0.
    200 0.
    210 0.
    220 0.
    230 0.
    240 0.
    250 0.
    260 0.
    270 0.
    280 0.
    290 0.
    300 0. ];

% --- Section properties
INPUT.EA = E * A;
INPUT.EJ = E * J;
INPUT.GA = G * A;

% --- Loading conditions
INPUT.P = P;
INPUT.load = [ 31 2 P; ];

% --- Boundary conditions
INPUT.spc = [ 1 1
    1 2
    1 3 ];

% --- Nonlinear solver parameters
INPUT.sol_type     = 'nonlinear';
INPUT.nltype       = nltype; % choose between 'vK' and 'full'
INPUT.solver       = method; % choose between 'Riks' and 'Newton'
INPUT.lambda_max   = 1.;
INPUT.dlambda0     = .05;
INPUT.norm_res_max = 1e-5;
INPUT.nitermax     = 200;
%
INPUT.Delta_L0      = Delta_L0; % only for arc-length (ignored with NR)
INPUT.nincrmax     = 500;
