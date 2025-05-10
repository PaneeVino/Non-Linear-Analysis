function displ_tab = disp_displ_and_stresses(POST, MODEL, node)

[Rows, Columns] = find(MODEL.elements == node);
[El, ind] = min(Rows);
Nod = Columns(ind);

dim = MODEL.dim;
n = dim * (dim + 1) /2;
l = length(POST.STEP);

lambdas = nan(l, 1);
Us = nan(l, dim);
Ss = nan(l, n);
for kk = 1 : l

    Ux = POST.STEP(kk).Ux(El, Nod);
    Uy = POST.STEP(kk).Uy(El, Nod);
    Sxx = POST.STEP(kk).sigmaxx(Nod, El);
    Syy = POST.STEP(kk).sigmayy(Nod, El);
    Sxy = POST.STEP(kk).sigmaxy(Nod, El);
    if dim == 3
        Uz = POST.STEP(kk).Uz(El, Nod);
        Szz = POST.STEP(kk).sigmazz(Nod, El);
        Syz = POST.STEP(kk).sigmayz(Nod, El);
        Sxz = POST.STEP(kk).sigmaxz(Nod, El);
    end
    lambdas(kk) = POST.STEP(kk).lambda;
    if dim == 2
        Us(kk, :) = [Ux, Uy];
        Ss(kk, :) = [Sxx, Syy, Sxy];
    elseif dim == 3
        Us(kk, :) = [Ux, Uy, Uz];
        Ss(kk, :) = [Sxx, Syy, Szz, Syz, Sxz, Sxy];
    end
end

Ux = Us(:, 1);
Uy = Us(:, 2);
Sxx = Ss(:, 1);
Syy = Ss(:, 2);

if dim == 2
    Sxy = Ss(:, 3);

elseif dim == 3
    Uz = Us(:, 3);
    Szz = Ss(:, 3);
    Syz = Ss(:, 4);
    Sxz = Ss(:, 5);
    Sxy = Ss(:, 6);

end

switch dim

    case 2

        displ_tab = table(lambdas, Ux, Uy, Sxx, Syy, Sxy, ...
            'VariableNames', {'lambda', 'Ux', 'Uy', 'sigma_xx', ...
            'sigma_yy', 'sigma_xy'});

    case 3

        displ_tab = table(lambdas, Ux, Uy, Uz, ...
            Sxx, Syy, Szz, Syz, Sxz, Sxy, ...
            'VariableNames', {'lambda', 'Ux', 'Uy', 'Uz', ...
            'sigma_xx', 'sigma_yy', 'sigma_zz', ...
            'sigma_yz', 'sigma_xz', 'sigma_xy'});

end

disp(displ_tab)
end