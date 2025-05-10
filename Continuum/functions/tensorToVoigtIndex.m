function I = tensorToVoigtIndex(i, j, dim)
    % Map tensor indices (i,j) to Voigt index I for 2D or 3D tensors
    if dim == 2
        % 2D Voigt mapping
        if i == j
            I = i; % Normal components: 1 -> 1, 2 -> 2
        else
            I = 3; % Shear components: 12 or 21 -> 3
        end
    elseif dim == 3
        % 3D Voigt mapping
        if i == j
            I = i; % Normal components: 1 -> 1, 2 -> 2, 3 -> 3
        else
            % Shear components
            if (i == 2 && j == 3) || (i == 3 && j == 2)
                I = 4; % yz -> 4
            elseif (i == 1 && j == 3) || (i == 3 && j == 1)
                I = 5; % zx -> 5
            elseif (i == 1 && j == 2) || (i == 2 && j == 1)
                I = 6; % xy -> 6
            else
                error('Invalid tensor indices (%d, %d) for dim = %d.', i, j, dim);
            end
        end
    else
        error('Dimension must be 2 or 3.');
    end
end
