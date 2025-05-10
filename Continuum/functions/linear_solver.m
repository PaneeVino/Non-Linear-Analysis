function [MODEL, SOL, POST] = linear_solver(MODEL, SOL, POST, MATERIAL)

SOL.nincr    = 1; 
SOL.niter    = 1;
[MODEL, SOL] = build_fext(MODEL, SOL);
MODEL.DU_con = zeros(MODEL.nfree_dofs, 1);
SOL.Dlambda  = 0;

% Step 2: Build the global stiffness matrix (K) based on the model and material properties
MODEL = build_K_matrix(MODEL, MATERIAL);

% Step 3: Solve the linear system of equations for the displacements
MODEL = solve_structure(MODEL, SOL);

MODEL = update_geometry(MODEL);

MODEL = update_displacements(MODEL);

POST = POST_update_deformed_shape( POST, MODEL, SOL);

POST = POST_stress_recovery( POST, MODEL, MATERIAL, SOL);

return

