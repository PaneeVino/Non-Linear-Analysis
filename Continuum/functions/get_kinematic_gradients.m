function KINEMATICS = get_kinematic_gradients(ELEMENT, xi, eta, zi)

KINEMATICS = struct(); 
numArgs = nargin;

XX = ELEMENT.XX.';
xx = ELEMENT.xx.';
KINEMATICS.nnodes = size(XX, 2);

switch numArgs

    case 3

        switch KINEMATICS.nnodes

            case 4

                grad_xi_N = 1/4 * [
                    -(1-eta), (1-eta), (1+eta), -(1+eta);
                    -(1-xi) , -(1+xi), (1+xi) , (1-xi)
                    ];

            case 8

                grad_xi_N = 1/4 * [
                    -(2*xi+eta)*(eta-1), -(2*xi-eta)*(eta-1), (2*xi+eta)*(eta+1), (2*xi-eta)*(eta+1), ...
                    4*xi*(eta-1)       , 2-2*eta^2          , -4*xi*(eta+1)     , 2*eta^2-2;

                    -(xi+2*eta)*(xi-1) , -(xi-2*eta)*(xi+1) , (xi+2*eta)*(xi+1) , (xi-2*eta)*(xi-1), ...
                    2*xi^2-2           , -4*eta*(xi+1)      , 2-2*xi^2          , 4*eta*(xi-1)
                    ];

        end

    case 4

        % grad_xi_N = [((eta - 1)*(zi - 1)*(eta + 2*xi + zi + 1))/8, -((eta - 1)*(zi - 1)*(eta - 2*xi + zi + 1))/8, -((eta + 1)*(zi - 1)*(eta + 2*xi - zi - 1))/8, -((eta + 1)*(zi - 1)*(2*xi - eta + zi + 1))/8, -((eta - 1)*(zi + 1)*(eta + 2*xi - zi + 1))/8, ((eta - 1)*(zi + 1)*(eta - 2*xi - zi + 1))/8, ((eta + 1)*(zi + 1)*(eta + 2*xi + zi - 1))/8, -((eta + 1)*(zi + 1)*(eta - 2*xi + zi - 1))/8, -(xi*(eta - 1)*(zi - 1))/2,  ((eta^2 - 1)*(zi - 1))/4, (xi*(eta + 1)*(zi - 1))/2,  -((eta^2 - 1)*(zi - 1))/4, (xi*(eta - 1)*(zi + 1))/2,  -((eta^2 - 1)*(zi + 1))/4, -(xi*(eta + 1)*(zi + 1))/2,  ((eta^2 - 1)*(zi + 1))/4,  -((zi^2 - 1)*(eta - 1))/4,  ((zi^2 - 1)*(eta - 1))/4,  -((zi^2 - 1)*(eta + 1))/4,  ((zi^2 - 1)*(eta + 1))/4;
        %     ((xi - 1)*(zi - 1)*(2*eta + xi + zi + 1))/8,  -((xi + 1)*(zi - 1)*(2*eta - xi + zi + 1))/8,  -((xi + 1)*(zi - 1)*(2*eta + xi - zi - 1))/8,  -((xi - 1)*(zi - 1)*(xi - 2*eta + zi + 1))/8,  -((xi - 1)*(zi + 1)*(2*eta + xi - zi + 1))/8,  ((xi + 1)*(zi + 1)*(2*eta - xi - zi + 1))/8,  ((xi + 1)*(zi + 1)*(2*eta + xi + zi - 1))/8,  -((xi - 1)*(zi + 1)*(2*eta - xi + zi - 1))/8,   -((xi^2 - 1)*(zi - 1))/4, (eta*(xi + 1)*(zi - 1))/2,   ((xi^2 - 1)*(zi - 1))/4, -(eta*(xi - 1)*(zi - 1))/2,   ((xi^2 - 1)*(zi + 1))/4, -(eta*(xi + 1)*(zi + 1))/2,   -((xi^2 - 1)*(zi + 1))/4, (eta*(xi - 1)*(zi + 1))/2,   -((zi^2 - 1)*(xi - 1))/4,   ((zi^2 - 1)*(xi + 1))/4,   -((zi^2 - 1)*(xi + 1))/4,   ((zi^2 - 1)*(xi - 1))/4;
        %     ((eta - 1)*(xi - 1)*(eta + xi + 2*zi + 1))/8, -((eta - 1)*(xi + 1)*(eta - xi + 2*zi + 1))/8, -((eta + 1)*(xi + 1)*(eta + xi - 2*zi - 1))/8, -((eta + 1)*(xi - 1)*(xi - eta + 2*zi + 1))/8, -((eta - 1)*(xi - 1)*(eta + xi - 2*zi + 1))/8, ((eta - 1)*(xi + 1)*(eta - xi - 2*zi + 1))/8, ((eta + 1)*(xi + 1)*(eta + xi + 2*zi - 1))/8, -((eta + 1)*(xi - 1)*(eta - xi + 2*zi - 1))/8,  -((xi^2 - 1)*(eta - 1))/4,  ((eta^2 - 1)*(xi + 1))/2,  ((xi^2 - 1)*(eta + 1))/4,  -((eta^2 - 1)*(xi - 1))/2,  ((xi^2 - 1)*(eta - 1))/4,  -((eta^2 - 1)*(xi + 1))/2,  -((xi^2 - 1)*(eta + 1))/4,  ((eta^2 - 1)*(xi - 1))/2, -(zi*(eta - 1)*(xi - 1))/2, (zi*(eta - 1)*(xi + 1))/2, -(zi*(eta + 1)*(xi + 1))/2, (zi*(eta + 1)*(xi - 1))/2];
        [N_xi, N_eta, N_z] = shape_function_20(xi, eta, zi);
        grad_xi_N = [N_xi;N_eta;N_z];

end

KINEMATICS.Jxi    = XX * grad_xi_N.';

KINEMATICS.detJxi = det(KINEMATICS.Jxi);

KINEMATICS.Grad_N = (KINEMATICS.Jxi).' \ grad_xi_N;

KINEMATICS.jxi    = xx * grad_xi_N.';

KINEMATICS.detjxi = det(KINEMATICS.jxi);

KINEMATICS.detJxi = det(KINEMATICS.Jxi);

KINEMATICS.grad_N = (KINEMATICS.jxi).' \ grad_xi_N;

KINEMATICS.F      = xx * KINEMATICS.Grad_N.';

KINEMATICS.J      = det(KINEMATICS.F);

KINEMATICS.formul = ELEMENT.formul;

return
