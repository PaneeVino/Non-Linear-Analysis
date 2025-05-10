function [i, j] = voigtToTensorIndices(I, dim)
    % Convert Voigt index I back to tensor indices (i, j)
    % Works for both 2D and 3D cases
    % Input:
    %   I   - Voigt index (1-based)
    %   dim - Dimension (2 or 3)
    % Output:
    %   i, j - Tensor indices corresponding to Voigt index I
    
    if dim == 2
        % Voigt mapping for 2D
        switch I
            case 1
                i = 1; j = 1; % xx
            case 2
                i = 2; j = 2; % yy
            case 3
                i = 1; j = 2; % xy
            otherwise
                error('Invalid Voigt index for 2D.');
        end
    elseif dim == 3
        % Voigt mapping for 3D
        switch I
            case 1
                i = 1; j = 1; % xx
            case 2
                i = 2; j = 2; % yy
            case 3
                i = 3; j = 3; % zz
            case 4
                i = 1; j = 2; % xy
            case 5
                i = 2; j = 3; % yz
            case 6
                i = 3; j = 1; % zx
            otherwise
                error('Invalid Voigt index for 3D.');
        end
    else
        error('Dimension must be 2 or 3.');
    end
end
