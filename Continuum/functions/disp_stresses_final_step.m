function sigma_tab = disp_stresses_final_step(POST, MODEL, element, str)

% ind = nan;
% 
% for kk = 1 : length(POST.STEP)
% 
%     if abs(lambda -POST.STEP(kk).lambda) < eps
%         ind = kk;
%     end
% end

STEP = POST.STEP(end);
dim   = MODEL.dim;

switch str

    case 'int_points'

        rule  = length(MODEL.int_rule.w);
        nrows = rule^dim;

    case 'nodes'

        nrows = MODEL.eltype;

    otherwise

        error('Only int_points or nodes!')

end

ncol = dim*(dim+1)/2;

sigmas = nan(nrows, ncol);

switch str

    case 'int_points'

        switch dim

            case 2

                sigmas(:, 1) = STEP.sigmaxx(:, element);
                sigmas(:, 2) = STEP.sigmayy(:, element);
                sigmas(:, 3) = STEP.sigmaxy(:, element);

            case 3

                sigmas(:, 1) = STEP.sigmaxx(:, element);
                sigmas(:, 2) = STEP.sigmayy(:, element);
                sigmas(:, 3) = STEP.sigmazz(:, element);
                sigmas(:, 4) = STEP.sigmayz(:, element);
                sigmas(:, 5) = STEP.sigmaxz(:, element);
                sigmas(:, 6) = STEP.sigmaxy(:, element);

        end

    case 'nodes'

        switch dim

            case 2

                sigmas(:, 1) = (STEP.sigmaxx_nod(element, :)).';
                sigmas(:, 2) = (STEP.sigmayy_nod(element, :)).';
                sigmas(:, 3) = (STEP.sigmaxy_nod(element, :)).';

            case 3

                sigmas(:, 1) = (STEP.sigmaxx_nod(element, :)).';
                sigmas(:, 2) = (STEP.sigmayy_nod(element, :)).';
                sigmas(:, 3) = (STEP.sigmazz_nod(element, :)).';
                sigmas(:, 4) = (STEP.sigmayz_nod(element, :)).';
                sigmas(:, 5) = (STEP.sigmaxz_nod(element, :)).';
                sigmas(:, 6) = (STEP.sigmaxy_nod(element, :)).';

        end

    otherwise

        error('Only int_points or nodes!')

end

switch dim

    case 2

        sigma_xx = sigmas(:, 1);
        sigma_yy = sigmas(:, 2);
        sigma_xy = sigmas(:, 3);

        sigma_tab = table(sigma_xx, sigma_yy, sigma_xy, ...
            'VariableNames', {'sxx', 'syy', 'sxy'});

    case 3

        sigma_xx = sigmas(:, 1);
        sigma_yy = sigmas(:, 2);
        sigma_zz = sigmas(:, 3);
        sigma_yz = sigmas(:, 4);
        sigma_xz = sigmas(:, 5);
        sigma_xy = sigmas(:, 6);

        sigma_tab = table(sigma_xx, sigma_yy, sigma_zz, ...
            sigma_yz, sigma_xz, sigma_xy, ...
            'VariableNames', {'sxx', 'syy', 'szz', 'syz', 'sxz', 'sxy'});

end

disp(sigma_tab)

end
