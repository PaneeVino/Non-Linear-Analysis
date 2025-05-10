function ELEMENT = get_sigma(ELEMENT, MATERIAL, KINEMATICS)

E = MATERIAL.E;
nu = MATERIAL.nu;
F = KINEMATICS.F;
J = KINEMATICS.J;
dim = size(F, 1);
n = dim * (dim+1) / 2;

sigma = nan(dim);
sigma_voigt = nan(n, 1);
I = eye(dim);

switch MATERIAL.mat_type

    case 'NL_UL_neohookean'

        b = F * F.';
        mu = E/(2*(1+nu));
        lambda = E*nu/((1+nu)*(1-2*nu));

        switch dim

            case 2

                sigma = mu*(b - I/J^2);

            case 3

                sigma = mu/J*(b-I) +lambda/J*log(J)*I;

        end

        if strcmp(KINEMATICS.formul, 'TL')
            sigma = J*(F\I)*sigma*(F\I).';

        end

        for i = 1 : dim

            for j = 1 : dim

                I_voigt = tensorToVoigtIndex(i, j, dim);

                if isnan(sigma_voigt(I_voigt))

                    sigma_voigt(I_voigt) = sigma(i, j);

                end

            end

        end

    case 'NL_TL_plane_stress'

        c_voigt = ELEMENT.c;

        switch KINEMATICS.formul
            
            case 'UL'
                E_tens       = 1/2 * (I - (F\I)'*(F\I)); %almansi

            case 'TL'
                E_tens       = 1/2 * (F'*F - I); %green-lagrange

        end

        % E_voigt = nan(n, 1);
        % 
        % 
        % for i = 1 : dim
        % 
        %     for j = 1 : dim
        % 
        %         I_voigt = tensorToVoigtIndex(i, j, dim);
        % 
        %         if isnan(E_voigt(I_voigt))
        % 
        %             E_voigt(I_voigt) = E_tens(i, j);
        % 
        %         end
        % 
        %     end
        % 
        % end
        % 
        % if dim == 2
        % 
        %     E_voigt(3) = 2*E_voigt(3);
        % 
        % elseif dim == 3
        % 
        %     E_voigt(4) = 2*E_voigt(4);
        %     E_voigt(5) = 2*E_voigt(5);
        %     E_voigt(6) = 2*E_voigt(6);
        % 
        % end

        if dim == 2 
            E_voigt = [E_tens(1, 1); E_tens(2, 2); 2*E_tens(1, 2)];
        else
            error('only planar!')
        end
        sigma_voigt = c_voigt * E_voigt;

        % for I_voigt = 1 : length(sigma_voigt) 
        % 
        %     [i, j] = voigtToTensorIndices(I_voigt, dim);
        % 
        %     if isnan(sigma(i, j))
        % 
        %         sigma(i, j) = sigma_voigt(I_voigt);
        % 
        %     end
        % 
        %     if isnan(sigma(j, i))
        % 
        %         sigma(j, i) = sigma_voigt(I_voigt);
        % 
        %     end
        % 
        % end

        sigma = [sigma_voigt(1), sigma_voigt(3); sigma_voigt(3), sigma_voigt(2)];
end

ELEMENT.sigma_tens = sigma;
ELEMENT.sigma_voigt = sigma_voigt;

end