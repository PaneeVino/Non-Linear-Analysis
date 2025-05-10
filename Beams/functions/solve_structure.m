function [MODEL, SOL] = solve_structure(MODEL, SOL)

switch SOL.solver

    case 'Newton'

        if SOL.niter == 1
            SOL.lambda = SOL.lambda + SOL.dlambda0;
        end
        
        MODEL.res_cons = SOL.lambda * MODEL.Fhat_cons - MODEL.fint_cons;
        MODEL.dU_con = MODEL.K_cons \ MODEL.res_cons;
        SOL.dlambda  = 0;

    case 'Modified_Newton'

        if SOL.niter == 1
            SOL.lambda = SOL.lambda + SOL.dlambda0;
        end

        MODEL.res_cons = SOL.lambda * MODEL.Fhat_cons - MODEL.fint_cons;
        MODEL.dU_con = MODEL.K_cons \ MODEL.res_cons;
        SOL.dlambda  = 0;

    case 'Riks'

        if SOL.niter == 1

            [ MODEL, SOL ] = predictor( MODEL, SOL);

        else 

            dU_I = MODEL.K_cons \ MODEL.Fhat_cons;
            dU_II = MODEL.K_cons \ MODEL.res_cons;

            SOL.dlambda = - MODEL.DU_1' * dU_II / ( MODEL.DU_1' * dU_I + ...
                SOL.Dlambda_1 * MODEL.Fhat_cons' * MODEL.Fhat_cons );

            MODEL.dU_con = dU_II + SOL.dlambda * dU_I;

        end

    case 'Ramm'

        if SOL.niter == 1

            [ MODEL, SOL ] = predictor( MODEL, SOL);

        else 

            dU_I = MODEL.K_cons \ MODEL.Fhat_cons;
            dU_II = MODEL.K_cons \ MODEL.res_cons;

            Num = -(MODEL.DU_con' * dU_II );
            Den = (MODEL.DU_con' * dU_I + SOL.Dlambda * MODEL.F_cons' * MODEL.F_cons);
            SOL.dlambda = Num / Den;

            MODEL.dU_con = dU_II + SOL.dlambda * dU_I;

        end

    case 'Crisfield'


        if SOL.niter == 1

            [ MODEL, SOL ] = predictor( MODEL, SOL);

        else 

            dU_I = MODEL.K_cons \ MODEL.Fhat_cons;
            dU_II = MODEL.K_cons \ MODEL.res_cons;

            beta = 1;
            % a2*l^2 + a1*l + a0 = 0
            a2 = dU_I'*dU_I + beta^2*MODEL.Fhat_cons'*MODEL.Fhat_cons;
            a1 = 2*(MODEL.DU_con+dU_II)'*dU_I + ...
                2*beta^2*SOL.Dlambda*MODEL.Fhat_cons'*MODEL.Fhat_cons;
            a0 = (MODEL.DU_con+dU_II)'*(MODEL.DU_con+dU_II) + ...
                beta^2*SOL.Dlambda^2*MODEL.Fhat_cons'*MODEL.Fhat_cons - SOL.Delta_L0^2;

            Delta = a1^2 - 4*a2*a0;
            if Delta < 0
                error('Delta<0!')
            end
            SOL.dlambda = (-a1 + sqrt(Delta))/(2*a2);
            
            MODEL.dU_con = dU_II + SOL.dlambda * dU_I;

        end
        
end

MODEL.DU_con = MODEL.DU_con + MODEL.dU_con;
MODEL.dU = zeros(MODEL.ndof, 1);
for k = 1 : MODEL.nfreedof
    MODEL.dU(MODEL.free_dofs(k)) = MODEL.dU_con(k);  
end

MODEL.U_dof = MODEL.U_dof + MODEL.dU; %global ref frame

SOL.lambda  = SOL.lambda + SOL.dlambda;
SOL.Dlambda = SOL.Dlambda + SOL.dlambda;

end