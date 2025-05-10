function [MODEL, SOL, POST] = nonlinear_solver(MODEL, SOL, POST, MATERIAL)

% --- Begin incremental procedure: load steps
SOL.nincr = 1;
exit_flag = 0;

while ~exit_flag && SOL.nincr<= SOL.nincrmax && abs(SOL.lambda-SOL.lambda_max) > eps && SOL.lambda<SOL.lambda_max

    % Initial residual and stiffness
    MODEL = build_K_and_forces(MODEL, MATERIAL, SOL);
    SOL.norm_res = 2 * SOL.norm_res_max; % to enter NR iter;
    MODEL.DU_con = zeros(MODEL.nfree_dofs, 1);
    SOL.Dlambda  = 0;
    
    % --- Iterative loop (Newton-Raphson)
    SOL.niter = 1;
    while (SOL.norm_res > SOL.norm_res_max && SOL.niter <= SOL.nitermax)
        
        % Solve, update configuration, and recompute
        [MODEL, SOL] = solve_structure(MODEL, SOL);

        MODEL = update_displacements(MODEL);
        MODEL = update_geometry(MODEL);

        if strcmp(SOL.solver, 'Modified_Newton')

            MODEL = build_forces(MODEL, MATERIAL, SOL);

        else

            MODEL = build_K_and_forces(MODEL, MATERIAL, SOL);

        end

        SOL.norm_res = norm( MODEL.res_cons ) / norm( MODEL.F_cons );

        % Increment iteration counter
        SOL.niter = SOL.niter + 1;

        % ... display error in case max iter exceeded
        if SOL.niter == SOL.nitermax
            warning( 'Too many iterations are needed' );
            exit_flag = 1;
        end
    end

    MODEL.DU_eq = MODEL.DU_con;
    MODEL.Dlambda_eq = SOL.Dlambda;
    % --- Store results
    POST = store_equil_res( MODEL, SOL, POST, MATERIAL );

    fprintf('increments: %d   iterations: %d    norm_res: %e\n', SOL.nincr, SOL.niter-1, SOL.norm_res)

    % Update increment counter
    SOL.nincr = SOL.nincr + 1;
end

end
