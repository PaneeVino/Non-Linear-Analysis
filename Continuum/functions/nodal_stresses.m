function s = nodal_stresses(xi_eta_mat, sigma_mat, nint_p, MODEL)
% NODAL_STRESSES calculates the stresses (sxx, syy, sxy) at the nodes of a finite element
% based on the integration points and the element type (4-node or 8-node).
%
% Inputs:
%   xi_eta_mat - Matrix of integration points in natural coordinates (xi, eta).
%   sigma_mat  - Matrix of stresses at the integration points.
%   nint_p     - Number of integration points (either 2 or 3).
%   MODEL      - Structure containing element type (eltype) and other model parameters.
%
% Outputs:
%   sxx - Stress in the x-direction at the element nodes.
%   syy - Stress in the y-direction at the element nodes.
%   sxy - Shear stress at the element nodes.

% Set up the matrix A for solving the stress components
dim = MODEL.dim;
n = dim * (dim+1)/2;
s = nan(n, MODEL.eltype);
switch dim
    case 2
        switch nint_p
            case 2
                % For 2 integration points (2x2 Gauss quadrature), define a linear shape function.
                A = nan(4);  % Matrix for 4 equations (for a 4-node element).

                % Define the stress interpolation function based on shape functions
                fun = @(xi, eta, vec) [1, xi, eta, xi*eta]*vec;

                % Loop through each integration point and set up the matrix A
                for ii = 1 : nint_p^dim
                    xi = xi_eta_mat(ii, 1);
                    eta = xi_eta_mat(ii, 2);
                    A(ii, :) = [1, xi, eta, xi*eta];  % Linear shape function terms
                end

                % Solve for the stress coefficients a1, a2, a3
                a1 = A\sigma_mat(:, 1);  % Stress component in the x-direction
                a2 = A\sigma_mat(:, 2);  % Stress component in the y-direction
                a3 = A\sigma_mat(:, 3);  % Shear stress component

            case 3
                % For 3 integration points (3x3 Gauss quadrature), define a higher-order shape function.
                A = nan(9);  % Matrix for 9 equations (for an 8-node element).

                % Define the stress interpolation function for higher-order terms
                fun = @(xi, eta, vec) [1, xi, eta, xi*eta, xi^2, eta^2, xi^2*eta, xi*eta^2, xi^2*eta^2]*vec;

                % Loop through each integration point and set up the matrix A
                for ii = 1 : nint_p^2
                    xi = xi_eta_mat(ii, 1);
                    eta = xi_eta_mat(ii, 2);
                    % Higher-order shape function terms
                    A(ii, :) = [1, xi, eta, xi*eta, xi^2, eta^2, xi^2*eta, xi*eta^2, xi^2*eta^2];
                end

                % Solve for the stress coefficients a1, a2, a3
                a1 = A\sigma_mat(:, 1);  % Stress component in the x-direction
                a2 = A\sigma_mat(:, 2);  % Stress component in the y-direction
                a3 = A\sigma_mat(:, 3);  % Shear stress component
        end

        % Calculate the stresses at the element nodes based on element type
        switch MODEL.eltype
            case 4  % 4-node element (bilinear)
                % For a 4-node element, evaluate stresses at the four corners (xi = ±1, eta = ±1)
                sxx = [fun(-1, -1, a1), fun(1, -1, a1), fun(1, 1, a1), fun(-1, 1, a1)];
                syy = [fun(-1, -1, a2), fun(1, -1, a2), fun(1, 1, a2), fun(-1, 1, a2)];
                sxy = [fun(-1, -1, a3), fun(1, -1, a3), fun(1, 1, a3), fun(-1, 1, a3)];

            case 8  % 8-node element (biquadratic)
                % For an 8-node element, evaluate stresses at the four corners and midpoints.
                sxx = [fun(-1, -1, a1), fun(1, -1, a1), fun(1, 1, a1), fun(-1, 1, a1), ...
                    fun(0, -1, a1), fun(1, 0, a1), fun(0, 1, a1), fun(-1, 0, a1)];
                syy = [fun(-1, -1, a2), fun(1, -1, a2), fun(1, 1, a2), fun(-1, 1, a2), ...
                    fun(0, -1, a2), fun(1, 0, a2), fun(0, 1, a2), fun(-1, 0, a2)];
                sxy = [fun(-1, -1, a3), fun(1, -1, a3), fun(1, 1, a3), fun(-1, 1, a3), ...
                    fun(0, -1, a3), fun(1, 0, a3), fun(0, 1, a3), fun(-1, 0, a3)];
        end

        s_vm = sqrt(sxx.^2 + syy.^2 - sxx .* syy + 3 * sxy.^2);


        s = [sxx; syy; sxy; s_vm];

    case 3

        % For 2 integration points (2x2 Gauss quadrature), define a linear shape function.
        A = nan(8);  % Matrix for 8 equations (for a 8-node element).
        % Define the stress interpolation function based on shape functions
        fun = @(xi, eta, zi, vec) [1, xi, eta, zi, xi*eta, xi*zi, eta*zi, xi*eta*zi]*vec;
        % Loop through each integration point and set up the matrix A
        for ii = 1 : nint_p^dim
            xi = xi_eta_mat(ii, 1);
            eta = xi_eta_mat(ii, 2);
            zi = xi_eta_mat(ii, 3);
            A(ii, :) = [1, xi, eta, zi, xi*eta, xi*zi, eta*zi, xi*eta*zi];  % Linear shape function terms
        end
        % Solve for the stress coefficients a1, a2, a3, a4, a5, a6
        a1 = A\sigma_mat(:, 1);  % Stress component in the x-direction
        a2 = A\sigma_mat(:, 2);  % Stress component in the y-direction
        a3 = A\sigma_mat(:, 3);  % Stress component in the z-direction
        a4 = A\sigma_mat(:, 4);  % Stress component in the yz-direction
        a5 = A\sigma_mat(:, 5);  % Stress component in the xz-direction
        a6 = A\sigma_mat(:, 6);  % Stress component in the xy-direction
        pos = [-1, -1, -1;
                1, -1, -1;
                1,  1, -1;
               -1,  1, -1;
               -1, -1,  1;
                1, -1,  1;
                1,  1,  1;
               -1,  1,  1;
                0, -1, -1;
                1,  0, -1;
                0,  1, -1;
               -1,  0, -1;
                0, -1,  1;
                1,  0,  1;
                0,  1,  1;
               -1,  0,  1;
               -1, -1,  0;
                1, -1,  0;
                1,  1,  0;
               -1,  1,  0];
        sxx = nan(1, 20); syy = sxx; szz = sxx;
        syz = sxx; sxz = sxx; sxy = sxx; s_vm = sxx;
        for kk = 1 : size(pos, 1)
            x = pos(kk, 1);
            y = pos(kk, 2);
            z = pos(kk, 3);

            sxx(1, kk) = fun(x, y, z, a1);
            syy(1, kk) = fun(x, y, z, a2);
            szz(1, kk) = fun(x, y, z, a3);
            syz(1, kk) = fun(x, y, z, a4);
            sxz(1, kk) = fun(x, y, z, a5);
            sxy(1, kk) = fun(x, y, z, a6);

            s_vm(1, kk) = sqrt(0.5 * ( (sxx(1, kk)-syy(1, kk)).^2 + ...
                                       (szz(1, kk)-syy(1, kk)).^2 + ...
                                       (szz(1, kk)-sxx(1, kk)).^2 + ...
                                       6*(sxz(1, kk).^2+syz(1, kk).^2+sxy(1, kk).^2)));
        end

        s = [sxx; syy; szz; syz; sxz; sxy; s_vm];
end

end


