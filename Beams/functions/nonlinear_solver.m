function [MODEL, SOL, POST] = nonlinear_solver(MODEL, SOL, POST)

MODEL.U_dof = zeros(MODEL.ndof, 1);
[MODEL, SOL] = initialize(MODEL, SOL);

SOL.nincr = 1;
exit_flag = 0;

while ~exit_flag && SOL.nincr<= SOL.nincrmax && abs(SOL.lambda-SOL.lambda_max) > eps && SOL.lambda<SOL.lambda_max

    MODEL = build_K_and_forces(MODEL, SOL);
    SOL.norm_res = 2 * SOL.norm_res_max;
    MODEL.DU_con = zeros(MODEL.nfreedof, 1);
    SOL.Dlambda = 0;

    SOL.niter = 1;
    while (SOL.norm_res > SOL.norm_res_max && SOL.niter <= SOL.nitermax)

        [MODEL, SOL] = solve_structure(MODEL, SOL);
        MODEL = update_geometry(MODEL);

        if strcmp(SOL.solver, 'Modified_Newton')
            MODEL = build_forces(MODEL);
        else
            MODEL = build_K_and_forces(MODEL, SOL);
        end

        SOL.norm_res = norm( MODEL.res_cons ) / norm( MODEL.F_cons );
        SOL.niter = SOL.niter+1;

        if SOL.niter == SOL.nitermax
            warning( 'Too many iterations are needed' );
            exit_flag = 1;
        end
   
    end

    MODEL.DU_eq = MODEL.DU_con;
    SOL.Dlambda_eq = SOL.Dlambda;
    POST = store_equil_res( MODEL, SOL, POST);
    fprintf('increments: %d   iterations: %d    norm_res: %e\n', SOL.nincr, SOL.niter-1, SOL.norm_res)
    SOL.nincr = SOL.nincr + 1;
 
end

end