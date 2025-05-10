function displ_tab = disp_displ(POST, MODEL, node)


dim = MODEL.dim;
l = length(POST.STEP);

lambdas = nan(l, 1);
Us = nan(l, dim);
for kk = 1 : l

    lambdas(kk) = POST.STEP(kk).lambda;
    Us(kk, :) = POST.STEP(kk).U_nodes(node, :);
end

Ux = Us(:, 1);
Uy = Us(:, 2);

if dim == 3
    Uz = Us(:, 3);
end

switch dim

    case 2

        displ_tab = table(lambdas, Ux, Uy, ...
            'VariableNames', {'lambda', 'Ux', 'Uy'});

    case 3

        displ_tab = table(lambdas, Ux, Uy, Uz, ...
            'VariableNames', {'lambda', 'Ux', 'Uy', 'Uz'});

end

disp(displ_tab)
end