function [MODEL, POST, SOL] = fem_solver(INPUT)

[MODEL, POST, SOL] = set_model(INPUT);
MODEL = set_assembly_vectors(MODEL);
[MODEL, SOL, POST] = nonlinear_solver(MODEL, SOL, POST);

%post_process(POST, MODEL);

end