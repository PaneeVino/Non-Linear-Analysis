function INPUT = inputNLB_frame_wriggers
%
% INPUT = inputNLB_frame_wriggers
%
% Input file for nonlinear bending analysis of the frame
% reported on
% P. Wriggers, Nonlinear Finite Element Method, p. 344
% Abaqus files available: frame_wriggers.inp
% Note: use 1 integration point. With 2 points or more --> shear locking!
%
% INPUT:  none
%
% OUTPUT: INPUT: struct with input
%
% Authors
% =======
% Riccardo Vescovini (riccardo.vescovini@polimi.it)
% DAER, Politecnico di Milano
% February 2024

%%
% -- Init
INPUT = struct();

% -- Elements
INPUT.integration_pts = 1;

INPUT.elements = [ 1      2
 2      3
 3      4
 4      5
 5      6
 6      7
 7      8
 8      9
 9     10
10     11
11     12
12     13
13     14
14     15
15     16
16     17
17     18
18     19
19     20
20     21 ];

% -- Nodes
INPUT.nodes = [   0.   0
  0.  30
  0.  60
  0.  90
  0. 120
  0. 150
  0. 180
  0. 210
  0. 240
  0. 270
  0. 300
 30. 300
 60. 300
 90. 300
120. 300
150. 300
180. 300
210. 300
240. 300
270. 300
300. 300 ];

% --- Material properties
INPUT.EA = 10 * 1e5;
INPUT.EJ = 2 * 1e5;
INPUT.GA = 1e5;

% -- Loading conditions
INPUT.load = [ 12 2 -110 ];

% -- Boundary conditions
INPUT.spc = [ 1 1
    1 2
    21 1
    21 2 ];

% --- Nonlinear solver parameters
INPUT.sol_type     = 'nonlinear';
INPUT.nltype       = 'full'; % choose between 'vK' and 'full'
INPUT.solver       = 'Ramm'; % choose between 'Riks' and 'Newton'
INPUT.dlambda0     = .01; % only for NR (ignored with arc-length)
INPUT.lambda_max   = 1.;
INPUT.Delta_L0      = 20; % only for arc-length (ignored with NR)
INPUT.norm_res_max = 1e-5;
INPUT.nitermax     = 200;
INPUT.nincrmax     = 500;
