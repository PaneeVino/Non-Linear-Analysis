function POST = store_equil_res( MODEL, SOL, POST)

    POST = POST_update_deformed_shape(POST, MODEL, SOL);
    POST = POST_update_displacements( POST, MODEL, SOL );
    POST.STEP(SOL.nincr).lambda = SOL.lambda;
    POST.STEP(SOL.nincr).F = SOL.lambda*norm(MODEL.Fhat_cons);
    POST.STEP(SOL.nincr).norm_res = SOL.norm_res;
    POST.STEP(SOL.nincr).niter    = SOL.niter;

end