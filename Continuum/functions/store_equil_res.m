function POST = store_equil_res( MODEL, SOL, POST, MATERIAL )

    POST = POST_update_deformed_shape(POST, MODEL, SOL);
    POST = POST_stress_recovery(POST, MODEL, MATERIAL, SOL);
    POST.STEP(SOL.nincr).lambda = SOL.lambda;
    POST.STEP(SOL.nincr).norm_res = SOL.norm_res;
    POST.STEP(SOL.nincr).niter    = SOL.niter;

end