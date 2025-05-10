function [N, Nx] = shape_fun(xi, alpha, le)

if alpha == 1

    N = 1/2*(1-xi);
    Nx = -1/le;

elseif alpha == 2

    N = 1/2*(1+xi);
    Nx = 1/le;

end

end