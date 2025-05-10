function [MODEL, SOL, POST, MATERIAL] = fem_solver(INPUT)

[MODEL, POST, MATERIAL, SOL]  = set_model(INPUT);

MODEL = set_assembly_vectors(MODEL);

[MODEL, SOL] = initialize(MODEL, SOL);

switch SOL.type
    case 'linear'
        [MODEL, SOL, POST] = linear_solver(MODEL, SOL, POST, MATERIAL);
    case 'nonlinear'
        [MODEL, SOL, POST] = nonlinear_solver(MODEL, SOL, POST, MATERIAL);
    otherwise
        error('Unsupported solver type: %s. Choose either "linear" or "nonlinear".', SOL.type);
end

POST = post_process(MODEL, POST);

end

