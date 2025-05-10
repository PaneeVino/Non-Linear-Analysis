function [MODEL, SOL] = initialize(MODEL, SOL)

MODEL.XX = MODEL.nodes; 
MODEL.xx = MODEL.XX;     

increm = linspace(1,SOL.nincrmax, SOL.nincrmax);

SOL.lambdas = increm*SOL.dlambda0;

SOL.Dlambda = 0;
SOL.dlambda = 0;
SOL.lambda  = 0;
MODEL.DU_eq = zeros(MODEL.nfreedof, 1);
SOL.Dlambda_eq = 0;

return