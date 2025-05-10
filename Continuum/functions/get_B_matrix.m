function [Bc, Bg] = get_B_matrix(KINEMATICS)
% GET_B_MATRIX calculates the B matrix, which is the strain-displacement matrix.
%
% The function supports both 2D and 3D elements:
% - In 2D, the B matrix relates displacements (u, v) to strains (εxx, εyy, γxy).
% - In 3D, the B matrix relates displacements (u, v, w) to strains (εxx, εyy, εzz, γxy, γyz, γzx).
%
% Inputs:
%   KINEMATICS - Structure containing kinematic quantities:
%       - KINEMATICS.grad_N: The gradients of the shape functions with respect to global coordinates.
%         * For 2D: [2, num_nodes] (rows: x, y gradients)
%         * For 3D: [3, num_nodes] (rows: x, y, z gradients)
%
% Outputs:
%   Bc - The strain-displacement matrix (B matrix) for the element:
%       * In 2D: 3x(2*num_nodes)
%       * In 3D: 6x(3*num_nodes)

gradN = KINEMATICS.grad_N;  % Extract shape function gradients
dim = size(gradN, 1);       % Dimension (2 for 2D, 3 for 3D)
n   = dim*(dim+1)/2;
num_nodes = size(gradN, 2); % Number of nodes

switch KINEMATICS.formul

    case 'UL'

        gradN = KINEMATICS.grad_N;  % Extract shape function gradients

    case 'TL'

        GradN = KINEMATICS.Grad_N;  % Extract shape function gradients
        F = KINEMATICS.F;
end

% Initialize the B matrix based on the dimension
if dim == 2
    Bc = zeros(n, 2 * num_nodes);  % For 2D: 3 rows, 2*num_nodes columns
    for a = 1:num_nodes

        switch KINEMATICS.formul

            case 'UL'

                Nx = gradN(1, a);  % Gradient in the x-direction
                Ny = gradN(2, a);  % Gradient in the y-direction

                % Local B matrix for 2D
                Ba = [Nx, 0;
                      0,  Ny;
                      Ny, Nx];
            case 'TL'

                NX = GradN(1, a);  % Gradient in the x-direction
                NY = GradN(2, a);  % Gradient in the y-direction

                % Local B matrix for 2D
                Ba = [           NX*F(1, 1),            NX*F(2, 1);
                                 NY*F(1, 2),            NY*F(2, 2);
                      NX*F(1, 2)+NY*F(1, 1), NX*F(2, 2)+NY*F(2, 1)];
        end

        % Place the local B matrix into the global B matrix
        Bc(:, 2*a-1:2*a) = Ba;
    end
elseif dim == 3
    Bc = zeros(n, 3 * num_nodes);  % For 3D: 6 rows, 3*num_nodes columns
    for a = 1:num_nodes

        switch KINEMATICS.formul

            case 'UL'

                Nx = gradN(1, a);  % Gradient in the x-direction
                Ny = gradN(2, a);  % Gradient in the y-direction
                Nz = gradN(3, a);  % Gradient in the z-direction

                % Local B matrix for 3D
                Ba = [Nx,   0,   0;
                       0,  Ny,   0;
                       0,   0,  Nz;
                       0,  Nz,  Ny;
                       Nz,  0,  Nx;
                       Ny,   Nx, 0];
            case 'TL'

                NX = GradN(1, a);  % Gradient in the x-direction
                NY = GradN(2, a);  % Gradient in the y-direction
                NZ = GradN(3, a);  % Gradient in the z-direction

                Ba = [            NX*F(1, 1),               NX*F(2, 1),               NX*F(3, 1);
                                  NY*F(1, 2),               NY*F(2, 2),               NY*F(3, 2);
                                  NZ*F(1, 3),               NZ*F(2, 3),               NZ*F(3, 3);
                       NY*F(1, 3)+NZ*F(1, 2),    NY*F(2, 3)+NZ*F(2, 2),    NY*F(3, 3)+NZ*F(3, 2);
                       NX*F(1, 3)+NZ*F(1, 1),    NX*F(2, 3)+NZ*F(2, 1),    NX*F(3, 3)+NZ*F(3, 1);
                       NX*F(1, 2)+NY*F(1, 1),    NX*F(2, 2)+NY*F(2, 1),    NX*F(3, 2)+NY*F(3, 1)];

        end

        % Place the local B matrix into the global B matrix
        Bc(:, 3*a-2:3*a) = Ba;
    end
end

switch KINEMATICS.formul

    case 'UL'

        Bg = gradN;

    case 'TL'

        Bg = GradN;

end

end

