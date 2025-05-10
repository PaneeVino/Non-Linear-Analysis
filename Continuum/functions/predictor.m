function [ MODEL, SOL ] = predictor( MODEL, SOL)

dU_I = MODEL.K_cons \ MODEL.Fhat_cons;
SOL.dlambda = SOL.Delta_L0 / sqrt( MODEL.Fhat_cons' * MODEL.Fhat_cons + dU_I' * dU_I);

if SOL.nincr > 1
    % ... Check sign of dlambda
    if (dU_I' * MODEL.DU_eq*SOL.dlambda + SOL.dlambda * SOL.Dlambda_eq) < 0
        SOL.dlambda = -SOL.dlambda;
    end
end
% --- Result
MODEL.dU_con = SOL.dlambda * dU_I;

SOL.Dlambda_1 = SOL.dlambda;
MODEL.DU_1 = MODEL.dU_con;

end