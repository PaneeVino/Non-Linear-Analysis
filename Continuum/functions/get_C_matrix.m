function ELEMENT = get_C_matrix(ELEMENT, MATERIAL, KINEMATICS)

E = MATERIAL.E;
nu = MATERIAL.nu;
J = KINEMATICS.J;
F = KINEMATICS.F;
dim = size(F, 1);
if dim == 2
    T  = MATERIAL.t;
end


switch MATERIAL.mat_type

    case 'L_plane_stress'

        c_voigt = E / (1 - nu^2) * [1, nu, 0; nu, 1, 0; 0, 0, (1 - nu) / 2];

        t = T;

    case 'NL_UL_neohookean'

        mu = E / (2*(1+nu));
        lambda = E*nu/((1+nu)*(1-2*nu));
        I1 = MATERIAL.I1;
        I2 = MATERIAL.I2;
        
        switch dim

            case 2
                lambda1 = 2*mu/J^2;
                mu1     = mu/J^2;
                t       = T/J;
            case 3
                lambda1 = lambda/J;
                mu1 = (mu-lambda*log(J))/J;

        end

       c_voigt = lambda1 * I1 + mu1 * I2;

    case 'NL_TL_plane_stress'

        c_voigt = E / (1 - nu^2) * [1, nu, 0; nu, 1, 0; 0, 0, (1 - nu) / 2];
        t       = T;
end

ELEMENT.c       = c_voigt;
if dim == 2
    ELEMENT.t       = t;
end

end
